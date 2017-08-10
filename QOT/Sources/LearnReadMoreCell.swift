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

    // MARK: - Methods

    func configure(numberOfArticles: Int) {
        readMore.prepareAndSetTextAttributes(text: R.string.localized.prepareContentReadMore().uppercased(), font: Font.H5SecondaryHeadline, characterSpacing: 1)

        let articleText = numberOfArticles < 2 ? R.string.localized.learnContentItemArticle() : R.string.localized.learnContentItemArticles()
        articlesCount.prepareAndSetTextAttributes(text: "\(numberOfArticles) \(articleText)".uppercased(), font: Font.H7Tag, characterSpacing: 2)
        articlesCount.textColor = .black30
    }
}
