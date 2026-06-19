#
# pgd_config.sh
#

sudo  -iu enterprisedb bash << 'EOF'

export dbuser=enterprisedb
export dbport=5444
export dbname=pgd

export PG_FLAVOR=edb-as
export PG_VERSION=17
export PG_BINDIR=/usr/lib/$PG_FLAVOR/$PG_VERSION/bin
export PATH=$PATH:$PG_BINDIR
export PGDATA=/var/lib/$PG_FLAVOR/$PG_VERSION/pgd
export PGPASSWORD=secret

hostname=$(hostname)

echo "$hostname - running"

db1_dsn="host=db-1 user=$dbuser port=$dbport dbname=$dbname"
db2_dsn="host=db-2 user=$dbuser port=$dbport dbname=$dbname"
db3_dsn="host=db-3 user=$dbuser port=$dbport dbname=$dbname"

extra_options="--bindir $PG_BINDIR -D $PGDATA"

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

psql -p $dbport -U $dbuser postgres -c "ALTER USER enterprisedb PASSWORD '$PGPASSWORD';"
psql -p $dbport -U $dbuser postgres -c "ALTER SYSTEM SET listen_addresses = '*';"

$PG_BINDIR/pg_ctl restart -D $PGDATA -l /var/log/edb-as/${PG_FLAVOR}-${PG_VERSION}-${dbname}.log
until $PG_BINDIR/pg_isready -h localhost -p $dbport -U $dbuser; do sleep 1; done

EOF
