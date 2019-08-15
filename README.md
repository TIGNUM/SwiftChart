# Workspace

To open the project in Xcode, open `QOT.xcworkspace`, **not** `QOT.xcodeproj`.

# CocoaPods

We are using `CocoaPods` to manage dependencies. Whether it is best practice or not to check in dependencies is arguable. We have chosen to follow CocoaPod's [advice](https://guides.cocoapods.org/using/using-cocoapods.html#should-i-check-the-pods-directory-into-source-control) and check in dependencies.

If you are part of the iOS dev team [install cocoapods](https://cocoapods.org]).

When adding a cocoapod to the Podfile please use the pod's *major* & *minor* version. For example:

`pod 'RealmSwift', '~> 2.4'`

`bundle exec pod install`

If you need to install pods use `pod install`. Only use `pod update` if you really intend to update the pods.

# SwiftLint

We are using `SwiftLint` to enforce style and conventions. Please install with [Homebrew](https://brew.sh):

`brew install swiftlint`

The linter will run automatically when the project is built. If you do not have SwiftLint installed you will receive a warning message.

To view the current linting rules see the `.swiftlint.yml` file. Please discuss if you think these rules should change.

# Line length

For code, aim to keep lines to 120 characters but let Xcode soft wrap the text. For comments, please hard wrap at 120 characters.

# Project Structure

The choosen architecture is [Clean Swift](https://clean-swift.com/clean-swift-ios-architecture/).
We organize each use case under a new group nested within Scenes.
A new created scene consits of the following files:

* Configurator
* Interactor
* Interface
* Model
* Presenter
* Router
* ViewController
* Worker

To generate a new scene use the customized version of Clean Swift VIP templates `[Tignum QOT] VIP Templates`.
Unzip `[Tignum QOT] VIP Templates.zip` from the project and move to `~/Library/Developer/Xcode/Templates/File Templates`.
Xcode will list the template now under `New File…`.

# qot_dal

Data access layer for QOT `qot_dal` is a Private Pod.
Add `import qot_dal` to access `QDMModels` and `Services` for `CRUD` operations.
Xcode prints in the terminal on every build the location of the `realm data base`.

With [Realm Studio](https://realm.io/products/realm-studio) we can see our data.
`open -a "Realm Studio" file:///…/QOT.V3.realm` 