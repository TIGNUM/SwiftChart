# Setup for Exporting Certificates and Provisioning Profile
#!/usr/bin/env bash
set -e

function printHelp() {
  echo "==============================================================================="
  echo "  COMMON USAGE"
  echo "==============================================================================="
  echo "-t : target configuration (default: appstore) [ $available_targets ]"
  echo "-v : version string (default: 3.2.0)"
  echo "-b : build number (default: 7308)"
  echo "example : -t beta -v 3.2.0 -b 7309"
  echo "\n"
}

function cleanUncommittedChanges() {
  echo "==============================================================================="
  echo "  clean current uncommitted changes"
  echo "==============================================================================="
  git stash
  git stash drop
  echo "..."
}

function printConfigurations() {
  echo "==============================================================================="
  echo "  Change xcode build setting for ${app_target}, version ${version_string}, build number ${build_number}"
  echo "==============================================================================="
  echo "..."
}

version_string="3.2.0"
build_number="7309"
app_icon="AppIcon-3.0"
app_target="appstore"

argument_option=""
version_options=("-v","--v","-version","--version","-ver","--ver")
target_options=("-t","--t","-target","--target")
build_number_options=("-b","--b","-build","--build","-buildnumber","--buildnumber","-build_number","--build_number","-build-number","--build-number")
help_options=("-h","--h","-help","--help")

available_targets=("beta","appstore","novartis")

for arg in $@
do
  value=`echo "print '$arg'.lower()" | python`
  if [ "$argument_option" = "" ] ; then
    argument_option=$value
  elif [[ $version_options =~ $argument_option ]] ; then
    version_string=$value
    argument_option=""
  elif [[ $build_number_options =~ $argument_option ]] ; then
    build_number=$value
    argument_option=""
  elif [[ $target_options =~ $argument_option ]] ; then
    if [[ $available_targets =~ $value ]] ; then
      app_target=$value
      argument_option=""
    else
      echo "ERROR: WORNG TARGET. \nAvailable Targets: $available_targets"
      printHelp
      exit 0
    fi
  fi

  if [[ $help_options =~ $argument_option ]] ; then
    printHelp
  fi
done

#cleanUncommittedChanges

printConfigurations

# AppStore
if [ "$app_target" = "appstore" ] ; then
  echo "update Configurations for AppStore Build!!"
  app_bundle_id="com.tignum.qot.v2"
  widget_group_id="group.widget.$app_bundle_id"
  siri_group_id="group.siri.$app_bundle_id"
  share_extension_group_id="group.share.$app_bundle_id"
  internal_validation_scheme_id="qualityoftime"
  team_id="TFH2SGDX62"
  urbanairship_app_key="k_EoxqdfT_6WFazZVGi6wQ"
  urbanairship_app_secrete="64wwwpX8R8Strty8QstJmg"
  hockey_app_id="51390342-f340-4f4f-9a34-f58f8f9b550c"

# Novartis
elif [ "$app_target" = "novartis" ] ; then
  echo "update Configurations for Novartis Build!!"
  app_bundle_id="com.novartis.gbl.gbl.qualityoftime"
  widget_group_id="group.com.novartis.gbl.gbl.qualityoftime.widget"
  siri_group_id="group.com.novartis.gbl.gbl.qualityoftime.siri"
  share_extension_group_id="group.com.novartis.gbl.gbl.qualityoftime.shareextension"
  internal_validation_scheme_id="qualityoftime"
  team_id="K82G24324U"
  urbanairship_app_key="Ab59gjFSSWm5iskvZamE5A"
  urbanairship_app_secrete="pcHYrtuwQpmbBC3hSrR7vQ"
  hockey_app_id="b0a143ad-6f47-4bb2-973a-944768e80a4b"

# Beta 3.0
elif [ "$app_target" = "beta" ] ; then
  echo "update Configurations for Beta(AppCenter) Build!!"
  app_icon="AppIcon-alpha-3.0"
  app_bundle_id="com.tignum.qot.v3"
  widget_group_id="group.widget.com.tignum.qot.v3"
  siri_group_id="group.siri.com.tignum.qot.v3"
  share_extension_group_id="group.share.com.tignum.qot.v3"
  internal_validation_scheme_id="qotbeta3"
  team_id="4FQQH349R5"
  urbanairship_app_key="lC-AKEGBRtGBlh8U03CatQ"
  urbanairship_app_secrete="ZGtdKxcQQgOlMAvoNSvg4Q"
  hockey_app_id="b0fc4862-5edc-47fc-bd1d-83a5a5f9f8a4"
fi

# debug log
set -x

