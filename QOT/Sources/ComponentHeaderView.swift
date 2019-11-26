//
//  ComponentHeaderView.swift
//  QOT
//
//  Created by karmic on 02.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ComponentHeaderView: UICollectionReusableView {

    // MARK: - Properties

    private var baseHeaderView: QOTBaseHeaderView?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = QOTBaseHeaderView.instantiateBaseHeader(superview: self)
    }

    func configure(title: String?, subtitle: String?, secondary: Bool) {
        guard let title = title, let subtitle = subtitle else { return }
        let theme = secondary ? ThemeView.level1Secondary : ThemeView.level1
        baseHeaderView?.configure(title: title.uppercased(), subtitle: subtitle)
        ThemeText.strategyHeader.apply(title.uppercased(), to: baseHeaderView?.titleLabel)
        ThemeText.strategySubHeader.apply(subtitle, to: baseHeaderView?.subtitleTextView)
        theme.apply(self)
    }

    // MARK: Public

    func calculateHeight(for cellWidth: CGFloat) -> CGFloat {
        return baseHeaderView?.calculateHeight(for: cellWidth) ?? 0
    }
}
