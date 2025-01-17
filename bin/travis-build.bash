#!/bin/bash
set -e

echo "This is travis-build.bash..."

echo "-----------------------------------------------------------------"
echo "Installing the packages that CKAN requires..."
sudo apt-get update -qq
sudo apt-get install solr-jetty libcommons-fileupload-java libpq-dev postgresql postgresql-contrib python-lxml postgresql-9.3-postgis-2.1

echo "Extra pips ..."
pip install setuptools -U

echo "-----------------------------------------------------------------"
echo "Installing CKAN and its Python dependencies..."

cd .. # CircleCI starts inside ckanext-datajson folder
pwd
ls -la

if [ $CKANVERSION == '2.8' ]
then
	git clone https://github.com/ckan/ckan.git
	cd ckan
	git checkout 2.8
elif [ $CKANVERSION == '2.3' ]
then
	git clone https://github.com/ckan/ckan.git
	cd ckan
	git checkout release-v2.3
	pip install wheel
elif [ $CKANVERSION == 'inventory' ]
then
	git clone https://github.com/GSA/ckan.git
	cd ckan
	git checkout inventory
	pip install wheel
elif [ $CKANVERSION == 'datagov' ]
then
	git clone https://github.com/GSA/ckan.git
	cd ckan
	git checkout datagov
	pip install wheel
fi

echo "Setup CKAN"
python setup.py develop
cp ./ckan/public/base/css/main.css ./ckan/public/base/css/main.debug.css

echo "Installing CKAN requirements..."
pip install -r requirements.txt

echo "Installing CKAN dev-requirements..."
pip install -r dev-requirements.txt

cd ..
echo "-----------------------------------------------------------------"
echo "Setting up Solr..."
# solr is multicore for tests on ckan master now, but it's easier to run tests
# on Travis single-core still.
# see https://github.com/ckan/ckan/issues/2972
sed -i -e 's/solr_url.*/solr_url = http:\/\/127.0.0.1:8983\/solr/' ckan/test-core.ini
printf "NO_START=0\nJETTY_HOST=127.0.0.1\nJETTY_PORT=8983\nJAVA_HOME=$JAVA_HOME" | sudo tee /etc/default/jetty
sudo cp ckan/ckan/config/solr/schema.xml /etc/solr/conf/schema.xml
sudo service jetty restart

echo "-----------------------------------------------------------------"
echo "Creating the PostgreSQL user and database..."
sudo -u postgres psql -c "CREATE USER ckan_default WITH PASSWORD 'pass';"
sudo -u postgres psql -c 'CREATE DATABASE ckan_test WITH OWNER ckan_default;'
sudo -u postgres psql -c 'CREATE DATABASE datastore_test WITH OWNER ckan_default;'

echo "-----------------------------------------------------------------"
echo "Initialising the database..."
cd ckan
paster db init -c test-core.ini

cd ..
echo "-----------------------------------------------------------------"
echo "Installing Harvester"
git clone https://github.com/ckan/ckanext-harvest
cd ckanext-harvest
git checkout master

python setup.py develop
pip install -r pip-requirements.txt

paster harvester initdb -c ../ckan/test-core.ini

cd ..
echo "-----------------------------------------------------------------"
echo "Installing ckanext-datajson and its requirements..."
cd ckanext-datajson
pip install -r pip-requirements.txt
python setup.py develop

echo "-----------------------------------------------------------------"
echo "Moving test.ini into a subdir..."
mkdir subdir
mv test.ini subdir

echo "travis-build.bash is done."