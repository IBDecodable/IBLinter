PREFIX?=/usr/local
TEMPORARY_FOLDER=/tmp/IBLinter.dst

build:
		swift build --disable-sandbox -c release -Xswiftc -static-stdlib

clean_build:
		rm -rf bin
		make build
		mkdir bin
		cp -f .build/release/iblinter bin/
		rm -rf .build

install: build
		mkdir -p "$(PREFIX)/bin"
		cp -f ".build/release/iblinter" "$(PREFIX)/bin/iblinter"

publish: clean_build
		brew update && brew bump-formula-pr --tag=$(shell git describe --tags) --revision=$(shell git rev-parse HEAD) iblinter
		pod trunk push IBLinter.podspec
