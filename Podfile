platform :ios, '10.0'

target 'QOT' do
  use_frameworks!

  # Pods for QOT
  pod 'RealmSwift', '~> 2.4'
  pod 'Bond', '~> 6.0'
  pod 'Anchorage', '~> 3.1'
  pod 'R.swift', '~> 3.2'
  pod 'UICollectionViewRightAlignedLayout'

  target 'QOTTests' do
    inherit! :search_paths
    # Pods for testing
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end
