#!/bin/bash
###############################################################################
# Aim  ########################################################################
###############################################################################

# Install a working version of GBrowse
# based on a modified version of: https://github.com/scottcain/GMODintheCloud/blob/master/GitC2_build

###############################################################################
# Make sure everything is up to date before starting ##########################
###############################################################################

sudo apt-get --yes update
sudo apt-get --yes upgrade


###############################################################################
# Install GBrowse dependencies ################################################
###############################################################################

# The -y flag: apt-get will assume yes for all questions. apt-get will abort if it encounters a bad situation (e.g., removing an essential package)
sudo apt-get install -y libbio-samtools-perl amap-align apache2 apache2-mpm-worker apache2-utils apache2.2-bin apache2.2-common bedtools bioperl bioperl-run blast2 bowtie bwa cmap-adobe-japan1 dialign emboss emboss-data emboss-lib exonerate fontconfig fontconfig-config fonts-liberation ghostscript graphviz gs-cjk-resource gsfonts hmmer infernal javascript-common kalign libace-perl libalgorithm-c3-perl libalgorithm-munkres-perl libapache-dbi-perl libapache2-mod-perl2 libapache2-reload-perl libapr1 libaprutil1 libaprutil1-dbd-sqlite3 libaprutil1-ldap libarray-compare-perl libavahi-client3 libavahi-common-data libavahi-common3 libb-hooks-endofscope-perl libbio-asn1-entrezgene-perl libbio-graphics-perl libbio-perl-perl libbio-perl-run-perl libbio-scf-perl libbit-vector-perl libbsd-resource-perl libcache-cache-perl libcairo2 libcap2 libcarp-clan-perl libcdt4 libcgi-session-perl libcgraph5 libclass-c3-perl libclass-c3-xs-perl libclass-inspector-perl libclass-load-perl libclass-load-xs-perl libclone-perl libcommon-sense-perl libconvert-binary-c-perl libconvert-binhex-perl libcrypt-ssleay-perl libcups2 libcupsimage2 libdata-optlist-perl libdata-stag-perl libdate-calc-perl libdate-calc-xs-perl libdate-manip-perl libdatrie1 libdbd-mysql-perl libdbd-pg-perl libdbd-sqlite3-perl libdbi-perl libdevel-globaldestruction-perl libdevel-partialdump-perl libdevel-symdump-perl liberror-perl libeval-closure-perl libfcgi-perl libfontconfig1 libfreezethaw-perl libgd-gd2-perl libgd-svg-perl libgd2-xpm libgraph-perl libgraph4 libgraphviz-perl libgs9 libgs9-common libgvc5 libgvpr1 libheap-perl libhpdf-2.2.1 libice6 libijs-0.35 libio-pty-perl libio-stringy-perl libipc-run-perl libipc-sharelite-perl libjasper1 libjbig2dec0 libjcode-pm-perl libjpeg-turbo8 libjpeg8 libjs-prototype libjs-scriptaculous libjson-perl libjson-xs-perl liblcms2-2 liblist-moreutils-perl libmath-derivative-perl libmath-spline-perl libmime-tools-perl libmldbm-perl libmodule-runtime-perl libmoose-perl libmro-compat-perl libmysqlclient18 libnamespace-clean-perl libncbi6 libnet-daemon-perl libole-storage-lite-perl libossp-uuid-perl libossp-uuid16 libpackage-deprecationmanager-perl libpackage-stash-perl libpackage-stash-xs-perl libpango1.0-0 libpaper-utils libpaper1 libparams-classify-perl libparams-util-perl libparse-recdescent-perl libpathplan4 libperl5.14 libpixman-1-0 libplrpc-perl libpostscript-perl libpq5 libreadline5 libruby1.8 libset-scalar-perl libsm6 libsoap-lite-perl libsort-naturally-perl libspreadsheet-parseexcel-perl libspreadsheet-writeexcel-perl libstaden-read1 libstatistics-descriptive-perl libsub-exporter-perl libsub-identify-perl libsub-install-perl libsvg-graph-perl libsvg-perl libtask-weaken-perl libterm-readkey-perl libthai-data libthai0 libtie-ixhash-perl libtiff4 libtree-dagnode-perl libtry-tiny-perl libunicode-map-perl libvariable-magic-perl libxaw7 libxcb-render0 libxcb-shm0 libxft2 libxml-dom-perl libxml-dom-xpath-perl libxml-filter-buffertext-perl libxml-libxml-perl libxml-libxslt-perl libxml-perl libxml-regexp-perl libxml-sax-writer-perl libxml-twig-perl libxml-writer-perl libxml-xpath-perl libxml-xpathengine-perl libxmu6 libxpm4 libxrender1 libxslt1.1 libxt6 libyaml-perl libyaml-syck-perl lynx lynx-cur mafft maq muscle mysql-common ncbi-data perl-doc perl-tk phyml primer3 probcons ruby ruby1.8 samtools sim4 sqlite3 ssl-cert t-coffee tigr-glimmer ttf-dejavu-core ttf-liberation wise wwwconfig-common x11-common libnet-openid-consumer-perl libnet-smtp-ssl-perl make libbio-chado-schema-perl postgresql postgresql-client postgresql-plperl-9.1 postgis postgresql-contrib

