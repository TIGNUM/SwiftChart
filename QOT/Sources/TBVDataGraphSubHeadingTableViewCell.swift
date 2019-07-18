//
//  TBVDataGraphSubHeadingTableViewCell.swift
//  QOT
//
//  Created by Ashish Maheshwari on 28.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol TBVDataGraphSubHeadingTableViewCellProtocol: class {
    func showMore()
    func showLess()
}

final class TBVDataGraphSubHeadingTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var showMoreLabel: UILabel!
    @IBOutlet weak var heightConstraintForView: NSLayoutConstraint!
    var callback: ((Bool) -> Void)?
    weak var delegate: TBVDataGraphSubHeadingTableViewCellProtocol?

    var isShowMoreClicked: Bool = false

    @IBAction func showMoreAction(_ sender: Any) {
        isShowMoreClicked = !isShowMoreClicked
        callback?(isShowMoreClicked)
    }

    func configure(subHeading: NSAttributedString?) {
        title.attributedText = subHeading
        let numberOflines = title.maxLines(for: .sfProtextLight(ofSize: 16))
        heightConstraintForView.constant = numberOflines < 4 ? 0 : 60
        if numberOflines > 3 {
            if isShowMoreClicked {
                showLess()
            } else {
                showMore()
            }
        } else {
            title.numberOfLines = numberOflines
        }
    }

    private func showMore() {
        delegate?.showMore()
        showMoreLabel.text = "Show more"
        title.numberOfLines = 3
    }

    private func showLess() {
        delegate?.showLess()
        showMoreLabel.text = "Show less"
        let numberOflines = title.maxLines(for: .sfProtextLight(ofSize: 16))
        title.numberOfLines = numberOflines
    }
}
