//
//  FeastCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class FeastCell: BaseDailyBriefCell {

    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var feastImage: UIImageView!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var copyrightURL: String?
    @IBOutlet private weak var copyrightLabel: UIButton!
    @IBOutlet private weak var imageToBottom: NSLayoutConstraint!
    @IBOutlet private weak var copyrightButtonHeight: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addOtherView(feastImage)
    }

    @IBAction func copyrightPressed(_ sender: Any) {
        delegate?.presentCopyRight(copyrightURL: copyrightURL)
    }

    func configure(with viewModel: FeastCellViewModel?) {
        guard let model = viewModel else { return }
        skeletonManager.hide()
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: nil)
        skeletonManager.addOtherView(feastImage)
        feastImage.setImage(url: URL(string: model.image ?? ""),
                            skeletonManager: self.skeletonManager)
        copyrightURL = model.copyright
        if copyrightURL?.isEmpty ?? true {
            copyrightButtonHeight.constant = 0
            imageToBottom.constant = 48
            copyrightLabel.isHidden = true
        }
    }
}
