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
	cd migrationtest/yast-registration.git ; git log -1 | grep ff7950aa438fd588d56993d419a6fd84fbe29ec3
slptest:
	rm -rf migrationtest/yast-slp-server*
	make migrationtest/yast-slp-server.git
	cd migrationtest/yast-slp-server.git ; git log -1 | grep a8d76c7f9040aa3e7d8cac8d5c1e531b23ca655a

#%: migrationtest/yast-%.git
