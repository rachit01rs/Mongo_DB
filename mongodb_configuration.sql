
--Step 1 : Import the public key used by the package management system
mongo@mongodbserver:/home/mongo$ sudo apt-get install gnupg curl
/*
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
curl is already the newest version (7.81.0-1ubuntu1.13).
curl set to manually installed.
gnupg is already the newest version (2.2.27-3ubuntu2.1).
gnupg set to manually installed.
0 upgraded, 0 newly installed, 0 to remove and 0 not upgraded.
*/


--Issue the following command to import the MongoDB public GPG Key from  https://pgp.mongodb.com/server-6.0.asc

mongo@mongodbserver:/home/mongo$ curl -fsSL https://pgp.mongodb.com/server-6.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg \
   --dearmor
   
   
--Step 2 : Create a list file for MongoDB.

mongo@mongodbserver:/home/mongo$ echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
/*
deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse

*/

mongo@mongodbserver:$ sudo apt-get update
/*
Ign:1 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 InRelease
Hit:2 http://np.archive.ubuntu.com/ubuntu jammy InRelease
Hit:3 http://np.archive.ubuntu.com/ubuntu jammy-updates InRelease
Hit:4 http://np.archive.ubuntu.com/ubuntu jammy-backports InRelease
Get:5 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 Release [3,094 B]
Hit:6 http://np.archive.ubuntu.com/ubuntu jammy-security InRelease
Get:7 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 Release.gpg [866 B]
Get:8 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse arm64 Packages [25.8 kB]
Get:9 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 Packages [28.8 kB]
Fetched 58.5 kB in 2s (25.2 kB/s)
Reading package lists... Done
*/

Step 3: Install the MongoDB packages

mongo@mongodbserver:~$  sudo apt-get install -y mongodb-org
/*
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  mongodb-database-tools mongodb-mongosh mongodb-org-database mongodb-org-database-tools-extra mongodb-org-mongos mongodb-org-server mongodb-org-shell
  mongodb-org-tools
The following NEW packages will be installed:
  mongodb-database-tools mongodb-mongosh mongodb-org mongodb-org-database mongodb-org-database-tools-extra mongodb-org-mongos mongodb-org-server
  mongodb-org-shell mongodb-org-tools
0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
Need to get 147 MB of archives.
After this operation, 429 MB of additional disk space will be used.
Get:1 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-database-tools amd64 100.7.5 [50.7 MB]
Get:2 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-mongosh amd64 1.10.3 [42.0 MB]
Get:3 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-org-shell amd64 6.0.8 [2,990 B]
Get:4 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-org-server amd64 6.0.8 [31.4 MB]
Get:5 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-org-mongos amd64 6.0.8 [22.4 MB]
Get:6 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-org-database-tools-extra amd64 6.0.8 [7,790 B]
Get:7 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-org-database amd64 6.0.8 [3,424 B]
Get:8 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-org-tools amd64 6.0.8 [2,772 B]
Get:9 https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0/multiverse amd64 mongodb-org amd64 6.0.8 [2,806 B]
Fetched 147 MB in 33s (4,427 kB/s)
Selecting previously unselected package mongodb-database-tools.
(Reading database ... 95607 files and directories currently installed.)
Preparing to unpack .../0-mongodb-database-tools_100.7.5_amd64.deb ...
Unpacking mongodb-database-tools (100.7.5) ...
Selecting previously unselected package mongodb-mongosh.
Preparing to unpack .../1-mongodb-mongosh_1.10.3_amd64.deb ...
Unpacking mongodb-mongosh (1.10.3) ...
Selecting previously unselected package mongodb-org-shell.
Preparing to unpack .../2-mongodb-org-shell_6.0.8_amd64.deb ...
Unpacking mongodb-org-shell (6.0.8) ...
Selecting previously unselected package mongodb-org-server.
Preparing to unpack .../3-mongodb-org-server_6.0.8_amd64.deb ...
Unpacking mongodb-org-server (6.0.8) ...
Selecting previously unselected package mongodb-org-mongos.
Preparing to unpack .../4-mongodb-org-mongos_6.0.8_amd64.deb ...
Unpacking mongodb-org-mongos (6.0.8) ...
Selecting previously unselected package mongodb-org-database-tools-extra.
Preparing to unpack .../5-mongodb-org-database-tools-extra_6.0.8_amd64.deb ...
Unpacking mongodb-org-database-tools-extra (6.0.8) ...
Selecting previously unselected package mongodb-org-database.
Preparing to unpack .../6-mongodb-org-database_6.0.8_amd64.deb ...
Unpacking mongodb-org-database (6.0.8) ...
Selecting previously unselected package mongodb-org-tools.
Preparing to unpack .../7-mongodb-org-tools_6.0.8_amd64.deb ...
Unpacking mongodb-org-tools (6.0.8) ...
Selecting previously unselected package mongodb-org.
Preparing to unpack .../8-mongodb-org_6.0.8_amd64.deb ...
Unpacking mongodb-org (6.0.8) ...
Setting up mongodb-mongosh (1.10.3) ...
Setting up mongodb-org-server (6.0.8) ...
Adding system user `mongodb' (UID 115) ...
Adding new user `mongodb' (UID 115) with group `nogroup' ...
Not creating home directory `/home/mongodb'.
Adding group `mongodb' (GID 120) ...
Done.
Adding user `mongodb' to group `mongodb' ...
Adding user mongodb to group mongodb
Done.
Setting up mongodb-org-shell (6.0.8) ...
Setting up mongodb-database-tools (100.7.5) ...
Setting up mongodb-org-mongos (6.0.8) ...
Setting up mongodb-org-database-tools-extra (6.0.8) ...
Setting up mongodb-org-database (6.0.8) ...
Setting up mongodb-org-tools (6.0.8) ...
Setting up mongodb-org (6.0.8) ...
Processing triggers for man-db (2.10.2-1) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.
*/
--Step 4: Start MongoDB


