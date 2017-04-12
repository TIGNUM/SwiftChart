//
//  CategoryPostCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol CategoryPostCellDataSource {
    //    func itemCount
}

final class CategoryPostCell: UITableViewCell, Dequeueable {
    let viewModel = LibraryViewModel()
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    var itemCount = 0
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String, sectionCount: Int) {
        
        titleLabel.attributedText = AttributedString.Library.categoryTitle(string: title.makingTwoLines())
        
        self.itemCount = sectionCount
        collectionView.registerDequeueable(CategoryCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        //        collectionView.isPagingEnabled = true
    }
}

extension CategoryPostCell : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: IndexPath(item: 0, section: indexPath.section))
        
        switch item {
        case .audio ( _, let placeHolderURL, let headline, let text):
            let cell: CategoryCollectionCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(headline: headline, placeholderURL: placeHolderURL, mediaType: text)
            return cell
        case .video( _, let placeHolderURL, let headline, let text):
            let cell: CategoryCollectionCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(headline: headline, placeholderURL: placeHolderURL, mediaType: text)
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        print(self.bounds.height)
        return CGSize(width: 275, height: 180)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      
//        let pageWidth: CGFloat = 275
//       
//        let currentOffset: CGFloat = scrollView.contentOffset.x
//        let targetOffset = targetContentOffset.pointee.x
//
//        var newTargetOffset: CGFloat = 0
//        
//        if targetOffset > currentOffset {
//            newTargetOffset = CGFloat(ceilf(Float(currentOffset / pageWidth))) * pageWidth
//        } else {
//            newTargetOffset = CGFloat(floorf(Float(currentOffset / pageWidth))) * pageWidth
//        }
//        
//        if newTargetOffset < 0 {
//            newTargetOffset = 0
//        } else if newTargetOffset > scrollView.contentSize.width {
//            newTargetOffset = scrollView.contentSize.width
//        }
//        
//        targetContentOffset.pointee.x = currentOffset
//       
//        scrollView.setContentOffset(CGPoint(x: newTargetOffset, y: 0), animated: true)
        
        let cellWidth: CGFloat = 275
        let cellSpaceing: CGFloat = 15
  
        let originalTargetPage = (targetContentOffset.pointee.x) / (cellWidth + cellSpaceing)
        
        let scrollDirection: ScrollDirection
        if velocity.x < 0 {
            scrollDirection = .left
        } else if velocity.x > 0 {
            scrollDirection = .right
        } else {
            scrollDirection = .stationary
        }
        
        let targetPage: Int
        switch scrollDirection {
        case .stationary:
            targetPage = Int(round(originalTargetPage))
        case .left:
            targetPage = Int(floor(originalTargetPage))
        case .right:
            targetPage = Int(ceil(originalTargetPage))
        }
        
        let targetOffset = CGFloat(targetPage) * (cellWidth + cellSpaceing)
        targetContentOffset.pointee.x = targetOffset
        
        
        
        
        
        
        
        
        
//        var targetOffset: CGFloat?
//        
//        if velocity.x == 0 {} else {
//            
//            if velocity.x < 0 {
//            targetOffset = round(originalTargetPage - 1) * (cellWidth + cellSpaceing)
//                
//        } else  {
//            targetOffset = round(originalTargetPage + 1) * (cellWidth + cellSpaceing)
//        }
        
        }
//        targetContentOffset.pointee.x = targetOffset!
//         scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    
}

private enum ScrollDirection {
    case left, stationary, right
}

