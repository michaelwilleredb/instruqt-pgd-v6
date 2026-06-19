#
# pgd_config.sh
#
restart_db(){
  systemctl restart pgd # Ensure clean start
  until $PG_BINDIR/pg_isready -h localhost -p $dbport; do sleep 1; done
}
create_service(){
  cat > /etc/systemd/system/pgd.service << SVC_EOF
[Unit]
Description=EDB Postgres $PG_VERSION PGD Node
After=network.target

[Service]
Type=forking
User=enterprisedb
Environment=PGDATA=$PGDATA
ExecStart=$PG_BINDIR/pg_ctl start -D $PGDATA
ExecStop=$PG_BINDIR/pg_ctl stop -D $PGDATA
ExecReload=$PG_BINDIR/pg_ctl reload -D $PGDATA
TimeoutSec=300

[Install]
WantedBy=multi-user.target
SVC_EOF

systemctl daemon-reload
systemctl enable pgd
}

export dbuser=enterprisedb
export dbport=5444
export dbname=edb

export PG_FLAVOR=edb-as
export PG_VERSION=17
export PG_BINDIR=/usr/lib/$PG_FLAVOR/$PG_VERSION/bin
export PATH=$PATH:$PG_BINDIR
export PGDATA=/var/lib/$PG_FLAVOR/$PG_VERSION/pgd
export PGPASSWORD=secret

hostname=$(hostname)

create_service

sudo  -iu enterprisedb bash << EOF

echo "$hostname - running"

export PATH=$PATH:$PG_BINDIR
export PGDATA=$PGDATA
export PGPASSWORD=$PGPASSWORD

db1_dsn="host=db-1 user=$dbuser port=$dbport dbname=$dbname"
db2_dsn="host=db-2 user=$dbuser port=$dbport dbname=$dbname"
db3_dsn="host=db-3 user=$dbuser port=$dbport dbname=$dbname"

extra_options="--bindir $PG_BINDIR -D $PGDATA"

case $hostname in
  db-1)
    echo "Create the initial database"
    ${PG_BINDIR}/initdb -U enterprisedb ${PGDATA}

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
EOF

restart_db
