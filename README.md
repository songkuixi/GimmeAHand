# GimmeAHand

<img src="./icon.png" alt="GimmeAHand Logo" width="200"/>

Project for Mobile &amp; IoT Computing Services

# Instructions

This app is written in Swift 5 and Xcode 12.4.

With lovely [Swift Package Manager](https://swift.org/package-manager/), the life of managing 3rd party libraries has been way easier than before...

1. Open `GimmeAHand.xcworkspace`.
2. `Cmd + R` to run.
3. To modify the default launching storyboard, in Xcode, click `GimmeAHand.xcodeproj -> General` and change in  `Deployment Info -> Main Interface` and `Info.plist -> Application Scene Manifest -> Scene Configuration -> Application Session Role -> Item 0 -> Storyboard Name`.

# Project Structure

* This app is constructed in MVC (model-view-controller) architecture.
* The files are organized and grouped by **modules**, i.e. Homepage, Order, Profile and Login/Register.
* The view components are mostly in `*.storyboard` files, along with other reusable views written in code (located in `CustomizedViews` folder) for fast prototyping and work division.
* The controller components are in `*ViewController.swift` files.
* The model components are in `*Model.swift` files and managed by `*Helper.swift` files. The models all comply to `NSSecureCoding` protocol so that they can be serialized to `Data` and saved in `UserDefaults`.
* There is a `MockDataStore.swift` file to provide some realistic mock data for demo purposes.

A folder-level app strcture is described in the following tree (only folders are displayed).

```
.
└── GimmeAHand
    ├── Common                      # common reusable view controllers
    ├── Constants                   # constants and enumerations used across the app
    ├── CustomizedViews             # common reusable views
    ├── DataHelper                  # helpers to get/save data models on device
    ├── DataModel                   # data models (Order, User, Community)
    ├── Extensions                  # extensions for UIView, UIViewController, etc.
    ├── Homepage                    # all view controllers related to homepage module
    ├── LoginRegister               # all view controllers related to login and register module
    ├── Order                       # all view controllers related to order module
    └── Profile                     # all view controllers related to profile module
```

# Authors

* [Kuixi Song](https://kuixisong.one)
* Chengyongping Lu
* Linxiao Cui
* Yifan Huang
* Yue Xu
