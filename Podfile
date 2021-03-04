platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

def common_pods
  pod 'R.swift'
  pod 'RSKImageCropper'
  pod 'SVProgressHUD'
  pod 'Airship'
  pod 'Buglife'
  pod 'SwiftyBeaver'
  pod 'AppCenter'
  pod 'Kingfisher'
  pod 'DifferenceKit'
  pod 'JTAppleCalendar', '7.1.6'
  pod 'IOSSecuritySuite'
  pod 'SwiftChart', :git => 'git@github.com:TIGNUM/SwiftChart.git'
  pod 'qot_dal', :git => 'git@github.com:TIGNUM/qot_dal.git', :branch => 'qot-dal/feature-flags'
end

target 'QOT' do
    common_pods
end

target 'TIGNUM XTests' do
    common_pods
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
