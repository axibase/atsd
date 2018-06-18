#!/usr/bin/env python3
from atsd_client import connect
from atsd_client.models import *
from atsd_client.services import *
from prettytable import PrettyTable

import logging
logger = logging.getLogger()
logger.disabled = True

# Connect to ATSD server
connection = connect('connection.properties')
#connection = connect_url('https://atsd_hostname:8443', 'user', 'password')

# specify date interval
startDate = "previous_day"
endDate =   "current_day"
tags = {'http_referer': '*'}

service = MessageService(connection)

ef = EntityFilter(entity="*")
df = DateFilter(start_date=startDate, end_date=endDate)
query = MessageQuery(entity_filter=ef, date_filter=df, type="web", source="access.log", tags=tags, limit=10000)
message_list = service.query(query)
t = PrettyTable(['Date', 'URI', 'Referrer', 'IP', 'Org'])

excluded_domains = ['google', 'axibase.com', 'yandex.ru', 'baidu.com', 'statcounter.com', 'bing.com', 'duckduckgo.com', 'jshell.net', 'facebook.com']

for msg in message_list:
    rf = msg.tags['http_referer']
    uri = msg.tags['request_uri']

    if any(domain in rf for domain in excluded_domains):
        continue
    if '/ec2-monitoring' in uri:
        continue
    t.add_row([msg.date.strftime("%Y-%m-%d %H:%M"), uri, rf, msg.tags['remote_addr'], msg.tags['geoip_org']])

t.sortby = "Date"

print(t.get_html_string(title="Daily Referrer Requests"))
