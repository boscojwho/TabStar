<img src="https://github.com/boscojwho/TabStar/assets/2549615/86aa33cb-033c-4a0a-b479-9c0048f615e9" width="400">

# TabStar
`TabStar` allows users to use an app’s tab bar to navigate backwards on a navigation stack, and also gives apps the ability to customize what happens when users re-select a tab.

> This package was originally written by yours truly for [Mlem for Lemmy on iOS](https://github.com/mlemgroup/mlem), an open-source Lemmy client...go check it out! 😇

# Features
- Reliably dismiss views on a `NavigationStack` via system or custom tab bar.
- Allow apps to customize tab re-selection behaviour (e.g. scroll-to-top before dismissing view).
- All in a neat little package 😎

# Installation
## Swift Package Manager
Add `TabStar` to your Xcode project by adding a package dependency to your `Package.swift` file.
```swift
dependencies: [
    .package(url: "https://github.com/boscojwho/TabStar.git", from: "1.0.0")
]
```
Alternatively, open your Xcode project, and navigate to `File > Swift Packages > Add Package Dependency...` and enter `https://github.com/boscojwho/TabStar.git`.

# Why?
1. This doesn't come built-in to SwiftUI's `TabView` (yes, it's built-in to `UITabBarController`).

2. Reliability
- Doesn’t SwiftUI already provide a way to programmatically manipulate a `NavigationStack`’s path whether you use `NavigationPath` or a custom path type? 

- Yes, but unfortunately programmatic path manipulation causes the path/UI states to become corrupt on both iOS 16/17, [see here for a sample project demonstrating this issue](https://github.com/boscojwho/NavigateDismissBug-SwiftUI.git).

- Essentially, if users rapidly trigger programmatic navigation path manipulation while a dismiss action is in-flight, the path’s state and the stack’s UI state become de-synced – this is easily reproducible. When that happens, users can no longer properly navigate using onscreen buttons, and apps performing programmatic path manipulation will encounter unexpected behaviour.

- `TabStar` helps by relying on SwiftUI’s `@Environment(\.dismiss)` action to perform programmatic dismissal. That `DismissAction` is reliable because it is synced to the onscreen state of `NavigationStack`. Essentially, it doesn’t allow for dismiss actions to happen if one is already in-flight or if the view associated with a dismiss action isn’t yet visible.

# Overview
`TabStar` performs two types of tab bar navigation actions:
- Primary: This is the dismiss action, and is always performed last.
- Auxiliary: This is where apps can customize tab re-selection to perform any view-specific behaviours. The simplest example is “scroll-to-top”.  Other examples may include scrolling up posts one-by-one in a Mastodon client app.

# How To Integrate: Basic

> Hint: See the example project included with this package for demo code.

## Enabling Tab Re-Selection
For either `SwiftUI.TabView` or any custom tab view, you will need to ensure that tab selection triggers a change update on re-select. This functionality is currently not provided by `TabStar`. For an example implementation, see `TabReselection` in the example project.

Once you are able to detect when users re-select a selected tab, you are ready to integrate `TabStar` to allow users to perform custom actions via the tab bar.

## Tab Root View
To integrate `TabStar` into your app, you will need to start by configuring each tab’s root view.
1. Each tab will need to have its own `NavigationStack`. Optionally, you may configure a tab with a `NavigationSplitView` (see example app on how to configure a Split View).
2. Add the following properties to a tab’s root view:
```swift
@StateObject private var navigation: Navigation = .init()

AND

@State private var navigationPath: NavigationPath = .init()

OR

@State private var navigationPath: [YourTabPath] = []
```

and configure your stack like this
```swift
NavigationStack(path: $navigationPath) { ... }
```
3. Apply the following view modifiers to a tab’s `NavigationStack`:
```swift
.environment(\.navigationPathCount, navigationPath.count)
.environmentObject(navigation)
```
5. On a tab’s root view inside its `NavigationStack`, apply the following view modifiers:
```swift
.tabBarNavigationEnabled(Tab.inbox, navigation)
.hoistNavigation()
```

## Tab Destination Views
For all destination views that can be pushed onto a `NavigationStack`, the following setup is required:
1. Apply the following view modifier to the top-level view
```swift
View { ... }
    .hoistNavigation()
```

And that’s it for integrating `TabStar` in a simple tabbed application. See below for examples on how to integrate `TabStar` in some more complicated view configurations.

# How To Integrate: Advanced

## Auxiliary Actions
- Simply return `true` while there is an auxiliary action to be performed. Return `false` when a view should perform its dismiss action.

# Implementation Details

## ScrollView
- If your app uses SwiftUI’s native `TabView`, you can safely use `ScrollViewReader` inside a `NavigationStack`. 
- If you are using a custom tab view (e.g. some variation of `ZStack`), you may need to move the `ScrollViewReader` outside of the `NavigationStack`. In this setup, you may also need to pass that scroll proxy to destination views via the environment, instead of declaring a `ScrollViewReader` for each view, as the latter may result in unexpected behaviour. Your mileage may vary.

## NavigationSplitView
- See the example app for a sample implementation, including how to show/hide the sidebar on iPad.

## Scroll-to-Top + LazyVStack
- You may need to put your “scroll-to-top” view inside a `LazyVStack` in order for `.onAppear`/`.onDisappear` to be called in the expected ways. Your mileage may vary.

## Hoisting Dismiss Actions
In some instances, you may encounter an issue where the hoist dismiss action view modifier causes SwiftUI to enter an infinite loop when attempting to access the dismiss action from the environment. If so, explicitly define `@Environment(\.dismiss)` in your view, and pass it into the view modifier.
- IMPORTANT: In this scenario, each view must define its own dismiss action. In other words, do not nest your destination views.

## Navigation Path
This isn't specific to `TabStar`, but you may wish to use a custom navigation path over SwiftUI's `NavigationPath` if you start seeing views pop off the navigation stack without animations. Your mileage may vary.

# Contribute!
Feel free to contribute by opening an issue or submitting a pull request 🫶
