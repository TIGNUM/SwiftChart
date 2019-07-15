//
//  GoodToKnowCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 09.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class GoodToKnowCell: UITableViewCell, Dequeueable {
    @IBOutlet private weak var goodToKnowImage: UIImageView!
    @IBOutlet private weak var goodToKnowFact: UILabel!

    func configure(fact: String?, image: URL?) {
         goodToKnowImage.kf.setImage(with: image, placeholder: R.image.preloading())
         goodToKnowFact.text = fact
    }

}
