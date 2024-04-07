.PHONY: lint
lint:
	@which swiftformat || \
	(printf '\e[31m⛔️ Could not find SwiftFormat.\e[m\n\e[33m🚑 Run: brew install swiftformat\e[m\n' && exit 1)
	@which swiftlint || \
	(printf '\e[31m⛔️ Could not find SwiftLint.\e[m\n\e[33m🚑 Run: brew install swiftlint\e[m\n' && exit 1)
	swiftformat --quiet .
	swiftlint --fix --quiet
	swiftlint --strict --quiet

.PHONY: install
install:
	swift build --arch arm64 -c release
	cp -f `swift build --arch arm64 -c release --show-bin-path`/xtree ~/.local/bin/xtree

.PHONY: release
release:
	rm -rf Release
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
