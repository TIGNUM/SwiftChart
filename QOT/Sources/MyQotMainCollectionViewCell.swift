//
//  MyQotMainCollectionViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 12.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyQotMainCollectionViewCell: UICollectionViewCell, Dequeueable {

    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    let skeletonManager = SkeletonManager()

    func configure(title: String?, subtitle: String?, enabled: Bool) {
        if enabled {
            ThemeText.myQOTBoxTitle.apply((title ?? ""), to: titleLabel)
        } else {
            ThemeText.myQOTBoxTitleDisabled.apply((title ?? ""), to: titleLabel)
        }

        guard let newSubtitle = subtitle else { return }
        let bkView = UIView()
        ThemeView.level1Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.hide()
        ThemeText.linkMenuComment.apply(newSubtitle, to: subtitleLabel)
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
