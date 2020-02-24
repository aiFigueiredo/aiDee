Pod::Spec.new do |s|
  s.name         = "aiDee"
  s.version      = "1.0"
  s.summary      = "aiDee is a micro-framework that can be used to authenticate with iOS Devices using biometrics: Touch ID or Face ID."
  s.description  = <<-DESC
  aiDee is a micro-framework that can be used to authenticate with iOS Devices using biometrics: Touch ID or Face ID.
  Written in Swift this aims to be a simple example of Apple's not-so-new [LocalAuthentication](https://developer.apple.com/documentation/localauthentication) API usage. 
  DESC
  s.author                  = "Jose Figueiredo"
  s.social_media_url        = "http://twitter.com/zemiguelfig"
  s.homepage                = "http://github.com/aiFigueiredo/aiDee"
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.source_files            = "aiDee/aiDee/**/*"
  s.exclude_files           = "aiDee/aiDee/*.plist"
  s.ios.deployment_target   = "11.0"
  s.swift_version           = "5.2"
  s.platform                = :ios, "11.0"
  s.source                  = { :git => "https://github.com/aiFigueiredo/aiDee.git", :tag => s.version.to_s }
end