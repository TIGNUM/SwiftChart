//
//  BookMarkSelectionCell.swift
//  QOT
//
//  Created by Sanggeon Park on 21.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class BookMarkSelectionCell: UITableViewCell, Dequeueable {
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var teamLibraryName: UILabel!
    @IBOutlet weak var participantsLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        selectedBackgroundView = backgroundView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkButton.isSelected = selected
    }

}
