R=file:///dev/shm/yast/REPO
all: modules
branches: Makefile
	svn ls $R/branches/|grep SuSE|sed 's/^/branches\//' > branches
	echo trunk/ >>branches

modules: branches
	(for b in `cat branches` ; do svn ls $R/$$b ; done) | sort | uniq | sed 's/\/$$//' > modules
