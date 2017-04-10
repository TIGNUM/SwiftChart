//
//  LatestPostCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LatestPostCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, Dequeueable {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
  
    let viewModel = LibraryViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.registerDequeueable(LatestCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.reloadData()
    }
    
    func setUp(title: String) {
        titleLabel.text = title
        collectionView.registerDequeueable(LatestCollectionCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.contentSize.width = (collectionView.contentSize.width  * 500)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.sectionCount
    }
    
   internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let items = viewModel.item(at: indexPath)
    switch items {
    case .audio ( _, _, let headline, let text):
        let cell: LatestCollectionCell = collectionView.dequeueCell(for: indexPath)
       cell.setup(headline: headline, mediaType: text)
         return cell
    case .video( _, _, let headline, let text):
        let cell: LatestCollectionCell = collectionView.dequeueCell(for: indexPath)
        cell.setup(headline: headline, mediaType: text)
         return cell
    }

    }
}
