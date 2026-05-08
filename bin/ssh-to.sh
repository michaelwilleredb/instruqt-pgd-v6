if [ -z $1 ]; 
then
  echo "Usage $0 HOSTNAME"
  exit 0
fi
ssh root@$1
