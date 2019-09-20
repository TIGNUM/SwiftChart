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
        self.selectedBackgroundView = UIView(frame: self.bounds)
        self.selectedBackgroundView?.backgroundColor = .accent10
        skeletonManager.addSubtitle(categoryName)
        skeletonManager.addSubtitle(infoText)
        skeletonManager.addOtherView(iconView)
    }

    func configure(withModel: MyLibraryCategoryListModel?) {
        guard let model = withModel else {
            return
        }
        skeletonManager.hide()
        self.categoryName.text = model.title
        self.iconView.image = UIImage(named: model.iconName ?? "")
        self.infoText.text = model.infoText()
    }
}
