//
//  CollectionPickerFlowLayout.swift
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

public class CollectionPickerViewFlowLayout: UICollectionViewFlowLayout {
    
    open var maxAngle : CGFloat = CGFloat.pi / 2
    open var isFlat : Bool = true
    
    fileprivate var _isHorizontal : Bool {
        get {
            return scrollDirection == .horizontal
        }
    }
    fileprivate var _halfDim : CGFloat {
        get {
            return (_isHorizontal ? _visibleRect.width : _visibleRect.height) / 2
        }
    }
    fileprivate var _mid : CGFloat {
        get {
            return _isHorizontal ? _visibleRect.midX : _visibleRect.midY
        }
    }
    fileprivate var _visibleRect : CGRect {
        get {
            if let cv = collectionView {
                return CGRect(origin: cv.contentOffset, size: cv.bounds.size)
            }
            return CGRect.zero
        }
    }
    
    func initialize() {
        sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        minimumLineSpacing = 0.0
    }
    
    override init() {
        super.init()
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let attributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes {
            if isFlat == false {
                let distance = (_isHorizontal ? attributes.frame.midX : attributes.frame.midY) - _mid
                let currentAngle = maxAngle * distance / _halfDim / (CGFloat.pi / 2)
                var transform = CATransform3DIdentity
                if _isHorizontal {
                    transform = CATransform3DTranslate(transform, -distance, 0, -_halfDim)
                    transform = CATransform3DRotate(transform, currentAngle, 0, 1, 0)
                } else {
                    transform = CATransform3DTranslate(transform, 0, distance, -_halfDim)
                    transform = CATransform3DRotate(transform, currentAngle, 1, 0, 0)
                }
                transform = CATransform3DTranslate(transform, 0, 0, _halfDim)
                attributes.transform3D = transform
                attributes.alpha = abs(currentAngle) < maxAngle ? 1.0 : 0.0
                return attributes;
            }
            return attributes
        }
        
        return nil
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        if isFlat == false {
            var attributes = [UICollectionViewLayoutAttributes]()
            if self.collectionView!.numberOfSections > 0 {
                for i in 0 ..< self.collectionView!.numberOfItems(inSection: 0) {
                    let indexPath = IndexPath(item: i, section: 0)
                    attributes.append(self.layoutAttributesForItem(at: indexPath)!)
                }
            }
            return attributes
        }
        return super.layoutAttributesForElements(in: rect)
    }
    
    //    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
    //        guard let cv = collectionView else { return CGPoint.zero }
    //
    //        let dim = _isHorizontal ? cv.bounds.width : cv.bounds.height
    //        let halfDim = dim / 2
    //        var offsetAdjustment: CGFloat = CGFloat.greatestFiniteMagnitude
    //        var selectedCenter: CGFloat = dim
    //
    //        let center: CGFloat = _isHorizontal ? proposedContentOffset.x + halfDim : proposedContentOffset.y + halfDim
    //        let targetRect = CGRect(x: _isHorizontal ? proposedContentOffset.x : 0, y: _isHorizontal ? 0 : proposedContentOffset.y, width: cv.bounds.size.width, height: cv.bounds.size.height)
    //        let array:[UICollectionViewLayoutAttributes] = layoutAttributesForElements(in: targetRect)!
    //        for layoutAttributes: UICollectionViewLayoutAttributes in array {
    //            let itemCenter: CGFloat = _isHorizontal ? layoutAttributes.center.x : layoutAttributes.center.y
    //            if abs(itemCenter - center) < abs(offsetAdjustment) {
    //                offsetAdjustment = itemCenter - center
    //                selectedCenter = itemCenter
    //                NSLog("PropX: \(proposedContentOffset.x), offset: \(offsetAdjustment), itemCenter: \(itemCenter), center: \(center)")
    //            }
    //        }
    //        return CGPoint(x: proposedContentOffset.x - (_isHorizontal ? offsetAdjustment : 0), y: proposedContentOffset.y + (_isHorizontal ? 0 : offsetAdjustment))
    //    }
    
    var snapToCenter : Bool = true
    
    var mostRecentOffset : CGPoint = CGPoint()
    
    public override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        _ = scrollDirection == .horizontal
//        
//        if snapToCenter == false {
//            return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
//        }
//        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }
//
//        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
//        let offset = isHorizontal ? proposedContentOffset.x + collectionView.contentInset.left : proposedContentOffset.y + collectionView.contentInset.top
//
//        let targetRect : CGRect
//        if isHorizontal {
//            targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
//        } else {
//            targetRect = CGRect(x: 0, y: proposedContentOffset.y, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
//        }
//
//        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)
//
//        layoutAttributesArray?.forEach({ (layoutAttributes) in
//            let itemOffset = isHorizontal ? layoutAttributes.frame.origin.x : layoutAttributes.frame.origin.y
//            if fabsf(Float(itemOffset - offset)) < fabsf(Float(offsetAdjustment)) {
//                offsetAdjustment = itemOffset - offset
//            }
//        })
//
//        if (isHorizontal && velocity.x == 0) || (isHorizontal == false && velocity.y == 0) {
//            return mostRecentOffset
//        }
//
//        if let cv = self.collectionView {
//
//            let cvBounds = cv.bounds
//            let half = (isHorizontal ? cvBounds.size.width : cvBounds.size.height) * 0.5;
//
//            if let attributesForVisibleCells = self.layoutAttributesForElements(in: cvBounds) {
//
//                var candidateAttributes : UICollectionViewLayoutAttributes?
//                for attributes in attributesForVisibleCells {
//
//                    // == Skip comparison with non-cell items (headers and footers) == //
//                    if attributes.representedElementCategory != UICollectionElementCategory.cell {
//                        continue
//                    }
//
//                    if isHorizontal {
//                        if attributes.center.x == 0 || (attributes.center.x > (cv.contentOffset.x + half) && velocity.x < 0) {
//                            continue
//                        }
//                    } else {
//                        if attributes.center.y == 0 || (attributes.center.y > (cv.contentOffset.y + half) && velocity.y < 0) {
//                            continue
//                        }
//                    }
//
//                    candidateAttributes = attributes
//                }
//
//                // Beautification step , I don't know why it works!
//                if (isHorizontal && proposedContentOffset.x == -cv.contentInset.left)
//                    || (isHorizontal == false && proposedContentOffset.y == -cv.contentInset.top) {
//                    return proposedContentOffset
//                }
//
//                guard let _ = candidateAttributes else {
//                    return mostRecentOffset
//                }
//
//                if isHorizontal {
//                    mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - half), y: proposedContentOffset.y)
//                } else {
//                    mostRecentOffset = CGPoint(x: proposedContentOffset.y, y: floor(candidateAttributes!.center.y - half))
//                }
//
//                return mostRecentOffset
//            }
//        }
        
        // fallback
        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return mostRecentOffset
    }
}
