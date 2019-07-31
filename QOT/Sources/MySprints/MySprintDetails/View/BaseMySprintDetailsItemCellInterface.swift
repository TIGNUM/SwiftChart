//
//  BaseMySprintDetailsItemCellInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 25/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol BaseMySprintDetailsItemCellInterface: UITableViewCell {
    var itemTextLabel: UILabel! { get set }
    func setText(_ text: String)
    var characterSpacing: CGFloat { get }
}

extension BaseMySprintDetailsItemCellInterface {
    func setText(_ text: String) {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 8
        itemTextLabel.attributedText = NSAttributedString(string: text,
                                                          attributes: [.kern: characterSpacing, .paragraphStyle: style])
    }
}
