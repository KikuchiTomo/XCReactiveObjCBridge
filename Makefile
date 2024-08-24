PODS_ROOT="./Pods"
PODS_PROJECT="$(PODS_ROOT)/Pods.xcodeproj"
SYMROOT="$(PODS_ROOT)/Build"
IPHONEOS_DEPLOYMENT_TARGET = 15.0

clean:
	-rm -rf Pods ReactiveObjC
# cocoa pods からソースコードをとってくる
install-cocoapods:
	pod install

# 一旦手元でarm64向けにビルドする
build-cocoapods: install-cocoapods
	xcodebuild -project "$(PODS_PROJECT)" \
		-sdk iphoneos \
		-configuration Release -alltargets \
		ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=NO SYMROOT="$(SYMROOT)" \
		CLANG_ENABLE_MODULE_DEBUGGING=NO \
		BITCODE_GENERATION_MODE=bitcode \
		IPHONEOS_DEPLOYMENT_TARGET="$(IPHONEOS_DEPLOYMENT_TARGET)" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES 
	xcodebuild -project "$(PODS_PROJECT)" \
		-sdk iphonesimulator \
		-configuration Release -alltargets \
		ONLY_ACTIVE_ARCH=NO ENABLE_TESTABILITY=NO SYMROOT="$(SYMROOT)" \
		CLANG_ENABLE_MODULE_DEBUGGING=NO \
		BITCODE_GENERATION_MODE=bitcode \
		IPHONEOS_DEPLOYMENT_TARGET="$(IPHONEOS_DEPLOYMENT_TARGET)" \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES 

# umbrella frameworkをxcframeworkにしてswiftpmで使えるようにする
create-xcframework: build-cocoapods
	-rm -rf ReactiveObjC	
	xcodebuild -create-xcframework \
		-framework Pods/Pods/Build/Release-iphonesimulator/ReactiveObjC/ReactiveObjC.framework  \
		-framework Pods/Pods/Build/Release-iphoneos/ReactiveObjC/ReactiveObjC.framework \
		-output ReactiveObjC/ReactiveObjC.xcframework
	xcodebuild -create-xcframework \
		-framework Pods/Pods/Build/Release-iphonesimulator/ReactiveObjCBridge/ReactiveObjCBridge.framework  \
		-framework Pods/Pods/Build/Release-iphoneos/ReactiveObjCBridge/ReactiveObjCBridge.framework \
		-output ReactiveObjC/ReactiveObjCBridge.xcframework \

# バイナリの一部はすでに FAT オブジェクト(.o)になっていて，static archive でない場合は．
# XCFramework を生成したあと，オブジェクトをアーカイブし直す必要あり．
# 例)
# cd ReactiveObjC/ReactiveObjC.xcframework/ios-arm64/ReactiveObjC.xcframework
# # ----- ここで xxxx.oのようなファイルがある場合はアーカイブのし直しが必要
# mv ReactiveObjC{,.o}
# ar r ReactiveObjC ReactiveObjC.o
# ranlib ReactiveObjC
# rm  ReactiveObjC.o
