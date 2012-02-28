t=migrationtest
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

all: $(gitdirs)
migrationtest/yast-%.git:
	cd $t ; export MODULES=`perl -e '$$_="$@";s{migrationtest/yast-(.*)\.git}{$$1};print'` ; echo "making $$MODULES" ; time sh -x ${PWD}/notes

regtest:
	rm -rf migrationtest/yast-registration*
	make migrationtest/yast-registration.git
	p=`pwd` ; cd migrationtest/yast-registration.git ; git log -1 | grep ff7950aa438fd588d56993d419a6fd84fbe29ec3 && git branch -a | diff - $$p/ref/registration.branches
slptest:
	rm -rf migrationtest/yast-slp{,.git}
	make migrationtest/yast-slp.git
	p=`pwd` ; cd migrationtest/yast-slp.git ; git log -1 | grep bc8339f3d7444ac41d5a6ccc2c425697ac9ebb0d && git branch -a | diff - $$p/ref/slp.branches
slpservertest:
	rm -rf migrationtest/yast-slp-server*
	make migrationtest/yast-slp-server.git
	p=`pwd` ; cd migrationtest/yast-slp-server.git ; git log -1 | grep a8d76c7f9040aa3e7d8cac8d5c1e531b23ca655a && git branch -a | diff - $$p/ref/slp-server.branches


checkresults:
#	tail -n 2 migrationtest/*.dumpfilter.out |grep -v "0 nodes converted"
	tail -n 2 migrationtest/*.load|grep -v -e "Committed revision 67506" -e "^$$"
	tail -n 2 migrationtest/*.dumpfilter.out |grep -1 SystemExit
#%: migrationtest/yast-%.git
