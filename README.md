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

# Line length

For code, aim to keep lines to 120 characters but let Xcode soft wrap the text. For comments, please hard wrap at 120 characters.

# Project Structure

We are aiming to use a combination of the [coordinator pattern](http://khanlou.com/2015/10/coordinators-redux/) and MVVM with reactive view models. Coordinators should be lightweight and manage the setting up and flow between view controllers including applying transitions through `UIPresentationController`s etc. They act as glue resulting in decoupled view controllers. 

In general:

- A coordinator will be initialized with an existing view controller and once the `start` method is called transition to a new view controller that they manage. 
- They will set up that view controller with a view model and any other required objects/values.
- They will act as the delegate of that view controller responding to events that will change data or should instantiate new view controllers.
- They may spawn child coordinators to manage view controllers that they transition too.
