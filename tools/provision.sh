MYSQL_PASSWORD="root"

echo "[vagrant provisioning] Checking if the box was already provisioned..."

if [ -e "/home/vagrant/.provision_check" ]
then
  # Skipping provisioning if the box is already provisioned
  echo "[vagrant provisioning] The box is already provisioned..."
  exit
fi

# Update Ubuntu
echo "[vagrant provisioning] Update the system..."
sudo apt-get update
sudo apt-get -f -y install

# Adding Packages
echo "[vagrant provisioning] Adding repositories the packages for development..."
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo add-apt-repository -y ppa:chris-lea/redis-server
sudo add-apt-repository -y ppa:nginx/stable
sudo add-apt-repository -y ppa:webupd8team/java
sudo wget -qO - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | sudo apt-key add -
sudo echo "deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list
sudo add-apt-repository -y ppa:git-core/ppa

# Update packages
echo "[vagrant provisioning] Update the packages..."
sudo apt-get update

# nginx
echo "[vagrant provisioning] Installing nginx..."
sudo apt-get -y install nginx

# MySQL
echo "[vagrant provisioning] Installing mysql-server and mysql-client..."
echo mysql-server mysql-server/root_password select $MYSQL_PASSWORD | debconf-set-selections
echo mysql-server mysql-server/root_password_again select $MYSQL_PASSWORD | debconf-set-selections
sudo apt-get -y install mysql-server mysql-client

# NodeJS
echo "[vagrant provisioning] Installing nodejs..."
sudo apt-get -y install nodejs

# Update packages
echo "[vagrant provisioning] Updating packages"
sudo apt-get update

# Npm
echo "[vagrant provisioning] Installing Npm"
sudo apt-get -y install npm

# MongoDB
echo "[vagrant provisioning] Processing MongoDB"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10

echo "[vagrant provisioning] Creating list for MongoDB"
sudo echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

echo "[vagrant provisioning] Updating system before install MongoDB"
sudo apt-get update

echo "[vagrant provisioning] Installing MongoDB"
sudo apt-get install -y mongodb-org

echo "[vagrant provisioning] Starting MongoDB"
sudo service mongod start

# Java
echo "[vagrant provisioning] Installing Java..."
echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
sudo apt-get -y install oracle-jdk7-installer

# Elasticsearch
echo "[vagrant provisioning] Installing elasticsearch..."
sudo apt-get -y install elasticsearch
sudo /etc/init.d/elasticsearch start
sudo update-rc.d elasticsearch defaults 95 10

# Redis
echo "[vagrant provisioning] Installing redis..."
sudo apt-get -y install redis-server

# Git
echo "[vagrant provisioning] Installing git..."
sudo apt-get -y install git

# VIM
echo "[vagrant provisioning] Installing vim..."
sudo apt-get -y install vim

# Packages
echo "[vagrant provisioning] Installing additional packages..."
sudo apt-get -y install gcc autoconf bison flex libtool make libboost-all-dev libcurl4-openssl-dev curl libevent-dev uuid-dev libhiredis-dev libmemcached-dev gperf build-essential

# Additinal pakcages for development
echo "[vagrant provisioning] Installing additional packages for development..."
sudo apt-get -y install graphicsmagick libgraphicsmagick-dev imagemagick libghc-iconv-dev libmsgpack-dev

# Create project directory
echo "[vagrant provisioning] Creating /projects..."
sudo mkdir /projects

# Upgrade the system packages
echo "[vagrant provisioning] Upgrade the system packages..."
sudo apt-get -y upgrade

echo "[vagrant provisioning] Creating .provision_check file..."
touch .provision_check
