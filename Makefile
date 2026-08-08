.PHONY: bootstrap build test validate privacy-check clean-check device-list device-build device-install device-launch project clean

PROJECT := SupernovaEmoji.xcodeproj
SCHEME := SupernovaEmoji
CONFIG := Debug

bootstrap:
	@mkdir -p Config
	@if [ ! -f Config/Local.xcconfig ]; then \
		cp Config/Local.example.xcconfig Config/Local.xcconfig; \
		echo "Created Config/Local.xcconfig — set DEVELOPMENT_TEAM for device builds"; \
	fi
	@command -v xcodegen >/dev/null || (echo "Install xcodegen: brew install xcodegen" >&2; exit 1)
	xcodegen generate
	@chmod +x scripts/*.sh

project: bootstrap

build: project
	@DEST=$$(./scripts/simulator-destination.sh); \
	xcodebuild \
	  -project $(PROJECT) \
	  -scheme $(SCHEME) \
	  -configuration $(CONFIG) \
	  -sdk iphonesimulator \
	  -destination "$$DEST" \
	  CODE_SIGNING_ALLOWED=NO \
	  build

test: project
	@DEST=$$(./scripts/simulator-destination.sh); \
	xcodebuild \
	  -project $(PROJECT) \
	  -scheme $(SCHEME) \
	  -configuration $(CONFIG) \
	  -sdk iphonesimulator \
	  -destination "$$DEST" \
	  CODE_SIGNING_ALLOWED=NO \
	  test

validate: privacy-check build test
	@echo "validate: all safe automated checks passed (clean-check is post-commit)"

privacy-check:
	@./scripts/privacy-check.sh

clean-check:
	@./scripts/clean-tree-check.sh

device-list:
	@xcrun devicectl list devices
	@echo "---"
	@xcrun xctrace list devices 2>/dev/null | head -40

device-build: project
	@if [ ! -f Config/Local.xcconfig ]; then echo "Missing Config/Local.xcconfig" >&2; exit 1; fi
	@DEST=$$(./scripts/device-destination.sh); \
	echo "Building for $$DEST"; \
	xcodebuild \
	  -project $(PROJECT) \
	  -scheme $(SCHEME) \
	  -configuration $(CONFIG) \
	  -destination "$$DEST" \
	  -allowProvisioningUpdates \
	  build

device-install: device-build
	@APP=$$(find ~/Library/Developer/Xcode/DerivedData -path '*SupernovaEmoji*/Build/Products/Debug-iphoneos/SupernovaEmoji.app' 2>/dev/null | head -1); \
	if [ -z "$$APP" ]; then echo "App product not found" >&2; exit 1; fi; \
	DEST=$$(./scripts/device-destination.sh); \
	ID=$${DEST#platform=iOS,id=}; \
	xcrun devicectl device install app --device "$$ID" "$$APP"

device-launch:
	@DEST=$$(./scripts/device-destination.sh); \
	ID=$${DEST#platform=iOS,id=}; \
	xcrun devicectl device process launch --device "$$ID" com.supernovahorizon.emoji

clean:
	rm -rf DerivedData build
	xcodegen generate >/dev/null 2>&1 || true
