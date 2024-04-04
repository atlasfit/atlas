all: android ios

android: lib
	flutter build apk --no-tree-shake-icons

ios: lib
	flutter build ipa --no-tree-shake-icons
