//
//  CollectionPickerView.swift
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
//

import UIKit


/// Allows user to override collection view delegate methods
public class CollectionPickerViewForwardDelegate: NSObject, UICollectionViewDelegate {
    
    init(picker: CollectionPickerView) {
        _picker = picker
    }
    internal weak var delegate : UICollectionViewDelegate?
    
    // MARK: - Private
    fileprivate weak var _picker : CollectionPickerView?
    
    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if let p = _picker, p.responds(to: aSelector) {
            return p
        } else if let d = delegate, d.responds(to: aSelector) {
            return d
        }
        return super.responds(to: aSelector)
    }
    
    override public func responds(to aSelector: Selector!) -> Bool {
        if let p = _picker, p.responds(to: aSelector) {
            return true
        } else if let d = delegate, d.responds(to: aSelector) {
            return true
        }
        return super.responds(to: aSelector)
    }
    
}


public class CollectionPickerView: UIView {
    
    
    public let collectionView : UICollectionView
    
    /// Readwrite. Spacing between cells
    @IBInspectable public var cellSpacing : CGFloat = 10
    
    /// Readwrite. Default cell size (based on direction of picker)
    @IBInspectable public var cellSize : CGFloat = 100
    
    /// Readwrite. Select center item on scroll
    @IBInspectable public var selectCenter : Bool = true
    
    /// Readwrite. Determines style of the picker
    @IBInspectable public var isFlat : Bool = false {
        didSet {
            didSetIsFlat()
        }
    }
    
    /// Readwrite. Picker direction
    @IBInspectable public var isHorizontal : Bool = true {
        didSet {
            didSetFlowLayoutDirection()
            didSetMaskDisabled()
        }
    }
    
    /// Readwrite. A float value which determines the perspective representation which used when using wheel style.
    @IBInspectable public var viewDepth: CGFloat = 2000 {
        didSet {
            didSetViewDepth()
        }
    }
    
    /// Readwrite. A boolean value indicates whether the mask is disabled.
    @IBInspectable public var maskDisabled: Bool = false {
        didSet {
            didSetMaskDisabled()
        }
    }
    
    /// Readonly. Currently selected collection view item index
    public private(set) var selectedIndex : Int = 0
    
    public weak var dataSource : UICollectionViewDataSource? {
        didSet {
            collectionView.dataSource = dataSource
        }
    }
    public weak var delegate : UICollectionViewDelegate? {
        didSet {
            _forwardDelegate.delegate = delegate
        }
    }
    
    public override var intrinsicContentSize : CGSize {
        // TODO: figure out max.
        if isHorizontal {
            return CGSize(width: UIView.noIntrinsicMetric, height: cellSize)
        } else {
            return CGSize(width: cellSize, height: UIView.noIntrinsicMetric)
        }
    }
    
    
    override init(frame: CGRect) {
        collectionView = UICollectionView(frame: frame, collectionViewLayout: CollectionPickerViewFlowLayout())
        super.init(frame: frame)
        
        initialize()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: CollectionPickerViewFlowLayout())
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    /**
     Select a cell whose index is given one and move to it.
     :param: index    An integer value which indicates the index of cell.
     :param: animated True if the scrolling should be animated, false if it should be immediate.
     */
    public func selectItem(at index: Int, animated: Bool = false) {
        self.selectItem(at: index, animated: animated, scroll: true, notifySelection: true)
    }
    
    /**
     Reload the picker view's contents and styles. Call this method always after any property is changed.
     */
    public func reloadData() {
        invalidateIntrinsicContentSize()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
        if collectionView.numberOfItems(inSection: 0) > 0 {
            selectItem(at: selectedIndex, animated: false)
        }
    }
    
    // MARK: - Private
    fileprivate var _flowLayout : CollectionPickerViewFlowLayout? {
        get {
            return collectionView.collectionViewLayout as? CollectionPickerViewFlowLayout
        }
    }
    fileprivate var _forwardDelegate : CollectionPickerViewForwardDelegate!
    
    fileprivate func initialize() {
        addSubview(collectionView)
        
        _forwardDelegate = CollectionPickerViewForwardDelegate(picker: self)
        
        collectionView.delegate = _forwardDelegate
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.backgroundColor = UIColor.clear
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // have to call didSets separatele as it's not being invoked for initial values
        didSetFlowLayoutDirection()
        didSetIsFlat()
        didSetMaskDisabled()
        didSetViewDepth()
    }
    
    
    /**
     Private. Used to calculate the x-coordinate of the content offset of specified item.
     :param: item An integer value which indicates the index of cell.
     :returns: An x/y-coordinate of the cell whose index is given one.
     */
    fileprivate func offsetForItem(at index: Int) -> CGFloat {
        let firstIndexPath = IndexPath(item: 0, section: 0)
        let firstSize = self.collectionView(
            collectionView,
            layout: collectionView.collectionViewLayout,
            sizeForItemAt: firstIndexPath)
        var offset: CGFloat = isHorizontal
            ? collectionView.bounds.width / 2 - firstSize.width / 4
            : collectionView.bounds.height / 2 - firstSize.height / 4
        for i in 0 ..< index {
            let indexPath = IndexPath(item: i, section: 0)
            let cellSize = self.collectionView(
                collectionView,
                layout: collectionView.collectionViewLayout,
                sizeForItemAt: indexPath)
            offset += (isHorizontal ? cellSize.width : cellSize.height) + cellSpacing
        }
        
        let selectedIndexPath = IndexPath(item: index, section: 0)
        let selectedSize = self.collectionView(
            collectionView,
            layout: collectionView.collectionViewLayout,
            sizeForItemAt: selectedIndexPath)
        if isHorizontal {
            offset -= collectionView.bounds.width / 2 - selectedSize.width / 2
        } else {
            offset -= collectionView.bounds.height / 2 - selectedSize.height / 2
        }
        
        return offset
    }
    
