//
//  MyQotMainCollectionViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class MyQotMainCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    let skeletonManager = SkeletonManager()

    func configure(title: String?, subtitle: String?, isRed: Bool = false) {
        ThemeText.myQOTBoxTitle.apply((title ?? "").uppercased(), to: titleLabel)

        guard let newSubtitle = subtitle else {
            return
        }
        let bkView = UIView()
        ThemeView.level1Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.hide()
        let theme = isRed ? ThemeText.linkMenuCommentRed : ThemeText.linkMenuComment
        theme.apply(newSubtitle, to: subtitleLabel)
    }

    // MARK: - Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level1.apply(self)
        contentView.backgroundColor = .clear
        selectedBackgroundView = nil
        layer.borderColor = UIColor.sand40.cgColor
        layer.cornerRadius = 15
        layer.borderWidth = 1

        skeletonManager.addSubtitle(subtitleLabel)
    }
}
