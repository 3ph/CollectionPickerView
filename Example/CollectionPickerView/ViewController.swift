//
//  ViewController.swift
//  CollectionPickerView
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Akkyie Y, 2017 Tomas Friml
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE

import UIKit
import CollectionPickerView

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: CollectionPickerView!
    
    let titles = ["Tokyo", "Kanagawa", "Osaka", "Aichi", "Saitama", "Chiba", "Hyogo", "Hokkaido", "Fukuoka", "Shizuoka"]
    
    let font = UIFont(name: "HelveticaNeue-Light", size: 20)!
    let highlightedFont = UIFont(name: "HelveticaNeue", size: 20)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        pickerView.collectionView.reloadData()
        pickerView.collectionView.register(
            CollectionPickerViewCell.self,
            forCellWithReuseIdentifier: NSStringFromClass(CollectionPickerViewCell.self))
        
        // Uncomment to have vertical direction
        //pickerView.isHorizontal = false
        
        // Uncomment to remove wheel effect
        //pickerView.isFlat = true
        
        // Uncomment to prevent selection on scroll
        //pickerView.selectCenter = false
        
        pickerView.reloadData()
    }
    
    fileprivate func sizeForString(_ string: NSString) -> CGSize {
		let size = string.size(attributes: [NSFontAttributeName: self.font])
		let highlightedSize = string.size(attributes: [NSFontAttributeName: self.highlightedFont])
		return CGSize(
			width: ceil(max(size.width, highlightedSize.width)),
			height: ceil(max(size.height, highlightedSize.height)))
	}
}

extension ViewController: UICollectionViewDelegate {
    /*
     
     UIScrollViewDelegate/UICollectionViewDelegate Support
     ----------------------------
     AKPickerViewDelegate inherits UIScroll(Collection)ViewDelegate.
     You can use UIScroll(Collection)ViewDelegate methods
     by simply setting pickerView's delegate.
     
     */
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //NSLog("SCROLL: \(scrollView.contentOffset.x)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        
        NSLog("Selected item: \(titles[index])")
    }
}

// MARK: UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CollectionPickerViewCell.self), for: indexPath) as! CollectionPickerViewCell
        let title = titles[indexPath.item]
        
        cell.label.text = title
        cell.label.font = font
        cell.font = font
        cell.highlightedFont = highlightedFont
        cell.label.bounds = CGRect(origin: CGPoint.zero, size: sizeForString(title as NSString))
        return cell
    }
}


private class CollectionPickerViewCell: UICollectionViewCell {
    var label: UILabel!
    var imageView: UIImageView!
    var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    var highlightedFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    override var isSelected: Bool {
        didSet {
            let animation = CATransition()
            animation.type = kCATransitionFade
            animation.duration = 0.15
            self.label.layer.add(animation, forKey: "")
            self.label.font = self.isSelected ? self.highlightedFont : self.font
        }
    }
    
    func initialize() {
        self.layer.isDoubleSided = false
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
        
        self.label = UILabel(frame: self.contentView.bounds)
        self.label.backgroundColor = UIColor.clear
        self.label.textAlignment = .center
        self.label.textColor = UIColor.gray
        self.label.numberOfLines = 1
        self.label.lineBreakMode = .byTruncatingTail
        self.label.highlightedTextColor = UIColor.black
        self.label.font = self.font
        self.label.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        self.contentView.addSubview(self.label)
        
        self.imageView = UIImageView(frame: self.contentView.bounds)
        self.imageView.backgroundColor = UIColor.clear
        self.imageView.contentMode = .center
        self.imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.addSubview(self.imageView)
    }
    
    init() {
        super.init(frame: CGRect.zero)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init!(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
}

