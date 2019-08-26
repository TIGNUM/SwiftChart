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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var copyrightButton: UIButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var goodToKnowModel: GoodToKnowCellViewModel?

    @IBAction func CopyrightPressed(_ sender: Any) {
       delegate?.presentCopyRight(copyrightURL: goodToKnowModel?.copyright)
    }

    func configure(with viewModel: GoodToKnowCellViewModel?) {
        goodToKnowImage.kf.setImage(with: viewModel?.image, placeholder: R.image.preloading())
        goodToKnowFact.text = viewModel?.fact
        titleLabel.text = viewModel?.title
        self.goodToKnowModel = viewModel
    }
}
