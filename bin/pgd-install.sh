
T=/tmp/instruqt-setup.log
exec > >(tee -a $T) 2>&1

if [ -f $HOME/.edb-env ]; then
  source $HOME/.edb-env
fi


if [ -z $EDB_SUBSCRIPTION_TOKEN ]; then
  echo "Subscription token not set - chickening out of script"
  exit 0
fi

# For PGD Expanded, there are two repositories to install.
echo "Adding repositories"
curl -1sSLf "https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/$EDB_SUBSCRIPTION_PLAN/setup.$EDB_REPO_TYPE.sh" | sudo -E bash
curl -1sSLf "https://downloads.enterprisedb.com/$EDB_SUBSCRIPTION_TOKEN/postgres_distributed/setup.$EDB_REPO_TYPE.sh" | sudo -E bash



export PG_FLAVOR=edb-as
export PG_VERSION=17
export PATH="$PATH:/usr/lib/${PG_FLAVOR}/$PG_VERSION/bin"
export PGDATA=/var/lib/$PG_FLAVOR/$PG_VERSION/main
export EDB_PACKAGES="${PG_FLAVOR}${PG_VERSION}-server edb-pgd6-expanded-epas${PG_VERSION} edb-pgd6-cli"

echo "Install $EDB_PACKAGES"
sudo apt install -y $EDB_PACKAGES

# Stop and disable the Debian-managed service
systemctl stop ${PG_FLAVOR}@${PG_VERSION}-main
systemctl disable ${PG_FLAVOR}@${PG_VERSION}-main

# Wipe everything
rm -rf $PGDATA
rm -rf /etc/$PG_FLAVOR/$PG_VERSION/main