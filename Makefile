
.PHONY: all clean

all: test test.so

clean:
	rm -f test *.o test.so meta.txt

ifndef REPO_URL
REPO_URL := $(shell git remote get-url origin)
ifeq ($(REPO_URL),)
REPO_URL := $(shell svn info --show-item url)
endif
endif

ifndef REVISION
REVISION := $(shell git rev-parse HEAD)
ifeq ($(REVISION),)
REVISION := $(shell svn info --show-item revision)
endif
endif


%.o: %.c
	gcc -c $< -o $@

test: test.o test2.o
	gcc test.o test2.o -o test
	echo "$(REPO_URL)/$(REVISION) $^" > meta.txt
	objcopy --add-section .meta=meta.txt $@ $@

test.so: test2.o
	gcc -shared -fPIC -o test.so test2.o
	echo "$(REPO_URL)/$(REVISION) $^" > meta.txt
	objcopy --add-section .meta=meta.txt $@ $@

