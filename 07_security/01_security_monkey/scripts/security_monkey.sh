 #!/usr/bin/env bash


sudo mkdir /var/log/security_monkey
sudo mkdir /var/www
sudo chown -R `whoami`:www-data /var/log/security_monkey/
sudo chown www-data /var/www


sudo apt-get update
sudo apt-get -y install python-pip python-dev python-psycopg2 libpq-dev nginx supervisor git libffi-dev gcc python-virtualenv redis-server


# Install Security Monkey

cd /usr/local/src
sudo git clone --depth 1 --branch master https://github.com/Netflix/security_monkey.git
sudo chown -R `whoami`:www-data /usr/local/src/security_monkey
cd security_monkey
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
virtualenv venv
source venv/bin/activate
sudo pip install --upgrade setuptools
sudo pip install --upgrade pip
sudo pip install --upgrade urllib3[secure]   # to prevent InsecurePlatformWarning
sudo pip install google-compute-engine  # Only required on GCP
sudo pip install cloudaux\[gcp\]
sudo python setup.py develop


cd /usr/local/src/security_monkey
source venv/bin/activate


#Install user Interface

export UI_VERSION=1.1.3

#Download Web UI release
sudo wget https://github.com/Netflix/security_monkey/releases/download/$UI_VERSION/static.tar.gz -O /tmp

#Extract Web UI to appropriate destination
sudo mkdir -p /usr/local/src/security_monkey/security_monkey/static/
sudo tar -xzf /tmp/static.tar.gz -C foo/usr/local/src/security_monkey/security_monkey/static/
sudo chgrp -R www-data /usr/local/src/security_monkey