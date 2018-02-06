PREFIX?=/usr/local
TEMPORARY_FOLDER=/tmp/IBLinter.dst

build:
		swift build --disable-sandbox -c release -Xswiftc -static-stdlib

cocoapods:
		rm -rf bin
		make build
		mkdir bin
		cp -f .build/release/iblinter bin/
		rm -rf .build

install: build
		mkdir -p "$(PREFIX)/bin"
		cp -f ".build/release/iblinter" "$(PREFIX)/bin/iblinter"
