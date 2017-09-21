platform :ios, '10.0'

target 'QOT' do
  use_frameworks!

  # Pods for QOT
  pod 'Bond'
  pod 'Anchorage'
  pod 'R.swift'
  pod 'UICollectionViewRightAlignedLayout'
  pod 'Kingfisher', '~> 3.6'
  pod 'LoremIpsum'
  pod 'iCarousel'
  pod 'RealmSwift'
  pod 'Freddy'
  pod 'Alamofire'
  pod 'KeychainAccess'
  pod 'ActionSheetPicker-3.0'
  pod 'RSKImageCropper'
  pod 'ImagePicker'
  pod 'BonMot'
  pod 'MBProgressHUD'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'UrbanAirship-iOS-SDK'
  pod 'Buglife'
  pod 'PromiseKit'

  target 'QOTTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.2'
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