###############################################################################
# Configuring postgres ########################################################
###############################################################################
#config postgres
sudo ./postgres_conf.sh

#re-start postgres
sudo /etc/init.d/postgresql restart

###############################################################################
# Install additional dependencies #############################################
###############################################################################

sudo apt-get install --yes xsltproc libgo-perl libdbix-dbschema-perl libdbix-dbstag-perl


###############################################################################
# Update the bashrc file ######################################################
###############################################################################

sudo cat modify_paths_file.txt >> ~/.bashrc


###############################################################################
# Install some perl modules and dependencies ##################################
###############################################################################

#First download a standalone copy of cpanm, that will allow us to automate the installation of the modules
sudo curl -LO http://xrl.us/cpanm
sudo chmod +x cpanm

#install modules
./cpanm --sudo -q Bio::Graphics
./cpanm --sudo -q Parse::Apache::ServerStatus

sudo apt-get --yes install unzip libpng-dev libssl-dev


###############################################################################
# Make Kent ###################################################################
###############################################################################

mkdir sources
cd sources
wget http://hgdownload.cse.ucsc.edu/admin/jksrc.zip
unzip jksrc.zip
cd kent/src/lib/

#not sure about this one
export    MACHTYPE=i686

# add the CFLAGS=-fPIC line to the file kent/src/ind/common.mk
sed -i .bk 's/\(^CC=.*$\)/\1'$'\\\nCFLAGS=-fPIC/g' common.mk

make

#create a environment variable for the Kent source directory
export KENT_SRC=/home/ubuntu/sources/kent/src

###############################################################################
# Install Interface to bigwig and bigbed files ################################
###############################################################################

./cpanm --sudo -q Bio::DB::BigFile

###############################################################################
# Install Php #################################################################
###############################################################################

sudo apt-get --yes install php5 php5-pgsql php5-gd git

###############################################################################
# Enable the Apache rewrite module and restart ################################
###############################################################################

sudo a2enmod rewrite

sudo /etc/init.d/apache2 restart

###############################################################################
# Install Drupal ##############################################################
###############################################################################

cd ~/sources
wget http://ftp.drupal.org/files/projects/drupal-6.28.tar.gz
tar zxvf drupal-6.28.tar.gz
sudo mv drupal-6.28/* drupal-6.28/.htaccess /var/www/
cd /var/www
sudo cp sites/default/default.settings.php sites/default/settings.php
sudo chmod o+w sites/default/settings.php
chmod o+w sites/default