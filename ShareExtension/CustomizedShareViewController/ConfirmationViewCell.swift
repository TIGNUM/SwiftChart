//
//  confirmationViewCell.swift
//  ShareExtension
//
//  Created by Anais Plancoulaine on 23.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import UIKit

class ConfirmationViewCell: UITableViewCell {


    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        selectedBackgroundView = backgroundView
    }

//     configure fonts and colours
    func configure(message: String?) {

    }

    @IBAction func checkButtonTapped(_ sender: Any) {
    }
}
