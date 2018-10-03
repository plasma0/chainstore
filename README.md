# chainstore
General purpose blockchain database.

### Requirements
To use this software you need:
1. Haskell Platform: version 7.10.3 or newer. You can get it here:
https://www.haskell.org/platform/
2. SQLite3 binary. You can get it here:
https://www.sqlite.org/download.html

### Installation
1. Enter into directory in which you fetched (& unpacked) files.
2. Execute following commands:

  a. cabal configure

  b. cabal build

  c. cabal install

### Useage
Execute:
chainstore FILE --OPTION
FILE - the name of file containing database in which you want to operate
OPTION - operation you want to be done. Possible values:

"--create" - create blockchain database

"--show" - print all records of database

"--latest" - print newest added record

"--verify" - check if no record has been modified

"--add CONTENT" - add record with given content
