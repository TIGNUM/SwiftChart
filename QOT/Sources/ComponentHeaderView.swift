//
//  ComponentHeaderView.swift
//  QOT
//
//  Created by karmic on 02.04.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ComponentHeaderView: UICollectionReusableView {
    private static let sizingCell = UINib(nibName: "ComponentHeaderView", bundle: nil).instantiate(withOwner: nil, options: nil).first! as? ComponentHeaderView

    // MARK: - Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!

    func configure(title: String?,
                   subtitle: String?,
                   showSeparatorView: Bool = false,
                   secondary: Bool) {
        guard let title = title, let subtitle = subtitle else { return }
        let theme = secondary ? ThemeView.level1Secondary : ThemeView.level1

        titleLabel.text = "/" + title
        subtitleLabel.text = subtitle
        separatorView.isHidden = !showSeparatorView
        theme.apply(self)
    }

    // MARK: Public

    public static func height(title: String, subtitle: String, forWidth width: CGFloat) -> CGFloat {
        sizingCell?.prepareForReuse()
        sizingCell?.configure(title: title, subtitle: subtitle, secondary: false)
        sizingCell?.layoutIfNeeded()
        var fittingSize = UIView.layoutFittingCompressedSize
        fittingSize.width = width
        guard let size = sizingCell?.systemLayoutSizeFitting(fittingSize,
                                                             withHorizontalFittingPriority: .required,
                                                             verticalFittingPriority: .defaultLow) else {
            return .zero
        }

        guard size.height < maximumHeight else {
            return maximumHeight
        }

        return size.height
    }
}
