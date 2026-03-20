.PHONY: generate build run clean

# Generate Xcode project using XcodeGen
generate:
	cd "$(CURDIR)" && xcodegen generate

# Build the app
build: generate
	xcodebuild -project "$(CURDIR)/CorgiBreak.xcodeproj" \
		-scheme CorgiBreak \
		-configuration Release \
		-derivedDataPath "$(CURDIR)/build" \
		build

# Run the app
run: build
	open "$(CURDIR)/build/Build/Products/Release/CorgiBreak.app"

# Clean build artifacts
clean:
	rm -rf "$(CURDIR)/build" "$(CURDIR)/CorgiBreak.xcodeproj"
