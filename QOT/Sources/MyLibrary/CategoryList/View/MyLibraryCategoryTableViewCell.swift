//
//  MyLibraryCategoryTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyLibraryCategoryTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var newItemCountLabel: UILabel!
    @IBOutlet weak var newItemCountLeading: NSLayoutConstraint!
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        newItemCountLabel.circle()
        newItemCountLabel.isHidden = true
        skeletonManager.addSubtitle(categoryName)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addOtherView(iconView)
        selectionStyle = .none
    }

    func configure(withModel: MyLibraryCategoryListModel?) {
        guard let model = withModel else {
            return
        }
        ThemeText.librarySubtitle.apply(model.infoText(), to: infoText)
        ThemeText.myLibraryItemsTitle.apply(model.title, to: categoryName)
        selectionStyle = .default
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.backgroundColor = .tignumPink10
        skeletonManager.hide()
        self.iconView.image = model.icon
        ThemeTint.lightGrey.apply(iconView)
        newItemCountLabel.isHidden = (model.newItemCount == 0)
        categoryName.sizeToFit()
        newItemCountLeading.constant = categoryName.frame.size.width
        self.setNeedsLayout()
    }
}
