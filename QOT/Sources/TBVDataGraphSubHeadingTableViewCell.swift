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

    private var isShowMoreClicked: Bool = false
    private var numberOfLines = 0

    @IBAction func showMoreAction(_ sender: Any) {
        isShowMoreClicked = !isShowMoreClicked
        callback?(isShowMoreClicked)
    }

    func configure(subHeading: String?, isShowMoreClicked: Bool) {
        self.isShowMoreClicked = isShowMoreClicked
        ThemeText.tbvTrackerBody.apply(subHeading, to: title)
        numberOfLines = title.maxLines(for: .sfProtextLight(ofSize: 16))
        heightConstraintForView.constant = numberOfLines < 4 ? 0 : 60
        if numberOfLines > 3 {
            if isShowMoreClicked {
                showLess()
            } else {
                showMore()
            }
        } else {
            title.numberOfLines = numberOfLines
        }
    }

    private func showMore() {
        delegate?.showMore()
        ThemeText.tbvButton.apply(R.string.localized.tbvShowMore(), to: showMoreLabel)
        title.numberOfLines = 3
    }

    private func showLess() {
        delegate?.showLess()
        ThemeText.tbvButton.apply(R.string.localized.tbvShowLess(), to: showMoreLabel)
        title.numberOfLines = numberOfLines
    }
}
