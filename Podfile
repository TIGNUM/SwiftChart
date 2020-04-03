platform :ios, '11.0'

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
  pod 'qot_dal', :git => 'git@github.com:TIGNUM/qot_dal.git', :branch => 'feature/QOT-2849-prepare-related-contentItems'
  pod 'DifferenceKit'
  pod 'JTAppleCalendar', '7.1.6'
  pod 'SwiftChart', :git => 'git@github.com:SanggeonPark/SwiftChart.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
