//
//  MyPrepsTableViewCell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MyPrepsTableViewCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var calendarIcon: UIImageView!

    var skeletonManager = SkeletonManager()
    var hasData = false

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(subtitleLabel)
        skeletonManager.addOtherView(calendarIcon)
        ThemeView.level3.apply(self)
        setSelectedColor(.carbon, alphaComponent: 1)
        hasData = false
    }

    // MARK: Configure
    func configure(title: String?, subtitle: String?) {
        guard let titleText = title else { return }
        hasData = true
        skeletonManager.hide()
        ThemeText.myQOTPrepCellTitle.apply(titleText, to: titleLabel)
        ThemeText.datestamp.apply(subtitle, to: subtitleLabel)
    }
}