if [ "$app_target" = "novartis" ] ; then # novartis special
  # change UIBackgroundModes
  plutil -remove UIBackgroundModes QOT/Resources/Info.plist
  plutil -insert UIBackgroundModes -json '[ "audio", "fetch", "location", "remote-notification" ]' QOT/Resources/Info.plist

  # change bundle identifier
  sed -i '' "s/com.tignum.qot.novartis/$app_bundle_id/g" QOT.xcodeproj/project.pbxproj
  sed -i '' "s/$app_bundle_id.QOTWidget/$app_bundle_id.widget/g" QOT.xcodeproj/project.pbxproj
  sed -i '' "s/$app_bundle_id.IntentUI/$app_bundle_id.intentui/g" QOT.xcodeproj/project.pbxproj
  sed -i '' "s/$app_bundle_id.Intent/$app_bundle_id.intent/g" QOT.xcodeproj/project.pbxproj
  sed -i '' "s/$app_bundle_id.ShareExtension/$app_bundle_id.shareextension/g" QOT.xcodeproj/project.pbxproj
else
  sed -i '' "s/TARGETED_DEVICE_FAMILY = \"1,2\"/TARGETED_DEVICE_FAMILY = 1/g" QOT.xcodeproj/project.pbxproj
  sed -i '' "s/com.tignum.qot.novartis/$app_bundle_id/g" QOT.xcodeproj/project.pbxproj
fi

# change app group identifier
sed -i '' "s/group.widget.com.tignum.qot.novartis/$widget_group_id/g" QOTWidget/QOTWidget.entitlements
sed -i '' "s/group.widget.com.tignum.qot.novartis/$widget_group_id/g" QOT/QOT.entitlements
sed -i '' "s/group.widget.com.tignum.qot.novartis/$widget_group_id/g" QOTWidget/Model/ExtensionUserDefaults.swift

sed -i '' "s/group.siri.com.tignum/$siri_group_id/g" intent/intent.entitlements
sed -i '' "s/group.siri.com.tignum/$siri_group_id/g" intentUI/intentUI.entitlements
sed -i '' "s/group.siri.com.tignum/$siri_group_id/g" QOT/QOT.entitlements
sed -i '' "s/group.siri.com.tignum/$siri_group_id/g" QOTWidget/Model/ExtensionUserDefaults.swift

sed -i '' "s/group.share.tignum.qot.novartis/$share_extension_group_id/g" ShareExtension/ShareExtension.entitlements
sed -i '' "s/group.share.tignum.qot.novartis/$share_extension_group_id/g" QOT/QOT.entitlements
sed -i '' "s/group.share.tignum.qot.novartis/$share_extension_group_id/g" QOTWidget/Model/ExtensionUserDefaults.swift

# change app scheme
sed -i '' "s/INTERNAL_VALIDATION_SCHEME_IDENTIFIER/$internal_validation_scheme_id/g" QOT/Resources/Info.plist
sed -i '' "s/INTERNAL_VALIDATION_SCHEME/$app_bundle_id/g" QOT/Resources/Info.plist

# Regenerated R related codes.
touch QOT/Generated/R.generated.swift

# change Apple Developer Team ID
sed -i '' "s/4FQQH349R5/$team_id/g" QOT.xcodeproj/project.pbxproj

# change urbanairship Key and Secret
plutil -replace productionAppKey -string $urbanairship_app_key QOT/Resources/AirshipConfig.plist
plutil -replace productionAppSecret -string $urbanairship_app_secrete QOT/Resources/AirshipConfig.plist

if [ "$app_target" = "beta" ] ; then # Beta special
plutil -replace developmentAppKey -string $urbanairship_app_key QOT/Resources/AirshipConfig.plist
plutil -replace developmentAppSecret -string $urbanairship_app_secrete QOT/Resources/AirshipConfig.plist
fi

# change hockey app id
plutil -replace HOCKEY_APP_ID -string $hockey_app_id QOT/Resources/Info.plist
plutil -replace APP_CENTER_ID -string $hockey_app_id QOT/Resources/Info.plist

# change app icon
sed -i '' "s/AppIcon-alpha-3.0/$app_icon/g" QOT.xcodeproj/project.pbxproj

# change version String & build number for widget and apps
plutil -replace CFBundleShortVersionString -string $version_string QOTWidget/Info.plist
plutil -replace CFBundleShortVersionString -string $version_string Intent/Info.plist
plutil -replace CFBundleShortVersionString -string $version_string IntentUI/Info.plist
plutil -replace CFBundleShortVersionString -string $version_string QOT/Resources/Info.plist
plutil -replace CFBundleShortVersionString -string $version_string ShareExtension/Info.plist
plutil -replace CFBundleVersion -string $build_number QOTWidget/Info.plist
plutil -replace CFBundleVersion -string $build_number Intent/Info.plist
plutil -replace CFBundleVersion -string $build_number IntentUI/Info.plist
plutil -replace CFBundleVersion -string $build_number QOT/Resources/Info.plist
plutil -replace CFBundleVersion -string $build_number ShareExtension/Info.plist

# run cocoapods
pod install

# run codesigndoc to get right certificates and provisioning profiles.
# bash -l -c "$(curl -sfL https://raw.githubusercontent.com/bitrise-tools/codesigndoc/master/_scripts/install_wrap-xcode.sh)"
