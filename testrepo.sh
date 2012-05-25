#!/bin/sh
R=/tmp/REPO
svnadmin create $R
svn co file://$R
cd REPO
echo test > testfile
svn add testfile 
svn commit -m "add"
echo -n > testfile
svn commit -m "empty"
echo -e '#!/bin/sh\necho OK' > script.sh
chmod a+x script.sh
svn add script.sh
svn commit -m "add script"
svnadmin dump $R > ~/test.dump
MODULE=x svndumpfilter3 ".*" < ~/test.dump > /dev/shm/test2.dump
diff -u ~/test.dump /dev/shm/test2.dump
