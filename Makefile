CARTHAGE=carthage
BREW=brew
SWIFTGEN=swiftgen
ROME=rome

update:
	$(CARTHAGE) update --no-use-binaries --platform ios
	$(ROME) upload --platform ios

bootstrap: rebuild-assets
	$(CARTHAGE) update --no-build --no-use-binaries --platform ios
	$(ROME) download --platform ios

dependencies:
	$(BREW) update
	$(BREW) install swiftgen 
	$(BREW) install blender/homebrew-tap/rome

rebuild-assets: dependencies
	$(SWIFTGEN) images -t dot-syntax-swift3 -o Memoires/Assets.swift Memoires/Assets.xcassets
	$(SWIFTGEN) storyboards -t swift3 -o Memoires/Storyboards.swift Memoires/Base.lproj/Main.storyboard

