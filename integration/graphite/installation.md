# Installing Graphite-Web with ATSD Storage Finder

Using this guide you can install Graphite-Web to include Carbon daemons, Whisper databases, and ATSD Storage Finders.

Install dependencies:

```sh
sudo apt-get install\
 python-cairo-dev\
 python-dev\
 fontconfig\
 python-fontconfig\
 apache2\
 libapache2-mod-wsgi\
 memcached\
 python-ldap\
 rabbitmq-server\
 rrdtool\
 python-rrdtool\
 apache2-utils\
 libapache2-mod-python\
 sqlite3\
 python-pysqlite2\
 python-pip
```

```sh
sudo pip install\
 django\
 django-tagging\
 twisted\
 zope.interface\
 pytz\
 python-memcached\
 txAMQP\
 pyparsing
```

Install Graphite Carbon and Whisper:

```sh
sudo pip install https://github.com/graphite-project/carbon/archive/master.zip
```

```sh
sudo pip install https://github.com/graphite-project/whisper/archive/master.zip
```

Install ATSD Storage Finder:

```sh
sudo pip install https://github.com/axibase/atsd-graphite-finder/archive/master.zip
```

Install Graphite-Web with `atsd_finder`:

```sh
sudo pip install https://github.com/axibase/graphite-web/archive/atsd_storage.zip
```

Configure Graphite:

You can find example files in the `/opt/graphite/conf` directory.

```sh
cd /opt/graphite/conf
sudo cp carbon.conf.example carbon.conf
sudo cp storage-schemas.conf.example storage-schemas.conf
sudo cp graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
```

Create `local_settings.py`:

```sh
cd /opt/graphite/webapp/graphite
sudo cp local_settings.py.example local_settings.py
```

In `local_settings.py` change the `SECRET_KEY` setting to a random number.

Configure your finders:

In the `local_settings.py` file specify the storage finders, ATSD hostname/IP, ATSD port, ATSD username, and ATSD password ([as described here](storage-finder.md)):

```python
STORAGE_FINDERS = (
    'atsd_finder.AtsdFinder',
    'atsd_finder.AtsdFinderV',
    'graphite.finders.standard.StandardFinder',
)
```

```json
ATSD_CONF = {
    'url': 'http://atsd_server:8088',
    'username': 'atsd_username',
    'password': 'secret_pwd',
}
```

Configure Apache2 `wsgi`:

```sh
cd /opt/graphite/examples
sudo cp example-graphite-vhost.conf /etc/apache2/sites-available/graphite-web.conf
```

Disable default site configuration:

```sh
sudo a2dissite 000-default
```

Enable graphite-web site configuration:

```sh
sudo a2ensite graphite-web
```

Setup Django database schema:

```sh
sudo PYTHONPATH=/opt/graphite/webapp django-admin.py syncdb --settings=graphite.settings
```

Set Apache2 ownership for the storage directory:

```sh
sudo chown -R www-data:www-data /opt/graphite/storage/
```

Restart Apache2:

```sh
sudo /etc/init.d/apache2 reload
```

Web interface should now be available on local port 80. ATSD metrics should also be visible.

Run carbon-cache:

```sh
cd /opt/graphite/bin
sudo python carbon-cache.py start
```

Within a few minutes you should see carbon metrics in the web interface.
