//
//  DepartureBespokeFeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.10.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class DepartureBespokeFeastCell: BaseDailyBriefCell {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var bucketTitle: UILabel!
    @IBOutlet private weak var departureBespokeText: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var departureBespokeFeastModel: DepartureBespokeFeastModel?
    @IBOutlet private weak var stackViewWidth: NSLayoutConstraint!
    var copyrights: [String?] = []
    var images: [String?] = []
    @IBOutlet private weak var bespokeTitleLabel: UILabel!
    @IBOutlet private weak var bespokeLabelHeight: NSLayoutConstraint!
    @IBOutlet private weak var labelToStack: NSLayoutConstraint!

    override func prepareForReuse() {
        super.prepareForReuse()
        copyrights = []
        images = []
        stackView.removeAllArrangedSubviews()
        startSkeleton()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(departureBespokeText)
        skeletonManager.addOtherView(stackView)
    }
    private func startSkeleton() {
        skeletonManager.addTitle(bucketTitle)
        skeletonManager.addSubtitle(departureBespokeText)
        skeletonManager.addOtherView(stackView)
        skeletonManager.addOtherView(scrollView)
        skeletonManager.addSubtitle(bespokeTitleLabel)
    }

    func configure(with viewModel: DepartureBespokeFeastModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: bucketTitle)
        ThemeText.bespokeTitle.apply((model.subtitle ?? "").uppercased(), to: bespokeTitleLabel)
        let subtitle = model.subtitle
        if subtitle?.isEmpty ?? true {
            labelToStack.constant = 20
            bespokeLabelHeight.constant = 0
        }
        self.departureBespokeFeastModel = model
        ThemeText.dailyBriefSubtitle.apply(model.text, to: departureBespokeText)
        var totalWidth: CGFloat = 0
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
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
                totalWidth += width
                addedView.needsUpdateConstraints()
                self.stackViewWidth.constant = totalWidth
                addedView.delegate = self.delegate
                addedView.configure(imageURL: url)
                self.updateWidth(totalWidth: totalWidth)
            }
            stackView.addArrangedSubview(addedView)
        }
    }

    private func updateWidth(totalWidth: CGFloat) {
        let scrollWidth = scrollView.bounds.width
        if totalWidth < scrollWidth {
            scrollView.isScrollEnabled = false
            scrollView.contentInset = UIEdgeInsets(top: 0, left: (scrollWidth - totalWidth) / 2, bottom: 0, right: 0)
        } else {
            scrollView.isScrollEnabled = true
        }
    }
}
