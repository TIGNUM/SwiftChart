//
//  LearnReadMoreCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 10/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Rswift

class LearnReadMoreCell: UITableViewCell, Dequeueable {

    // MARK: - Properties

    @IBOutlet weak var readMore: UILabel!
    @IBOutlet weak var articlesCount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .clear
    }

    // MARK: - Methods

    func configure(numberOfArticles: Int) {
        readMore.setAttrText(text: R.string.localized.prepareContentReadMore().uppercased(),
                             font: .H5SecondaryHeadline,
                             characterSpacing: 1,
                             color: .nightModeBlack)
        let articleText = numberOfArticles < 2 ? R.string.localized.learnContentItemArticle() : R.string.localized.learnContentItemArticles()
        articlesCount.setAttrText(text: "\(numberOfArticles) \(articleText)".uppercased(),
                                  font: .H7Tag,
                                  characterSpacing: 2)
        articlesCount.textColor = .nightModeBlack30
    }
}
