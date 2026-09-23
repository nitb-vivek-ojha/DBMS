## SQL PRACTICE

### SET UP THE DATABASE
1. Make sure you have docker installed in your system.
2. Edit the .env file.
3. Run the following command
```
cd practice/
docker-compose up
```
4. At this point your database should be up and running. Verify it by running the following command
```
# open another shell and run
docker ps -a
```
![container-startup](/assets/container-startup.png)

5. Migrate.sh will create tables and seed your database.
```
cd /practice
chmod +x migrate.sh
./migrate.sh
```
6. Open shell and connect to your database via psql
```
docker exec -it postgres psql -U <user> -d <database-name>
```
![connect-with-psql](/assets/psql.png)

7. Run the follwoing commands
![schema-description](/assets/schema.png)

8. Handy commands
```
\l              list all databases
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