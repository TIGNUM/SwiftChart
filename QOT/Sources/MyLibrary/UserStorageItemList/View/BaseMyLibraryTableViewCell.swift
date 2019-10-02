//
//  BaseMyLibraryTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 01/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class BaseMyLibraryTableViewCell: UITableViewCell {
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }

    func configure() {
        skeletonManager.hide()
        let selectedView = UIView()
        ThemeView.level2Selected.apply(selectedView)
        selectedBackgroundView = selectedView
    }
}

extension BaseMyLibraryTableViewCell {
    func setTitle(_ title: String?) {
        guard let titleText = title else { return }
        configure()
        ThemeText.myLibraryItemsItemName.apply(titleText.uppercased(), to: contentTitle)
    }

    func setInfoText(_ text: String?) {
        guard let info = text else { return }
        ThemeText.myLibraryItemsItemDescription.apply(info, to: infoText)
    }
}
