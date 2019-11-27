//
//  DepartureBespokeFeastImageCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureBespokeFeastImageCell: UICollectionViewCell, Dequeueable {

    @IBOutlet weak var picture: UIImageView!
    private let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addOtherView(picture)
    }

    func configure(imageURL: URL?) {
        picture.setImage(url: imageURL,
                         skeletonManager: skeletonManager) { (_) in }
    }
}
