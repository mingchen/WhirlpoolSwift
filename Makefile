.PHONY: all build test clean

all: test

build:
	swift build

test:
	swift test

clean:
	rm -fr .build .DS_Store