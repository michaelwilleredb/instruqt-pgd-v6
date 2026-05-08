
At this point we have the three servers db-1, db-2 and db-3 provisioned and running. 

Next step is to install EDB Advanced Server and PGD on all three servers.

## Fetch the git repository

Run the following command on all three servers to fetch the git repository containing the installation scripts:

```bash
git clone https://github.com/michaelwilleredb/instruqt-pgd-v6.git
for vm in db-1 db-2 db-3; do
  ssh $vm "git clone https://github.com/michaelwilleredb/instruqt-pgd-v6.git"
done
```