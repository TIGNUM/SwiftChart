//
//  MyDataCharTableViewCell.swift
//  QOT
//
//  Created by Voicu on 21.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol MyDataCharTableViewCellDelegate: class {

}

class MyDataCharTableViewCell: MyDataBaseTableViewCell {
    // MARK: - Properties

    weak var delegate: MyDataCharTableViewCellDelegate?
    @IBOutlet weak var tempImageView: UIImageView!

    func configure() {

    }
}
