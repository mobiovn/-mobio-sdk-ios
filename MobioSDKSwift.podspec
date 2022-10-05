
Pod::Spec.new do |spec|


  spec.name         = "MobioSDK"
  spec.version      = "0.0.1"
  spec.summary      = "This is my CocoaPod of MobioSDK."

  spec.description  = <<-DESC
                        This Cocoa pod help you tracking your app
                   DESC

  spec.homepage     = "https://gitbucket.mobio.vn/git/SDK_APP/ios_swift_lib"


  spec.license      = "MIT"

  spec.author             = { "mobio" => "linhtn@mobio.io" }

  spec.ios.deployment_target = "14.0"

  spec.swift_version = "5.0"


  spec.source       = { :git => "https://gitbucket.mobio.vn/git/SDK_APP/ios_swift_lib.git", :tag => "#{spec.version}" }


  spec.source_files = "Sources/**/**/*.{swift,xib,xcdatamodeld}"
  spec.resources = ['*.{xib, .xcassets}']
  spec.resources = 'Sources/Resource/*.xcassets'

  spec.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'IOS.MobioSDK' }

end
