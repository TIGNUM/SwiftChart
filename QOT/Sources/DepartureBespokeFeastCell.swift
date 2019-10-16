//
//  DepartureBespokeFeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureBespokeFeastCell: BaseDailyBriefCell {

    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var departureBespokeText: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureBespokeFeastModel: DepartureBespokeFeastModel?
    @IBOutlet private weak var stackViewWidth: NSLayoutConstraint!
    @IBOutlet private weak var labelToTop: NSLayoutConstraint!
    var copyrights: [String?] = []
    var images: [String?] = []

    override func prepareForReuse() {
        super.prepareForReuse()
        copyrights = []
        images = []
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(departureBespokeText)
        skeletonManager.addOtherView(stackView)
        }

    func configure(with viewModel: DepartureBespokeFeastModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: bucketTitle)
        self.departureBespokeFeastModel = model
        ThemeText.dailyBriefSubtitle.apply(model.text, to: departureBespokeText)
        var totalWidth: CGFloat = 0
        guard let images = viewModel?.images else { return }
        for (index, image) in images.enumerated() {
            let url = URL(string: image ?? "")
            let addedView = DepartureBespokeFeastImageCell()
            addedView.picture.setImage(url: url) { (actualImage) in
                guard let copyrightURLS = viewModel?.copyrights else { return }
                addedView.copyrightURL = copyrightURLS[index]
                if copyrightURLS[index]?.isEmpty ?? true {
                    addedView.copyrightButton.isHidden = true
                }
                let width = (230 * (actualImage?.size.width ?? 1)) / ( actualImage?.size.height ?? 1 )
                addedView.imageWidth.constant = width
                totalWidth = totalWidth + width
                addedView.needsUpdateConstraints()
                self.stackViewWidth.constant = totalWidth
                addedView.delegate = self.delegate
            }
            stackView.addArrangedSubview(addedView)
        }
    }
}
