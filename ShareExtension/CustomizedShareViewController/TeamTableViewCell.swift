//
//  TeamCell.swift
//  ShareExtension
//
//  Created by Anais Plancoulaine on 19.06.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

class TeamTableViewCell: UITableViewCell {

    @IBOutlet private weak var teamLibraryName: UILabel!
    @IBOutlet private weak var participantsLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        selectedBackgroundView = backgroundView
    }

//     configure fonts and colours
    func configure(teamName: String?, participants: Int) {
        teamLibraryName.text = teamName ?? "" + " library"
        participantsLabel.text = String(participants) + " participants"
    }
    
    @IBAction func checkButtonTapped(_ sender: Any) {
        checkButton.isSelected.toggle()
    }
}
