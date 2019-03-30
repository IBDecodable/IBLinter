PREFIX?=/usr/local
SWIFT_LIB_FILES = .build/release/libIBLinter.dylib .build/release/*.swiftmodule
C_LIB_DIRS = .build/release/CYaml.build .build/release/Clang_C.build .build/release/SourceKit.build

build:
		swift build --disable-sandbox -c release --static-swift-stdlib

clean_build:
		rm -rf .build
		make build

portable_zip: build
		rm -rf portable_iblinter
		mkdir portable_iblinter
		mkdir portable_iblinter/lib
		mkdir portable_iblinter/bin
		cp -f .build/release/iblinter portable_iblinter/bin/iblinter
		cp -rf $(C_LIB_DIRS) $(SWIFT_LIB_FILES) "portable_iblinter/lib"
		cp -f LICENSE portable_iblinter
		cd portable_iblinter
		(cd portable_iblinter; zip -yr - "lib" "bin" "LICENSE") > "./portable_iblinter.zip"
		rm -rf portable_iblinter

install: build
		mkdir -p "$(PREFIX)/bin"
		mkdir -p "$(PREFIX)/lib/iblinter"
		cp -f ".build/release/iblinter" "$(PREFIX)/bin/iblinter"
		cp -rf $(C_LIB_DIRS) $(SWIFT_LIB_FILES) "$(PREFIX)/lib/iblinter"

current_version:
		@cat .version

bump_version:
		$(eval NEW_VERSION := $(filter-out $@,$(MAKECMDGOALS)))
		@echo $(NEW_VERSION) > .version
		@sed 's/__VERSION__/$(NEW_VERSION)/g' script/Version.swift.template > Sources/IBLinter/Version.swift
		git commit -am"Bump version to $(NEW_VERSION)"

publish:
		brew update && brew bump-formula-pr --tag=$(shell git describe --tags) --revision=$(shell git rev-parse HEAD) iblinter
		COCOAPODS_VALIDATOR_SKIP_XCODEBUILD=1 pod trunk push IBLinter.podspec

%:
	@:
