CARTHAGE=carthage
SWIFT_GEN=swiftgen
ROME=rome

update:
	$(CARTHAGE) update --platform ios --no-use-binaries
	$(ROME) upload

deps:
	$(ROME) download

rebuild-assets:
	swiftgen images -o Memoires/Assets.swift Memoires
