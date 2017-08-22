//
//  MyPrepEmptyTableViewCell.swift
//  QOT
//
//  Created by Moucheg Mouradian on 21/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

class MyPrepEmptyTableViewCell: UITableViewCell, Dequeueable {

    @IBOutlet weak var titleLabel: UILabel!

    func setup(with title: String) {
        isUserInteractionEnabled = false
        backgroundColor = .clear
        titleLabel.textColor = .white40
        titleLabel.prepareAndSetTextAttributes(text: title, font: Font.DPText, alignment: .center, lineSpacing: 7, characterSpacing: 1)
    }
}
