platform :ios, '15.0'

install! 'cocoapods', integrate_targets: false

target 'ReactiveObjCBridgeSwiftPM' do
  use_frameworks!
  pod 'ReactiveObjCBridge'
  # pod 'ReactiveObjC', '~> 3.1'
end

# Workaround for code signing in Xcode 14 beta
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
          config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
end
