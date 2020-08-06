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
    var delegate: CustomizedShareViewController?

    override func awakeFromNib() {
        super.awakeFromNib()
        let backgroundView = UIView()
        selectedBackgroundView = backgroundView
    }

    func configure(teamName: String?, participants: Int, shareExtensionStrings: ExtensionModel.ShareExtensionStrings?) {
        let libraryString = shareExtensionStrings?.library ?? ""
        let privateString = shareExtensionStrings?.personal ?? ""
        let participantsString = shareExtensionStrings?.participants ?? ""
        teamLibraryName.text = teamName ?? "" + " " + libraryString
        participantsLabel.text = participants == 0 ? privateString : String(participants) + " " + participantsString
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        checkButton.isSelected.toggle()
        self.isSelected = checkButton.isSelected
        delegate?.didSelectTeam(sender.tag)
    }
}
