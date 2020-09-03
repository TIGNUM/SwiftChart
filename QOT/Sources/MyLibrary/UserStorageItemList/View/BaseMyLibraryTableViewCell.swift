//
//  BaseMyLibraryTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 01/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseMyLibraryTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var bottomSeparator: UIView!
    @IBOutlet weak var updateInfoLavel: UILabel!
    @IBOutlet weak var redDotLabel: UILabel!

    @IBOutlet weak var bottomVirticalSpace: NSLayoutConstraint!
    @IBOutlet weak var updateInfoLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var redDotLeading: NSLayoutConstraint!

    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        redDotLabel.circle()
        redDotLabel.isHidden = true
        skeletonManager.addTitle(contentTitle)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addSubtitle(updateInfoLavel)
        skeletonManager.addOtherView(icon)
        selectionStyle = .none
    }

    func configure() {
        redDotLabel.isHidden = true
        skeletonManager.hide(.otherView)
        let selectedView = UIView()
        ThemeView.level2Selected.apply(selectedView)
        selectedBackgroundView = selectedView
        selectionStyle = .default
    }

    override func layoutSubviews() {
        guard updateInfoLavel != nil else {
            super.layoutSubviews()
            return
        }
        let defaultLabelHeight: CGFloat = 14
        let expectedSize = updateInfoLavel.sizeThatFits(updateInfoLavel.frame.size)
        var expectedHeight: CGFloat = defaultLabelHeight
        if expectedSize.height > defaultLabelHeight {
            expectedHeight = expectedSize.height
        }
        if updateInfoLabelHeight.constant != expectedHeight {
            updateInfoLabelHeight.constant = expectedHeight
            setNeedsUpdateConstraints()
        }
        super.layoutSubviews()
    }
}

extension BaseMyLibraryTableViewCell {
    func setTitle(_ title: String?) {
        skeletonManager.hide(.title)
        guard let titleText = title else { return }
        ThemeText.myLibraryItemsItemName.apply(titleText.uppercased(), to: contentTitle)
    }

    func setInfoText(_ text: String?) {
        skeletonManager.hide(.subtitle)
        guard let info = text else { return }
        ThemeText.myLibraryItemsItemDescription.apply(info, to: infoText)
    }

    func setCreationInfoText(_ text: String?) {
        skeletonManager.hide(.subtitle)
        ThemeText.myLibraryItemsItemDescription.apply(text, to: updateInfoLavel)
        let defaultSpacing: CGFloat = 0
        let gapWhenCreatorInfoIsShowing: CGFloat = 24
        let verticalSpacing: CGFloat = text?.isEmpty == false ? gapWhenCreatorInfoIsShowing : defaultSpacing
        bottomVirticalSpace.constant = verticalSpacing
        setNeedsUpdateConstraints()
    }

    func showRedDot(_ show: Bool) {
        redDotLabel.isHidden = !show
    }
}
