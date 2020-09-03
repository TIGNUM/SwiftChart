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
    @IBOutlet weak var redDotLabel: UILabel!
    private lazy var skeletonManager = SkeletonManager()

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        ThemeView.level1.apply(self)
        isUserInteractionEnabled = false
        contentView.backgroundColor = .clear
        selectedBackgroundView = nil
        layer.borderColor = UIColor.sand40.cgColor
        layer.cornerRadius = 15
        layer.borderWidth = 1
        redDotLabel.circle()
        redDotLabel.isHidden = true
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(subtitleLabel)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(subtitleLabel)
        redDotLabel.isHidden = true
        isUserInteractionEnabled = false
    }

    func setSubtitle(_ subtitle: String?) {
        let bkView = UIView()
        ThemeView.level1Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.hide(.subtitle)
        ThemeText.linkMenuComment.apply(subtitle, to: subtitleLabel)
    }

    func showRedDot(_ show: Bool) {
        redDotLabel.isHidden = !show
    }

    func setTitle(title: String?) {
        skeletonManager.hide(.title)
        setEnabled(false, title: title)
    }

    func setEnabled(_ enabled: Bool, title: String?) {
        isUserInteractionEnabled = enabled
        if enabled {
            ThemeText.myQOTBoxTitle.apply((title), to: titleLabel)
        } else {
            ThemeText.myQOTBoxTitleDisabled.apply((title), to: titleLabel)
        }
    }
}