    /**
     Move to the cell whose index is given one without selection change.
     :param: index    An integer value which indicates the index of cell.
     :param: animated True if the scrolling should be animated, false if it should be immediate.
     */
    fileprivate func scrollToItem(at index: Int, animated: Bool = false) {
        if isFlat {
            collectionView.scrollToItem(
                at: IndexPath(
                    item: index,
                    section: 0),
                at: isHorizontal ? .centeredHorizontally : .centeredVertically,
                animated: animated)
        } else {
            collectionView.setContentOffset(
                CGPoint(
                    x: isHorizontal ? offsetForItem(at: index) : collectionView.contentOffset.x,
                    y: isHorizontal ? collectionView.contentOffset.y : offsetForItem(at: index)),
                animated: animated)
        }
    }
    
    /**
     Private. Select a cell whose index is given one and move to it, with specifying whether it calls delegate method.
     :param: index           An integer value which indicates the index of cell.
     :param: animated        True if the scrolling should be animated, false if it should be immediate.
     :param: notifySelection True if the delegate method should be called, false if not.
     */
    fileprivate func selectItem(at index: Int, animated: Bool, scroll: Bool, notifySelection: Bool) {
        /*
         let oldIndexPath = IndexPath(item: selectedIndex, section: 0)
         let newIndexPath = IndexPath(item: index, section: 0)
         */
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.selectItem(
            at: indexPath,
            animated: animated,
            scrollPosition: UICollectionView.ScrollPosition())
        if scroll {
            scrollToItem(at: index, animated: animated)
        }
        
        selectedIndex = index
        self.delegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
        
        /*
         selectedItem = item
         */
    }
    
    
    fileprivate func didSetFlowLayoutDirection() {
        _flowLayout?.scrollDirection = isHorizontal ? .horizontal : .vertical
        _flowLayout?.invalidateLayout()
    }
    
    fileprivate func didSetIsFlat() {
        _flowLayout?.isFlat = isFlat
    }
    
    fileprivate func didSetMaskDisabled() {
        collectionView.layer.mask = maskDisabled == true ? nil : {
            let maskLayer = CAGradientLayer()
            maskLayer.frame = collectionView.bounds
            maskLayer.colors = [
                UIColor.clear.cgColor,
                UIColor.black.cgColor,
                UIColor.black.cgColor,
                UIColor.clear.cgColor]
            maskLayer.locations = [0.0, 0.33, 0.66, 1.0]
            maskLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            if isHorizontal {
                maskLayer.endPoint = CGPoint(x: 1.0, y: 0.0)
            } else {
                maskLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
            }
            return maskLayer
            }()
    }
    
    fileprivate func didSetViewDepth() {
        collectionView.layer.sublayerTransform = viewDepth > 0.0 ? {
            var transform = CATransform3DIdentity;
            transform.m34 = -1.0 / viewDepth;
            return transform;
            }() : CATransform3DIdentity;
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionPickerView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItem(at: indexPath.item, animated: true)
    }
}

// MARK: - Layout
extension CollectionPickerView {
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        reloadData()
        
        collectionView.frame = collectionView.superview!.bounds
        collectionView.layer.mask?.frame = collectionView.bounds
        if collectionView.numberOfItems(inSection: 0) > 0 {
            selectItem(at: selectedIndex)
        }
    }
}

// MARK: - UIScrollViewDelegate
extension CollectionPickerView : UIScrollViewDelegate {
    
    fileprivate func didScroll(end: Bool) {
        
        if isFlat {
            let center = convert(collectionView.center, to: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: center) {
                self.selectItem(at: indexPath.item, animated: true, scroll: end, notifySelection: true)
            }
        } else {
            for i in 0 ..< collectionView.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: i, section: 0)
                let cellSize = self.collectionView(
                    collectionView,
                    layout: collectionView.collectionViewLayout,
                    sizeForItemAt: indexPath)
                if (isHorizontal && (offsetForItem(at: i) + cellSize.width / 2 > collectionView.contentOffset.x))
                    || (isHorizontal == false && (offsetForItem(at: i) + cellSize.height / 2 > collectionView.contentOffset.y)) {
                    //if i != selectedIndex {
                        selectItem(at: i, animated: true, scroll: end, notifySelection: true)
                    //}
                    break
                }
            }
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidEndDecelerating?(scrollView)
        
        didScroll(end: true)
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        delegate?.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
        
        if !decelerate {
            didScroll(end: true)
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll?(scrollView)
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        collectionView.layer.mask?.frame = collectionView.bounds
        CATransaction.commit()
    }
}

extension CollectionPickerView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let number = collectionView.numberOfItems(inSection: section)
        let firstIndexPath = IndexPath(item: 0, section: section)
        let firstSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: firstIndexPath)
        let lastIndexPath = IndexPath(item: number - 1, section: section)
        let lastSize = self.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: lastIndexPath)
        if isHorizontal {
            return UIEdgeInsets(
                top: 0, left: (collectionView.bounds.size.width - firstSize.width/2) / 2,
                bottom: 0, right: (collectionView.bounds.size.width - lastSize.width/2) / 2
            )
        } else {
            return UIEdgeInsets(
                top: (collectionView.bounds.size.height - firstSize.height/2) / 2, left: 0,
                bottom: (collectionView.bounds.size.height - lastSize.height/2) / 2, right: 0
            )
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isHorizontal {
            return CGSize(width: cellSize, height: collectionView.bounds.height)
        } else {
            return CGSize(width: collectionView.bounds.width, height: cellSize)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }
}
