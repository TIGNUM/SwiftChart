//
//  BaseBookmarkTableViewCellInterface.swift
//  QOT
//
//  Created by Sanggeon Park on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol BaseMyLibraryTableViewCellInterface: UITableViewCell {
    var icon: UIImageView! { get set }
    var contentTitle: UILabel! { get set }
    var infoText: UILabel! { get set }

    func setTitle(_ title: String?)
    func setInfoText(_ text: String?)
}

extension BaseMyLibraryTableViewCellInterface {
    func setTitle(_ title: String?) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 6
        style.lineBreakMode = .byTruncatingTail
        let attributedString = NSAttributedString(string: title ?? " ",
                                                  attributes: [.paragraphStyle: style, .kern: CharacterSpacing.kern1])
        self.contentTitle.attributedText = attributedString
    }

    func setInfoText(_ text: String?) {
        self.infoText.attributedText = NSAttributedString(string: text ?? " ",
                                                          attributes: [.kern: CharacterSpacing.kern05])
    }
}
