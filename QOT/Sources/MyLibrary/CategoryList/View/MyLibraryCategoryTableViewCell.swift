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
    let skeletonManager = SkeletonManager()

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addSubtitle(categoryName)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addOtherView(iconView)
        selectionStyle = .none
    }

    func configure(withModel: MyLibraryCategoryListModel?) {
        guard let model = withModel else {
            return
        }
        selectionStyle = .default
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.backgroundColor = .accent10
        skeletonManager.hide()
        self.categoryName.text = model.title
        self.iconView.image = model.icon
        self.infoText.text = model.infoText()
    }
}
