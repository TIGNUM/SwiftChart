platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def shared_pods
  # Add here the pods you want to share between different targets
end

target 'QOTWidget' do
  use_frameworks!

  # Pods for QOTWidget
  shared_pods
end

target 'QOT' do
  use_frameworks!

  # Pods for QOT
  shared_pods
  pod 'Anchorage'
  pod 'R.swift'
  pod 'Freddy'
  pod 'Alamofire'
  pod 'KeychainAccess'
  pod 'ActionSheetPicker-3.0'
  pod 'RSKImageCropper'
  pod 'BonMot'
  pod 'MBProgressHUD'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'UrbanAirship-iOS-SDK'
  pod 'Buglife'
  pod 'SwiftyBeaver'
  pod 'HockeySDK'
  pod 'Kingfisher'
  pod 'AMScrollingNavbar'
  pod 'Bond', :git => 'git@github.com:SanggeonPark/Bond.git'
  pod 'qot_dal', :git => 'git@github.com:TIGNUM/qot_dal.git'

  target 'QOTTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'JPSimulatorHacks'
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if target.name == 'Bond'
        config.build_settings['SWIFT_VERSION'] = '4.0'
      end
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
