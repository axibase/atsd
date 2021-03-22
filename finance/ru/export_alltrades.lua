local EXPORT_DIR = 'C:/trade_log'
local POWERSHELL_PATH = '"C:\\Program Files\\PowerShell\\7\\pwsh.exe"'
local ZIP_SCRIPT_PATH = EXPORT_DIR .. '/zipf.ps1'
local UPLOAD_SCRIPT_PATH = EXPORT_DIR .. '/psf.ps1'

-- Replace log calls with your own logging library or implementation
local log={};
function log.info(msg, ...)
  return message(string.format(msg, ...), 1)
end
function log.warn(msg, ...)
  return message(string.format(msg, ...), 2)
end
function log.error(msg, ...)
  return message(string.format(msg, ...), 3)
end

function OnStop()
  return 500
end

function main()

  while true do
    -- sleep 15 minutes
    local sleep_ms = 1000*60*15
    local utc_date = os.date('!*t')
    -- start exporting after 21:00 UTC (00:00 MSK)
    log.info('UTC time: %s:%s:%s', utc_date.hour, utc_date.min, utc_date.sec);
    if utc_date.hour >= 21 then
      local res = export_all_trades()
      if res == true then
        -- export successful, wait 3 hours, then switch to checking every 15 minutes, until next evening
        sleep_ms = 1000*60*60 * 3
      end
    end
    log.info('sleep %s', sleep_ms)
    sleep(sleep_ms)
  end
  
end

function export_all_trades()

  local csv_path = EXPORT_DIR .. '/all_trades_'.. os.date("%Y%m%d") .. '.csv'
  local csv_zip_path = EXPORT_DIR .. '/all_trades_'.. os.date("%Y%m%d") .. '.zip'
  log.info('path: %s', csv_path)

  if io.open(csv_path, "r") ~= nil then
    log.info('skip. file exists: %s', csv_path)
    return false
  end

  if io.open(csv_zip_path, "r") ~= nil then
    log.info('skip. zip file exists: %s', csv_zip_path)
    return false
  end

  local total_count = getNumberOf("all_trades");
  if total_count <= 0 then
    log.info('skip. no trades');
    return;
  end  

  local first_trade = getItem("all_trades", 0);
  local last_trade =  getItem("all_trades", total_count-1);

  log.info('first trade: %s', obj_to_string(trade_to_tags(first_trade), true))
  log.info(' last trade: %s',  obj_to_string(trade_to_tags(last_trade), true))

  local last_dt = ("%04d-%02d-%02d"):format(last_trade.datetime.year, last_trade.datetime.month, last_trade.datetime.day)
  local update_log = EXPORT_DIR .. '/upload_' .. last_dt .. '.log'

  if io.open(update_log, "r") ~= nil then
    log.info('update_log exists: %s', update_log)
    return false
  end  

  local out = io.open(csv_path, 'w');
  if out == nil then
    log.error('failed to open file for writing: %s', csv_path)
    return false
  end

  out:write('trade_num,command_time,micros,class,code,exchange,operation,quantity,price,order\n')
  out:flush();

  log.info('total count: %s', tostring(total_count))
  local time_start = os.clock()
  local write_count = 0

  for i = 0, total_count-1 do
    local trade = getItem("all_trades", i);
    local cc = trade.class_code

    local operation = ''
    if bit.test(trade.flags, 0) then
        operation = 'S'
    elseif bit.test(trade.flags, 1) then
        operation = 'B'
    end

    --current time must be the same as UTC
    local millis = os.time(trade.datetime) * 1000 + trade.datetime.ms;
    local micros = math.fmod(trade.datetime.mcs, 1000)
    
    local exchange = 'QUIK'
    local tn = trade.trade_num -- string.format('%d', trade.trade_num) -- LUA 5.3
    local cmd = tn .. ',' .. millis .. ',' .. micros .. ',' .. cc .. ',' .. trade.sec_code .. ',' .. exchange .. ',' .. operation .. ',' .. trade.qty .. ',' .. trade.price .. ','
    out:write(cmd .. '\n');

    write_count = write_count+1

    if math.fmod(i, 500000) == 0 then
        log.info('ok: %s : %s', i, obj_to_string(trade_to_tags(trade), true))
        log.info('%s', cmd)
        out:flush();
    end

  end

  out:flush();
  out:close();
  out = nil;

  log.info('done % s /%s to %s in %s', write_count, total_count, csv_path, os.clock() - time_start);

  local in_file = io.open(csv_path, "r");
  local in_size = in_file and in_file:seek("end") or 0;
  log.info('input file %s size: %s', csv_path, in_size)

  in_file:close();
  in_file = nil;

  local zip_cmd = POWERSHELL_PATH .. ' -file ' .. ZIP_SCRIPT_PATH .. ' -src ' .. csv_path .. ' -dst ' .. csv_zip_path .. ''
  
  log.info('zip file with cmd: %s', zip_cmd)

  local cres = os.execute(zip_cmd)

  log.info('zip completed. status %s', obj_to_string(cres, true))

  local zip_file = io.open(csv_zip_path, "r");

  if zip_file == nil then
    log.error('zip file is not found at %s. sleep 1 min', csv_zip_path);
    sleep(60000)
    zip_file = io.open(csv_zip_path, "r");
    if zip_file == nil then
      log.error('zip file is not found at %s after sleep', csv_zip_path);
      return true;
    end
  end

  local zip_size = zip_file:seek("end");
  zip_file:close();
  zip_file = nil

  log.info('zip %s size: %s ', csv_zip_path, zip_size)

  if (cres == true or eq(cres, 0)) and zip_size > 10000 then
    log.info('zip file %s created. delete plain file: %s', csv_zip_path, csv_path)
    
    local upload_cmd = POWERSHELL_PATH .. ' -file ' .. UPLOAD_SCRIPT_PATH .. ' -path ' .. csv_zip_path .. ' > ' .. update_log .. ' 2>&1'

    log.info('upload file with cmd: %s', upload_cmd)

    local ures = os.execute(upload_cmd)
    local uout = read_file_as_string(update_log)
    log.info('upload completed. status %s out: \n%s', obj_to_string(ures, true), tostring(uout))
    
    if (ures == true or eq(ures, 0)) and uout ~= nil and uout:find(''..zip_size) ~= nil then
      log.info('file uploaded. delete plain file: %s', csv_path)
      os.remove(csv_path)
      -- update_log serves as lock file
    else
      log.error('file not uploaded: %s status: %s', csv_path, uout)
      -- remove to retry
      os.remove(update_log)
    end
    
  else
    log.error('zip file %s is too small: %s. skip plain file deletion', csv_zip_path, zip_size)
  end

  return true

end