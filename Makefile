PREFIX?=/usr/local
TEMPORARY_FOLDER=/tmp/IBLinter.dst

build:
		swift build --disable-sandbox -c release -Xswiftc -static-stdlib
install: build
		mkdir -p "$(PREFIX)/bin"
		cp -f ".build/release/iblinter" "$(PREFIX)/bin/iblinter"
