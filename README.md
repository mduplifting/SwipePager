# SwipePager

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)
[![Issues](https://img.shields.io/github/issues/naoto0822/SwipePager.svg?style=flat
)](https://github.com/naoto0822/SwipePager/issues?state=open)

SwipePager is UIPageViewController wrapper like Gunosy, SmartNews UI.

<img src="Screenshots/swipepager-demo.gif"/>

# Version

- current vesion 1.1.0

# Requirements

- iOS8 and up
- Swift 2.1
- XCode 6.2

# Installation

### using CocoaPods

add the following line to your Podfile:

```ruby
pod 'SwipePager', :git => 'https://github.com/mduplifting/SwipePager.git'
```

and import

```swift
import SwipePager
```

### manual

- add `SwipePager.swift` and `SwipePagerMenu.swift` in `Source/` to your project.

# Usage

### 1. protocol declaration

 ・`SwipePagerDataSource`
 ・`SwipePagerDelegate`

 ```swift
 class ViewController: UIViewController, SwipePagerDataSource, SwipePagerDelegate
 ```

### 2. SwipePager initialize

 initialize and need call `reloadData()`

 ```swift
 override func viewDidLoad() {
     super.viewDidLoad()

     let swipePager = SwipePager(frame: frame, transitionStyle: .Scroll)
     swipePager.dataSource = self
     swipePager.delegate = self
     self.view.addSubview(swipePager)
     swipePager.reloadData()
 }
 ```

### 3. `SwipePagerDataSource` Protocol

 ・`func sizeForMenu(#swipePager: SwipePager) -> CGSize`

 ```swift
 func sizeForMenu(#swipePager: SwipePager) -> CGSize {
     return CGSizeMake(80, 50)
 }
 ```


 ・`func menuViews(#swipePager: SwipePager) -> [SwipePagerMenu]`

 ```swift
 func menuViews(#swipePager: SwipePager) -> [SwipePagerMenu] {
     // use SwipePagerMenu Class
     var array: [SwipePagerMenu] = []

     for var i = 0; i < 8; i++ {
         var menu = SwipePagerMenu()
         // customize color
         menu.stateNormalColor = UIColor.lightGrayColor()
         menu.stateNormalFontColor = UIColor.whiteColor()
         menu.stateHighlightColor = UIColor.blackColor()
         menu.stateHighlightFontColor = UIColor.whiteColor()
         // label title
         if i == 0 { menu.title = "0" }
         if i == 1 { menu.title = "1" }
         if i == 2 { menu.title = "2" }
         array.append(menu)
     }

     return array
 }
 ```


 ・`func viewControllers(#swipePager: SwipePager) -> [UIViewController]`

 ```swift
 func viewControllers(#swipePager: SwipePager) -> [UIViewController] {
     var array: [UIViewController] = []

     for var i = 0; i < 8; i++ {
         let viewController = UIViewController()
         // viewController setting...
         array.append(viewController)
     }

     return array
 }
 ```

### 4. `SwipePagerDelegate` Protocol

 ```swift
 func swipePager(#swipePager: SwipePager, didMoveToPage page: Int) {
        println("move to :" + page.description)
 }
 ```

# `SwipePagerMenu` Class

### property

・`title`: menu title.

・`font`: menu font.

・`stateNormalColor`: state normal menu color.

・`stateNormalFontColor`: state normal font color.

・`stateHighlightColor`: state highlight menu color.

・`stateHighlightFontColor`: state highlight font color.

# Option

### currentPage

can setting start page.  
`SwipePager` Class property. (default 0)

```swift
swipePager.currentPage = 2
```

### swipeEnabled

disEnabled swipe gesture.  
`SwipePager` Class property. (default true)

```swift
swipePager.swipeEnabled = false
```

# License

The MIT License (MIT)

Copyright (c) 2015 naoto yamaguchi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
