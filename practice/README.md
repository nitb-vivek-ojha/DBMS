## SQL PRACTICE

### SET UP THE DATABASE
1. Make sure you have docker installed in your system.
2. Edit the .env file.
3. From the root of your project run
```
docker-compose up
```
4. At this point your database should be up and running. Verify it by running the following command
```
docker ps -a
```
[container-startup](/assets/container-startup.png)
5. Seed your database by running the command
```
# run from project root
chmod +x /practice/migrate.sh
./practice/migrate.sh
```
6. Open shell and connect to your database via psql
```
docker exec -it postgres psql -U <user> -d <database-name>
```
[connect-with-psql](/assets/psql.png)
7. Handy commands
```
\l (list all databases)
\c railway      connect to a different database
\dt             list tables in the current schema
\d <table>     describe a table (columns, indexes, constraints, FKs)
\dn             list schemas
\di             list indexes
\df             list functions
\x              toggle expanded output (essential for wide rows)
\e              open the last query in $EDITOR
\q              quit 
ctrl + L        clearing screen (for windows)
```