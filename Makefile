.PHONY: all build test clean

all: test

build:
	swift build -v

test:
	swift test -v

clean:
	rm -fr .build .DS_Store