platform :ios, '10.0'

target 'QOT' do
  use_frameworks!

  # Pods for QOT
  pod 'Bond', '~> 6.0'
  pod 'Anchorage', '~> 3.1'
  pod 'R.swift', '~> 3.2'
  pod 'UICollectionViewRightAlignedLayout', '~> 0.0'
  pod 'Kingfisher', '~> 3.6'
  pod 'LoremIpsum', '~> 1.0'
  pod 'iCarousel', '~> 1.8.3'
  pod 'RealmSwift', '2.7.0'
  pod 'Freddy', '3.0.0'
  pod 'Alamofire', '~> 4.4'
  pod 'KeychainAccess', '~> 3.0.2'
  pod 'ActionSheetPicker-3.0', '~> 2.2.0'
  pod 'RSKImageCropper', '~> 1.6.1'
  pod 'ImagePicker', '~> 2.1.1'
  pod 'BonMot', '~> 4.3.1'

  target 'QOTTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
      config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
    end
  end
end
