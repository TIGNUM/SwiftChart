//
//  PollButton.swift
//  QOT
//
//  Created by karmic on 04.09.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation

final class PollButton: SelectionButton {

    // MARK: - Properties
    @IBOutlet weak var titeLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!

    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        counterLabel.circle()
    }

    // MARK: - Configure
    func configure(title: String, votes: Int, isSelected: Bool) {
        super.configure(title: title, isSelected: isSelected)
        counterLabel.text = String(votes)
    }
}
