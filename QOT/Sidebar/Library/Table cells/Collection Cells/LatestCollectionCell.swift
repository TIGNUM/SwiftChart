//
//  LatestCollectionCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class LatestCollectionCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var latestPostImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }
    
    func setup(headline: String, mediaType: String) {
        headlineLabel.text = headline
        mediaTypeLabel.text = mediaType
    }
}
