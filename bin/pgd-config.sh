#
# 
#
export dbuser=enterprisedb
export dbport=5444
export dbname=pgddb

export PG_FLAVOR=edb-as
export PG_VERSION=17
export PATH=$PATH:/usr/lib/$PG_FLAVOR/$PG_VERSION/bin
export PGDATA=/var/lib/$PG_FLAVOR/$PG_VERSION/main/
export PGPASSWORD=secret

hostname=$(hostname)


# Removing the pre-installed database
systemctl stop edb-as@17-main
rm -rf $PGDATA
rm -rf /etc/edb-as/17/main


sudo  -iu enterprisedb bash << EOF
echo "$hostname - running"
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

systemctl restart edb-as@17-main
until $PG_BINDIR/pg_isready -h localhost -p 5444; do sleep 1; done
