CARTHAGE=carthage
BREW=brew
SWIFTGEN=swiftgen
ROME=rome

update:
	$(CARTHAGE) update --no-use-binaries --platform ios
	$(ROME) upload --platform ios

bootstrap:
	$(CARTHAGE) update --no-build --no-use-binaries --platform ios
	$(ROME) download --platform ios

dependencies:
	$(BREW) update
	$(BREW) install swiftgen rome

rebuild-assets:
	$(SWIFTGEN) images -o Memoires/Assets.swift Memoires
	$(SWIFTGEN) storyboard -o Memoires/Storyboards.swift Memoires

