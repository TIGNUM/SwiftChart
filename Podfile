platform :ios, '10.0'

# ignore all warnings from all pods
inhibit_all_warnings!

def shared_pods
  pod 'Kingfisher', '~> 3.6'
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
  pod 'Bond'
  pod 'Anchorage'
  pod 'R.swift'
  pod 'LoremIpsum'
  pod 'RealmSwift'
  pod 'Freddy'
  pod 'Alamofire'
  pod 'KeychainAccess'
  pod 'ActionSheetPicker-3.0'
  pod 'RSKImageCropper'
  pod 'BonMot'
  pod 'MBProgressHUD'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'Appsee'
  pod 'UrbanAirship-iOS-SDK'
  pod 'Buglife'
  pod 'SwiftyBeaver'
  pod 'JSONWebToken'
  pod 'Siren', '~> 3.2.0'
  pod 'HockeySDK', '~> 5.1.2'
  pod 'PredictIO', '~> 5.5.0'

  target 'QOTTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'JPSimulatorHacks'
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
        end
        if target.name == 'PredictIO' || target.name == 'RxSwift' || target.name == 'SwiftyJSON'
            #use default swift version
            else
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
            end
        end
    end
end
