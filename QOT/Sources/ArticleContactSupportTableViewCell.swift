//
//  ArticleContactSupportTableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 08/10/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ArticleContactSupportTableViewCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var separatorView: UIView!

    func configure(attributtedText: NSAttributedString?, showSeparator: Bool = true, textViewDelegate: UITextViewDelegate? = nil) {
        guard let text = attributtedText else { return }
        separatorView.isHidden = !showSeparator
        textView.attributedText = text
        textView.delegate = textViewDelegate
    }
}
