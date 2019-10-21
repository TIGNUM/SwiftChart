//
//  CoachTableHeaderView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 06.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class CoachTableHeaderView: UIView {

    // MARK: - Properties
    private var baseView: QOTBaseHeaderView?

    convenience init(title: String, subtitle: String) {
        self.init(frame: .zero)
        baseView = QOTBaseHeaderView.instantiateBaseHeader(superview: self, darkMode: false)
        baseView?.configure(title: title, subtitle: subtitle)
        ThemeText.coachHeader.apply(title.uppercased(), to: baseView?.titleLabel)
        ThemeText.coachHeaderSubtitle.apply(subtitle, to: baseView?.subtitleTextView)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func calculateHeight(for cellWidth: CGFloat) -> CGFloat {
        return baseView?.calculateHeight(for: cellWidth) ?? 0
    }
}
