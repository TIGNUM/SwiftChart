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
    private var title = ""
    private lazy var skeletonManager = SkeletonManager()

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

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
    }

    func configure(title: String?, subtitle: String?) {
        self.title = title ?? ""
        guard let subtitle = subtitle else { return }
        let bkView = UIView()
        ThemeView.level1Selected.apply(bkView)
        selectedBackgroundView = bkView
        skeletonManager.hide()
        ThemeText.linkMenuComment.apply(subtitle, to: subtitleLabel)
    }

    func setEnabled(_ enabled: Bool) {
        isUserInteractionEnabled = enabled
        if enabled {
            ThemeText.myQOTBoxTitle.apply((title), to: titleLabel)
        } else {
            ThemeText.myQOTBoxTitleDisabled.apply((title), to: titleLabel)
        }
    }
}
