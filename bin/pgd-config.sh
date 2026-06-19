#
# This script expects a Debian/Ubuntu install, with the "strange" placement of GUC files
# 
#

sudo  -iu enterprisedb bash << 'EOF'
echo "$0 - running"
export dbuser=enterprisedb
export dbport=5444
export dbname=pgddb

export PG_FLAVOR=edb-as
export PG_VERSION=17
export PATH=$PATH:/usr/lib/$PG_FLAVOR/$PG_VERSION/bin
export PGDATA=/var/lib/$PG_FLAVOR/$PG_VERSION/main/
export PGPASSWORD=secret

hostname=$(hostname)

# Link all config-files (workaround for the pgd CLI) - pgd CLI can't use the Debian flavor placement
# And it's more PostgreSQL to have them live in the PGDATA directory
find /etc/$PG_FLAVOR/17/main -maxdepth 1  -exec ln -sf {} /var/lib/$PG_FLAVOR/17/main/ \;


db1_dsn="host=db-1 user=$dbuser port=$dbport dbname=$dbname"
db2_dsn="host=db-2 user=$dbuser port=$dbport dbname=$dbname"
db3_dsn="host=db-3 user=$dbuser port=$dbport dbname=$dbname"

extra_options="--bindir /usr/lib/$PG_FLAVOR/17/bin"

case $hostname in
  db-1)
    echo "execute: pgd node node-1 setup --dsn \"$db1_dsn\"  --group-name group-1 $extra_options"
    pgd node node-1 setup --dsn "$db1_dsn"  --group-name group-1 $extra_options
    ;;
  db-2)
    echo "execute: pgd node node-2 setup --dsn \"$db2_dsn\"  --group-name group-1 --cluster-dsn \"$db1_dsn\" $extra_options"
    pgd node node-2 setup --dsn "$db2_dsn"  --group-name group-1 --cluster-dsn "$db1_dsn" $extra_options
    ;;
  db-3)
    echo "execute: pgd node node-3 setup --dsn \"$db3_dsn\"  --group-name group-1 --cluster-dsn \"$db1_dsn\" $extra_options"
    pgd node node-3 setup --dsn "$db3_dsn"  --group-name group-1 --cluster-dsn "$db1_dsn" $extra_options
    ;;
  *)
    echo "ERROR: UNKNOWN host"
    exit 0
    ;;
esac

psql -p $dbport -U $dbuser edb -c "ALTER SYSTEM SET listen_addresses = '*';"
EOF

export PG_BINDIR=/usr/lib/edb-as/17/bin
export PATH=$PATH:$PG_BINDIR

systemctl restart edb-as@17-main
until $PG_BINDIR/pg_isready -h localhost -p 5444; do sleep 1; done
