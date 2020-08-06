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
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(contentTitle)
        skeletonManager.addSubtitle(infoText)
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
}
