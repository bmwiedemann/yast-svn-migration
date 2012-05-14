t=migrationtest
R=/dev/shm/yast/REPO
D=~/yast-svn-2012-05-11.dump
#modules=$(shell cat yast.modules.2bexported)
PWD=$(shell pwd)
modules=$(shell cat modulelist/modules)
gitdirs=$(patsubst %,migrationtest/yast-%.git,$(modules))
help:
	@echo "usage: make regtest migrationtest/yast-xxx.git"

test:
	#rm -rf $t
	mkdir -p $t
	cd $t && BATCH=1 time sh -x ${PWD}/notes

all: modulelist/modules $(gitdirs)
$R: $D
	rm -rf $R
	mkdir -p $R
	svnadmin create $R
	svnadmin load $R < $D
migrationtest/yast-%.git: $R
	cd $t ; export MODULES=`perl -e '$$_="$@";s{migrationtest/yast-(.*)\.git}{$$1};print'` ; rm -rf yast-$$MODULES.git yast-$$MODULES ; echo "making $$MODULES" ; DUMPFILE=$D REPO=$R time sh -x ${PWD}/notes

regtest: $R
	rm -rf migrationtest/yast-registration*
	make migrationtest/yast-registration.git
	p=`pwd` ; cd migrationtest/yast-registration.git ; git log -1 | grep a15595e5053a98f9d0f100d72957f368ce1d72d9 && git branch -a | diff - $$p/ref/registration.branches
slptest: $R
	rm -rf migrationtest/yast-slp{,.git}
	make migrationtest/yast-slp.git
	p=`pwd` ; cd migrationtest/yast-slp.git ; git log -1 | grep 8bb51287a4614bd959cb48bbd96b843b2fec73c3 && git branch -a | diff - $$p/ref/slp.branches
slpservertest: $R
	rm -rf migrationtest/yast-slp-server*
	make migrationtest/yast-slp-server.git
	p=`pwd` ; cd migrationtest/yast-slp-server.git ; git log -1 | grep a8d76c7f9040aa3e7d8cac8d5c1e531b23ca655a && git branch -a | diff - $$p/ref/slp-server.branches


checkresults:
#	tail -n 2 migrationtest/*.dumpfilter.out |grep -v "0 nodes converted"
	tail -n 2 migrationtest/*.load|grep -v -e "Committed revision 68152" -e "^$$"
	tail -n 2 migrationtest/*.dumpfilter.out |grep -1 SystemExit
#%: migrationtest/yast-%.git

upload:
	rsync -aPSHvz -e "ssh -p 23" migrationtest/yast-*.git bernhard@ssh.zq1.de:~/public_html/linux/yast/

cleanup:
	rm -rf migrationtest/* $R
	cd modulelist; make clean

prepare: $R modulelist/modules

modulelist/modules:
	cd modulelist; make
