//
//  LatestPostCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LatestPostCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, Dequeueable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
     var sectionCount = 0
    let viewModel = LibraryViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp(title: String, sectionCount: Int) {
        titleLabel.text = title
        self.sectionCount = sectionCount
        collectionView.registerDequeueable(LatestCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentSize.width = (collectionView.contentSize.width  * 500)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionCount
    }
    
   internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let items = viewModel.item(at: indexPath)
    switch items {
    case .audio ( _, _, let headline, let text):
        let cell: LatestCollectionCell = collectionView.dequeueCell(for: indexPath)
        print(headline)
       cell.setup(headline: headline, mediaType: text)
         return cell
    case .video( _, _, let headline, let text):
        let cell: LatestCollectionCell = collectionView.dequeueCell(for: indexPath)
        cell.setup(headline: headline, mediaType: text)
         return cell
    }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 220, height: 170)
    }
}
