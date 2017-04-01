CARTHAGE=carthage
SWIFT_GEN=swiftgen
ROME=rome

update:
	$(CARTHAGE) update --no-use-binaries --platform ios
	$(ROME) upload --platform ios

deps:
	$(CARTHAGE) update --no-build --no-use-binaries --platform ios
	$(ROME) download --platform ios

rebuild-assets:
	swiftgen images -o Memoires/Assets.swift Memoires
