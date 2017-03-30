CARTHAGE=carthage
SWIFT_GEN=swiftgen
ROME=rome

update:
	$(CARTHAGE) update --no-use-binaries
	$(ROME) upload

deps:
	$(CARTHAGE) update --no-build --no-use-binaries
	$(ROME) download

rebuild-assets:
	swiftgen images -o Memoires/Assets.swift Memoires
