//
//  CategoryCollectionCell.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 4/7/17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Kingfisher

class CategoryCollectionCell: UICollectionViewCell, Dequeueable {
    
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var mediaTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryImageView.layer.cornerRadius = 3.0
    }
    
    func setup(headline: String, placeholderURL: URL, mediaType: String) {
        headlineLabel.attributedText = AttributedString.Library.categoryHeadline(string: headline.makingTwoLines())
        mediaTypeLabel.attributedText = AttributedString.Library.categoryMediaTypeLabel(string: mediaType)
        categoryImageView.kf.indicatorType = .activity
//        categoryImageView.kf.setImage(with: placeholderURL)
//        let p = Bundle.main.path(forResource: "loader", ofType: "jpeg")!
//        let data = try! Data(contentsOf: URL(fileURLWithPath: p))
//        
//        categoryImageView.kf.indicatorType = .image(imageData: data)
//        
//        categoryImageView.kf.setImage(with: placeholderURL)
        
        categoryImageView.kf.setImage(with: placeholderURL) { (image, error, _, _) in
            print(error)
        }
    }
    
}
