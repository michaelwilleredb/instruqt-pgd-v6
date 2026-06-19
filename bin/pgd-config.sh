sudo  -iu enterprisedb bash << 'EOF'
echo "$0 - running"
export dbuser=enterprisedb
export dbport=5444
export dbname=pgddb

export PG_VERSION=17
export PATH=$PATH:/usr/edb/as-common/bin
export PGDATA=/var/lib/edb-as/$PG_VERSION/main/
export PGPASSWORD=secret

hostname=$(hostname)

# Link all config-files (workaround for the pgd CLI)
find /etc/edb-as/17/main -maxdepth 1  -exec ln -sf {} /var/lib/edb-as/17/main/ \;


db1_dsn="host=db-1 user=$dbuser port=$dbport dbname=$dbname"
db2_dsn="host=db-2 user=$dbuser port=$dbport dbname=$dbname"
db3_dsn="host=db-3 user=$dbuser port=$dbport dbname=$dbname"

extra_options="--bindir /usr/lib/edb-as/17/bin"

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
pg_ctl restart -D $PGDATA

EOF