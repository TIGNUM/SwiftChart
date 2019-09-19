//
//  FeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FeastCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var feastImage: UIImageView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet private weak var imageToBottom: NSLayoutConstraint!
    @IBOutlet private weak var copyrightButtonHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addOtherView(feastImage)
    }

    @IBAction func copyrightPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: copyrightURL)
    }

    func configure(with viewModel: FeastCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: bucketTitle)
        feastImage.kf.setImage(with: URL(string: model.image ?? ""), placeholder: R.image.preloading())
        self.copyrightURL = viewModel?.copyright
        if self.copyrightURL?.isEmpty ?? true {
            copyrightButtonHeight.constant = 0
            imageToBottom.constant = 48
            copyrightLabel.isHidden = true
        }
    }
}
