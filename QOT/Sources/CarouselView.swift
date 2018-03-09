//
//  CarouselView.swift
//  QOT
//
//  Created by Sam Wyndham on 15.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol CarouselViewDataSource: class {
    func numberOfItems(in carouselView: CarouselView) -> Int
    func carouselView(_ carouselView: CarouselView, viewForItemAt index: Int, reusing view: UIView?) -> UIView
}

protocol CarouselViewDelegate: class {
    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Index)
    func carouselView(_ carouselView: CarouselView, didScrollToItemAt index: Index)
    func carouselView(_ carouselView: CarouselView, styleView view: UIView, xPos: CGFloat)
}

extension CarouselViewDelegate {

    // Make all CarouselViewDelegate functions optional
    func carouselView(_ carouselView: CarouselView, didSelectItemAt index: Index) {}
    func carouselView(_ carouselView: CarouselView, didScrollToItemAt index: Index) {}
    func carouselView(_ carouselView: CarouselView, styleView view: UIView, xPos: CGFloat) {}
}

final class CarouselView: UIView {

    private let collectionView: UICollectionView = {
        let layout = CarouselViewLayout()
        layout.scrollDirection = .horizontal
        return UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
    }()

    weak var dataSource: CarouselViewDataSource?
    weak var delegate: CarouselViewDelegate?

    var cellSpacing: CGFloat {
        get { return layout.minimumLineSpacing }
        set { layout.minimumLineSpacing = newValue }
    }

    var cellWidth: CGFloat = 100 {
        didSet { layout.invalidateLayout() }
    }

    var contentInset: UIEdgeInsets {
        get { return collectionView.contentInset }
        set {
            collectionView.contentInset = newValue
            layout.invalidateLayout()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    func scrollToItem(at index: Index, animated: Bool) {
        guard index >= 0,
            index < collectionView.numberOfItems(inSection: 0),
            page(contentOffset: collectionView.contentOffset) != index else {
                return
        }

        collectionView.setContentOffset(contentOffsetForItem(at: index), animated: animated)
    }

    func viewForItem(at index: Index) -> UIView? {
        let indexPath = IndexPath(item: index, section: 0)
        return collectionView.cellForItem(at: indexPath)?.contentView.subviews.first
    }

    func reloadData() {
        collectionView.reloadData()
    }

    private var layout: UICollectionViewFlowLayout {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            preconditionFailure("Wrong layout type")
        }
        return layout
    }

    private func setup() {
        backgroundColor = .clear
        cellSpacing = 0
        cellWidth = 100

        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        addSubview(collectionView)
        collectionView.decelerationRate = UIScrollViewDecelerationRateNormal
        collectionView.edgeAnchors == edgeAnchors
    }

    private func contentOffsetForItem(at index: Index) -> CGPoint {
        let x = -contentInset.left + (CGFloat(index) * (cellWidth + cellSpacing))
        let y = -contentInset.top
        return CGPoint(x: x, y: y)
    }

    private func page(contentOffset: CGPoint) -> Int? {
        let itemCount = collectionView.numberOfItems(inSection: 0)
        let itemAndSpaceWidth = cellWidth + cellSpacing

        guard itemCount > 0, itemAndSpaceWidth > 0 else {
            return nil
        }

        let x = contentOffset.x + contentInset.left
        var page = Int(x / itemAndSpaceWidth)

        let remainder = x - (CGFloat(page) * itemAndSpaceWidth)
        if remainder > (cellWidth / 2) + cellSpacing {
            page += 1
        }
        page = min(max(0, page), itemCount - 1)

        return page
    }

    private func styleView(_ view: UIView, origin: CGPoint) {
        let xOffest = origin.x - collectionView.contentOffset.x - collectionView.contentInset.left
        delegate?.carouselView(self, styleView: view, xPos: xOffest)
    }
}

extension CarouselView: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        if let dataSource = dataSource {
            let currentContent = cell.contentView.subviews.first
            let newContent = dataSource.carouselView(self, viewForItemAt: indexPath.row, reusing: currentContent)
            cell.setContent(newContent)

            if let attr = layout.layoutAttributesForItem(at: indexPath) {
                styleView(newContent, origin: attr.frame.origin)
            }
        }
        return cell
    }
}

extension CarouselView: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselView(self, didSelectItemAt: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = bounds.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
        return CGSize(width: cellWidth, height: height)
    }

    // MARK: UIScrollViewDelegate

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if let page = page(contentOffset: targetContentOffset.pointee) {
            targetContentOffset.pointee.x = contentOffsetForItem(at: page).x
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didEndScrolling(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            didEndScrolling(scrollView)
        }
    }

    private func didEndScrolling(_ scrollView: UIScrollView) {
        if let index = page(contentOffset: scrollView.contentOffset) {
            delegate?.carouselView(self, didScrollToItemAt: index)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for cell in collectionView.visibleCells {
            if let view = cell.contentView.subviews.first {
                styleView(view, origin: cell.frame.origin)
            }
        }
    }
}

private extension UICollectionViewCell {

    func setContent(_ newContent: UIView) {
        if let current = contentView.subviews.first {
            if current !== newContent {
                current.removeFromSuperview()
                contentView.addSubview(newContent)
                newContent.edgeAnchors == contentView.edgeAnchors
            }
        } else {
            contentView.addSubview(newContent)
            newContent.edgeAnchors == contentView.edgeAnchors
        }
    }
}

private class CarouselViewLayout: UICollectionViewFlowLayout {

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if let currentBounds = collectionView?.bounds {
            return currentBounds.height != newBounds.height
        }
        return true
    }
}
