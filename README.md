# CollectionPickerView

[![CI Status](http://img.shields.io/travis/3ph/CollectionPickerView.svg?style=flat)](https://travis-ci.org/3ph/CollectionPickerView)
[![Version](https://img.shields.io/cocoapods/v/CollectionPickerView.svg?style=flat)](http://cocoapods.org/pods/CollectionPickerView)
[![License](https://img.shields.io/cocoapods/l/CollectionPickerView.svg?style=flat)](http://cocoapods.org/pods/CollectionPickerView)
[![Platform](https://img.shields.io/cocoapods/p/CollectionPickerView.svg?style=flat)](http://cocoapods.org/pods/CollectionPickerView)
![Swift](https://img.shields.io/badge/in-swift5-orange.svg)


Generic and customizable picker based on UICollectionView. Picker cells are fully
customizable.

Supports:
 - Flat/wheel look.
 - Snap to center after scroll.
 - Both horizontal and vertical direction.

Fork of <a href='https://github.com/Akkyie/AKPickerView-Swift'>AKPickerView-Swift</a>. Works in iOS 8.

<img src="./Screenshot.gif" width="200" alt="Screenshot" />

## Usage

Since this view is using `UICollectionView` internally you have to provide data same way as you would do with collection view (using dataSource). You can also use delegate if you want to handle item selection or underlaying UIScrollView callbacks. See example project for details.

Set the direction to vertical.
```swift
pickerView.isHorizontal = false
```

Disable wheel effect of the picker.
```swift
pickerView.isFlat = true
```

Prevent center selection when scrolling.
```swift
pickerView.selectCenter = false
```

Set spacing between cells, default 10.
```swift
pickerView.cellSpacing = 10
```

Set cell size (width for horizontal, height for vertical style), default 100.
```swift
pickerView.cellSize = 100
```

Set wheel effect perspective representation.
```swift
pickerView.viewDepth = 2000
```

Disable fading gradient mask.
```swift
pickerView.maskDisabled = true
```

Current selected index might be obtained from `selectedIndex`.
```swift
NSLog("\(pickerView.selectedIndex)")
```

And reload the picker view when any change in data set occurs.
```swift
pickerView.reloadData()
```



## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first. Or simplest way is just to run `pod try`.

## Installation

CollectionPickerView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "CollectionPickerView"
```

## Author

Tomas Friml, instantni.med@gmail.com

## License

CollectionPickerView is available under the MIT license. See the LICENSE file for more info.
