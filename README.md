# Workspace

To open the project in Xcode, open `QOT.xcworkspace`, **not** `QOT.xcodeproj`.

# CocoaPods

We are using `CocoaPods` to manage dependencies. Whether it is best practice or not to check in dependencies is arguable. We have chosen to follow CocoaPod's [advice](https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control) and check in dependencies.

If you are part of the iOS dev team [install cocoapods](https://cocoapods.org]).

When adding a cocoapod to the Podfile please use the pod's *major* & *minor* version. For example:

`pod 'RealmSwift', '~> 2.4'`

If you need to install pods use `pod install`. Only use `pod update` if you really intend to update the pods.

# SwiftLint

We are using `SwiftLint` to enforce style and conventions. Please install with [Homebrew](https://brew.sh):

`brew install swiftlint`

The linter will run automatically when the project is built. If you do not have SwiftLint installed you will receive a warning message.

To view the current linting rules see the `.swiftlint.yml` file. Please discuss if you think these rules should change.

# Synx

Please use [Synx](https://github.com/venmo/synx) to ensure that the project file structure matches Xcode's groups. This makes it easier to navigate the project through GitHub's web interface. Once installed you can run Synx by `cd`ing into the projects root and running:

`synx qot.xcodeproj`
