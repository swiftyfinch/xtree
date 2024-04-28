.PHONY: lint
lint:
	@which swiftformat || \
	(printf '\e[31m⛔️ Could not find SwiftFormat.\e[m\n\e[33m🚑 Run: brew install swiftformat\e[m\n' && exit 1)
	@which swiftlint || \
	(printf '\e[31m⛔️ Could not find SwiftLint.\e[m\n\e[33m🚑 Run: brew install swiftlint\e[m\n' && exit 1)
	swiftformat --quiet .
	swiftlint --fix --quiet
	swiftlint --strict --quiet

.PHONY: install-cli
install:
	swift build --arch arm64 -c release
	cp -f `swift build --arch arm64 -c release --show-bin-path`/xtree ~/.local/bin/xtree

.PHONY: release-cli
release-cli:
	mkdir -p Release

	swift package clean
	swift build -c release --arch x86_64
	cp -f `swift build -c release --arch x86_64 --show-bin-path`/xtree Release/xtree
	strip -rSTx Release/xtree
	cd Release && zip -r x86_64.zip xtree
	cd Release && mv xtree xtree-x86_64
	@echo

	swift package clean
	swift build --arch arm64 -c release
	cp -f `swift build -c release --arch arm64 --show-bin-path`/xtree Release/xtree
	strip -rSTx Release/xtree
	cd Release && zip -r arm64.zip xtree
	cd Release && mv xtree xtree-arm64

.PHONY: release-app
release-app:
	rm -rf Release/build
	rm -rf Release/XTree.app
	rm -rf Release/XTree.zip
	mkdir -p Release

	xcodebuild \
	  -workspace XTree.xcworkspace \
	  -scheme XTree \
	  -configuration Release \
	  -sdk macosx \
	  -arch arm64 \
	  -derivedDataPath Release/build \
	  -clonedSourcePackagesDirPath "${HOME}/Library/Developer/Xcode/DerivedData/XTree" \
	  | xcbeautify
	mv Release/build/Build/Products/Release/XTree.app Release/XTree.app
	cd Release && zip -r XTree.zip XTree.app
