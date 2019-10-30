//
//  MySprintDetailsHeaderView.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 24/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintDetailsHeaderView: UIView {

    var baseHeaderview: QOTBaseHeaderView?
    @IBOutlet weak var headerView: UIView!
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var progressLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    static func instantiateFromNib() -> MySprintDetailsHeaderView {
        guard let headerView = R.nib.mySprintDetailsHeaderView.instantiate(withOwner: self).first
            as? MySprintDetailsHeaderView else {
            fatalError("Cannot load my sprint details header view")
        }
        headerView.baseHeaderview = R.nib.qotBaseHeaderView.firstView(owner: self)
        headerView.baseHeaderview?.addTo(superview: headerView.headerView, showSkeleton: true)

        return headerView
    }
}

// MARK: - Public methods
extension MySprintDetailsHeaderView {
    func set(title: String?, description: String?, progress: String?) {
        baseHeaderview?.configure(title: title, subtitle: nil)
        ThemeText.mySprintDetailsDescription.apply(description, to: descriptionLabel)
        ThemeText.mySprintDetailsProgress.apply(progress, to: progressLabel)
    }
}