mongo@mongodbserver:~$  sudo systemctl status mongod

username: mongo
password:mongo123
/*
○ mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; disabled; vendor preset: enabled)
     Active: inactive (dead)
       Docs: https://docs.mongodb.org/manual
*/
mongo@mongodbserver:~$ $ sudo systemctl start mongod
mongo@mongodbserver:~$  sudo systemctl status mongod
/*
● mongod.service - MongoDB Database Server
     Loaded: loaded (/lib/systemd/system/mongod.service; disabled; vendor preset: enabled)
     Active: active (running) since Fri 2023-08-11 04:38:59 UTC; 10s ago
       Docs: https://docs.mongodb.org/manual
   Main PID: 4530 (mongod)
     Memory: 66.2M
        CPU: 208ms
     CGroup: /system.slice/mongod.service
             └─4530 /usr/bin/mongod --config /etc/mongod.conf

Aug 11 04:38:59 mongodbserver systemd[1]: Started MongoDB Database Server.
Aug 11 04:38:59 mongodbserver mongod[4530]: {"t":{"$date":"2023-08-11T04:38:59.982Z"},"s":"I",  "c":"CONTROL",  "id":7484500, "ctx":"-","msg":"Environment variabl>

*/
--Enabled MongoDB
mongo@mongodbserver:~$ sudo systemctl enable mongod
/*
Created symlink /etc/systemd/system/multi-user.target.wants/mongod.service → /lib/systemd/system/mongod.service.
*/

--Restart MongoDB.
mongo@mongodbserver:~$ sudo systemctl restart mongod


