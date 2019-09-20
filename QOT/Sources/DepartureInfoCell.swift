//
//  DepartureInfoCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 10.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureInfoCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var departureText: UILabel!
    @IBOutlet private weak var departureImage: UIImageView!

    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureModel: DepartureInfoCellViewModel?
    var copyrightURL: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(departureText)
        skeletonManager.addOtherView(departureImage)
    }

    func configure(with viewModel: DepartureInfoCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: bucketTitle)
        self.departureModel = model
        skeletonManager.addOtherView(departureImage)
        departureImage.kf.setImage(with: URL(string: model.image ?? ""), placeholder: R.image.preloading(), options: nil, progressBlock: nil) { [weak self] (_) in
            self?.skeletonManager.hide()
        }
        ThemeText.dailyBriefSubtitle.apply(model.text, to: departureText)
    }

    @IBAction func copyrightButtonPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: departureModel?.copyright)
    }
}
