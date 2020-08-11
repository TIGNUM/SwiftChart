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

    @IBOutlet weak var bottomVirticalSpace: NSLayoutConstraint!

    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(contentTitle)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addSubtitle(updateInfoLavel)
        skeletonManager.addOtherView(icon)
        selectionStyle = .none
    }

    func configure() {
        skeletonManager.hide(.otherView)
        let selectedView = UIView()
        ThemeView.level2Selected.apply(selectedView)
        selectedBackgroundView = selectedView
        selectionStyle = .default
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
        var verticalSpacing: CGFloat = 21 // default
        if text?.isEmpty != false {
            // adjust vertical space
            verticalSpacing += 20 // labelHeight 12 + spacing 8
        }
        bottomVirticalSpace.constant = verticalSpacing
        setNeedsUpdateConstraints()
    }
}
