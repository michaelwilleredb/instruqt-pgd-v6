# Configure PGD

At this point we have the three servers db-1, db-2 and db-3 provisioned and running. 

---

NOTE: This demo is NOT a workshop. It is not supposed 
to be shared with participants - unless a temporary EDB Subscription Token is used

---

### Set EDB Suscription token on all servers

The following command will export your download token to all the database servers.

```bash
set-token.sh "---YOUR TOKEN---"
```

### Install EPAS and PGD

Next step is to install EDB Advanced Server and PGD on all three servers.

```bash
run-on-all-dbs.sh "$HOME/instruqt-pgd-v6/bin/pgd-install.sh"
```

Note that the install of EPAS and PGD libraries runs in parallel on all servers.

### Configure the PGD databases

Once the above install has completed, we can use the ```pgd``` command line interface to create the PGD databases.

This is done by running the following command:

```bash
run-on-all-dbs.sh -s "$HOME/instruqt-pgd-v6/bin/pgd-config.sh"
```

Note that this command uses ``-s`` which will run the ``pgd-config.sh`` serially instead of in parallel

This run the command below on the individual servers. 

```
pgd node node-3 setup --dsn "$db3_dsn"  --group-name group-1 --cluster-dsn "$db1_dsn"
```

This command will create a database on the cluster, install PGD as an extension, and connect the database to the PGD cluster. The first database to be created, is created without specifying the ``--cluster-dsn`` since it's the first database to join.


### Next steps

Once this has completed, you can move on to the next challenge.
