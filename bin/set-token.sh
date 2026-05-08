cd $HOME
if [ -z $1 ];
then
  echo "Usage: $0 <token>"
  exit 1
fi
if grep -q "EDB_SUBSCRIPTION_TOKEN" .bash_profile;
then
  echo "EDB_SUBSCRIPTION_TOKEN already set, skipping"
  exit 0
fi
echo "Setting EDB_SUBSCRIPION_TOKEN"
echo "export EDB_SUBSCRIPION_TOKEN=$1" >> .bash_profile
echo "export EDB_SUBSCRIPTION_PLAN=enterprise" >> .bash_profile
echo "export EDB_REPO_TYPE=deb" >> .bash_profile