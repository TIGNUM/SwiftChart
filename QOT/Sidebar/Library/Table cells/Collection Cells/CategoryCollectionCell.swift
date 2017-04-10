//
//  CategoryCollectionCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .blue
    }
    
    func setup(headline: String, mediaType: String) {
        headlineLabel.text = headline
        mediaTypeLabel.text = mediaType
        print("hello i am collection cell")
    }

}