--Step 5 : Begin using MongoDB 
mongo@mongodbserver:~$ mongosh
/*
Current Mongosh Log ID: 64d5bc2f13d2458fec260436
Connecting to:          mongodb://127.0.0.1:27017/?directConnection=true&serverSelectionTimeoutMS=2000&appName=mongosh+1.10.4
Using MongoDB:          6.0.8
Using Mongosh:          1.10.4

For mongosh info see: https://docs.mongodb.com/mongodb-shell/


To help improve our products, anonymous usage data is collected and sent to MongoDB periodically (https://www.mongodb.com/legal/privacy-policy).
You can opt-out by running the disableTelemetry() command.

------
   The server generated these startup warnings when booting
   2023-08-11T04:39:00.189+00:00: Using the XFS filesystem is strongly recommended with the WiredTiger storage engine. See http://dochub.mongodb.org/core/prodnotes-filesystem
   2023-08-11T04:39:00.310+00:00: Access control is not enabled for the database. Read and write access to data and configuration is unrestricted
   2023-08-11T04:39:00.310+00:00: vm.max_map_count is too low
------

test>show databases;
admin   40.00 KiB
config  12.00 KiB
local   72.00 KiB

switched to db mydb
mydb> show dbs;
admin   40.00 KiB
config  60.00 KiB
local   40.00 KiB
mydb> db.createCollection("students")
{ ok: 1 }
mydb> show collections
students
mydb> db.students.insert({"name":"Rabin"})
DeprecationWarning: Collection.insert() is deprecated. Use insertOne, insertMany, or bulkWrite.
{
  acknowledged: true,
  insertedIds: { '0': ObjectId("64d5c4fdbd6331f38e992611") }
}
mydb> db.students.insert({"name":"Manish"})
{
  acknowledged: true,
  insertedIds: { '0': ObjectId("64d5c512bd6331f38e992612") }
}
mydb> show dbs;
admin   40.00 KiB
config  72.00 KiB
local   40.00 KiB
mydb    40.00 KiB
mydb> db.students.insert({"name":"Ukesh"})
{
  acknowledged: true,
  insertedIds: { '0': ObjectId("64d5c525bd6331f38e992613") }
}


db.movies.insertOne(
  {
    title: "The Favourite",
    genres: [ "Drama", "History" ],
    runtime: 121,
    rated: "R",
    year: 2018,
    directors: [ "Yorgos Lanthimos" ],
    cast: [ "Olivia Colman", "Emma Stone", "Rachel Weisz" ],
    type: "movie"
  }
)
*/
To insert a new document into the sample_mflix.movies collection:

db.movies.insertOne(
  {
    title: "The Favourite",
    genres: [ "Drama", "History" ],
    runtime: 121,
    rated: "R",
    year: 2018,
    directors: [ "Yorgos Lanthimos" ],
    cast: [ "Olivia Colman", "Emma Stone", "Rachel Weisz" ],
    type: "movie"
  }
)

To retrieve the inserted document, read the collection:
db.movies.find( { title: "The Favourite" } )

Insert Multiple Documents
/*
sample_mflix> db.movies.insertMany([
...    {
...       title: "Jurassic World: Fallen Kingdom",
...       genres: [ "Action", "Sci-Fi" ],
...       runtime: 130,
...       rated: "PG-13",
...       year: 2018,
...       directors: [ "J. A. Bayona" ],
...       cast: [ "Chris Pratt", "Bryce Dallas Howard", "Rafe Spall" ],
...       type: "movie"
...     },
...     {
...       title: "Tag",
...       genres: [ "Comedy", "Action" ],
...       runtime: 105,
...       rated: "R",
...       year: 2018,
...       directors: [ "Jeff Tomsic" ],
...       cast: [ "Annabelle Wallis", "Jeremy Renner", "Jon Hamm" ],
...       type: "movie"
...     }
... ])
{
  acknowledged: true,
  insertedIds: {
    '0': ObjectId("64d5c630bd6331f38e992615"),
    '1': ObjectId("64d5c630bd6331f38e992616")
  }
}
*/

sample_mflix> db.movies.find( {} )
[
  {
    _id: ObjectId("64d5c5aabd6331f38e992614"),
    title: 'The Favourite',
    genres: [ 'Drama', 'History' ],
    runtime: 121,
    rated: 'R',
    year: 2018,
    directors: [ 'Yorgos Lanthimos' ],
    cast: [ 'Olivia Colman', 'Emma Stone', 'Rachel Weisz' ],
    type: 'movie'
  },
  {
    _id: ObjectId("64d5c630bd6331f38e992615"),
    title: 'Jurassic World: Fallen Kingdom',
    genres: [ 'Action', 'Sci-Fi' ],
    runtime: 130,
    rated: 'PG-13',
    year: 2018,
    directors: [ 'J. A. Bayona' ],
    cast: [ 'Chris Pratt', 'Bryce Dallas Howard', 'Rafe Spall' ],
    type: 'movie'
  },
  {
    _id: ObjectId("64d5c630bd6331f38e992616"),
    title: 'Tag',
    genres: [ 'Comedy', 'Action' ],
    runtime: 105,
    rated: 'R',
    year: 2018,
    directors: [ 'Jeff Tomsic' ],
    cast: [ 'Annabelle Wallis', 'Jeremy Renner', 'Jon Hamm' ],
    type: 'movie'
  }
]
sample_mflix>

