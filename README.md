# PGD demo v6

This demo uses Instruqt and Postgres Distributed (PGD) to demonstrate how to set up a distributed database cluster. PGD allows you to scale out your PostgreSQL database across multiple nodes, providing high availability and improved performance.

## Architecture

Four VMs are used in this demo:
- client - the client used to access the other servers
- db-1,-2 and -3 - the three nodes of the PGD Cluster.

db-1, 2 and 3 have EDB Advanced Server and PGD installed.

client has the PGD CLI installed and is configured to connect to all the db-servers.

