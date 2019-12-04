platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!

target 'QOT' do
  use_frameworks!
  pod 'R.swift'
  pod 'RSKImageCropper'
  pod 'SVProgressHUD'
  pod 'UrbanAirship-iOS-SDK'
  pod 'Buglife'
  pod 'SwiftyBeaver'
  pod 'AppCenter'
  pod 'Kingfisher'
  pod 'qot_dal', :git => 'git@github.com:TIGNUM/qot_dal.git'
  pod 'DifferenceKit'
  pod 'JTAppleCalendar', '7.1.6'
  pod 'SwiftChart', :git => 'git@github.com:voicusimu/SwiftChart.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
