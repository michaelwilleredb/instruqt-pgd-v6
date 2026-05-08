cd $HOME
if [ -z $1 ];
then
  echo "Usage: $0 <token>"
  exit 1
fi
if grep -q "EDB_SUBSCRIPTION_TOKEN" .bashrc;
then
  echo "EDB_SUBSCRIPTION_TOKEN already set, skipping"
  exit 0
fi
echo "Setting EDB_SUBSCRIPION_TOKEN"
echo "export EDB_SUBSCRIPION_TOKEN=$1" >> .bashrc
echo "export EDB_SUBSCRIPTION_PLAN=enterprise" >> .bashrc
echo "export EDB_REPO_TYPE=deb" >> .bashrc