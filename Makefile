all: android ios

android: lib
	flutter build apk --no-tree-shake-icons

ios: lib
	flutter build ios --release --no-tree-shake-icons
	mkdir build/ios/iphoneos/Payload
	cp -r build/ios/iphoneos/Runner.app build/ios/iphoneos/Payload
	cd build/ios/iphoneos
	zip -r atlas.ipa Payload
	cd ../../..
