//
//  MySprintDetailsHeaderView.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 24/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class MySprintDetailsHeaderView: UIView {

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
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
        return headerView
    }
}

// MARK: - Public methods
extension MySprintDetailsHeaderView {
    func set(title: String?, description: String?, progress: String?) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        titleLabel.attributedText = NSAttributedString(string: title ?? "",
                                                       attributes: [.kern: CharacterSpacing.kern04,
                                                                    .paragraphStyle: style])
        descriptionLabel.attributedText = NSAttributedString(string: description ?? "",
                                                             attributes: [.kern: CharacterSpacing.kern05,
                                                                          .paragraphStyle: style])
        progressLabel.attributedText = NSAttributedString(string: progress ?? "",
                                                          attributes: [.kern: CharacterSpacing.kern02])
    }
}
