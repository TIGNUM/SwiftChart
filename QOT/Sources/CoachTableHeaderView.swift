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
    private var baseHeaderView: QOTBaseHeaderView?

    convenience init(title: String) {
        self.init(frame: .zero)
        baseHeaderView = QOTBaseHeaderView.instantiateBaseHeader(superview: self, darkMode: false)
        baseHeaderView?.configure(title: title, subtitle: nil)
        ThemeText.coachHeader.apply(title.uppercased(), to: baseHeaderView?.titleLabel)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func calculateHeight(for cellWidth: CGFloat) -> CGFloat {
        return baseHeaderView?.calculateHeight(for: cellWidth) ?? 0
    }
}
