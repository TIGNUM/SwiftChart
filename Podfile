platform :ios, '12.0'

target 'QOT' do
  use_frameworks!
  pod 'R.swift'
  pod 'RSKImageCropper'
  pod 'SVProgressHUD'
  pod 'Airship'
  pod 'Buglife'
  pod 'SwiftyBeaver'
  pod 'AppCenter'
  pod 'Kingfisher'
<<<<<<< HEAD
  pod 'qot_dal', :git => 'git@github.com:TIGNUM/qot_dal.git', :branch => 'feature/QOT-3063-team-tbv-generator-poll'
=======
  pod 'qot_dal', :git => 'git@github.com:TIGNUM/qot_dal.git', :branch => 'feature/QOT-2993-Team-Edition-API'
>>>>>>> d2f6b99f8dd0a8c8f89e0eb14d9f5ec5e2b257d6
  pod 'DifferenceKit'
  pod 'JTAppleCalendar', '7.1.6'
  pod 'SwiftChart', :git => 'git@github.com:SanggeonPark/SwiftChart.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      config.build_settings['EXCLUDED_ARCHS[sdk=iphonesimulator*]'] = 'arm64'
    end
  end
end
