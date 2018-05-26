PREFIX?=/usr/local
SWIFT_LIB_FILES = .build/release/libIBLinterKit.dylib .build/release/*.swiftmodule
C_LIB_DIRS = .build/release/CYaml.build

build:
		swift build --disable-sandbox -c release --static-swift-stdlib

clean_build:
		rm -rf bin
		make build
		mkdir bin
		cp -f .build/release/iblinter bin/
		rm -rf .build

install: build
		mkdir -p "$(PREFIX)/bin"
		mkdir -p "$(PREFIX)/lib/iblinter"
		cp -f ".build/release/iblinter" "$(PREFIX)/bin/iblinter"
		cp -f $(SWIFT_LIB_FILES) "$(PREFIX)/lib/iblinter"
		cp -rf $(C_LIB_DIRS) "$(PREFIX)/lib/iblinter"

publish: clean_build
		brew update && brew bump-formula-pr --tag=$(shell git describe --tags) --revision=$(shell git rev-parse HEAD) iblinter
		pod trunk push IBLinter.podspec
