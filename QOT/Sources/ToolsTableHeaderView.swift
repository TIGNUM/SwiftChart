//
//  ToolsTableHeaderView.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import UIKit

final class ToolsTableHeaderView: UIView {

    private var baseView: QOTBaseHeaderView?
    // MARK: - Properties
    convenience init(title: String, subtitle: String?) {
        self.init(frame: .zero)
        baseView = QOTBaseHeaderView.instantiateBaseHeader(superview: self, darkMode: false)
        baseView?.configure(title: title, subtitle: subtitle)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
