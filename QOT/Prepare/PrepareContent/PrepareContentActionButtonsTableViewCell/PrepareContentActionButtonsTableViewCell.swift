//
//  PrepareContentActionButtonsTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentActionButtonsTableViewCellDelegate {
    func didAddPreparationToCalendar()
    func didAddToNotes()
    func didSaveAss()
}

class PrepareContentActionButtonsTableViewCell: UITableViewCell, Dequeueable {

    var delegate: PrepareContentActionButtonsTableViewCellDelegate?

    @IBOutlet weak var addPreparationToCalendarButton: UIButton!
    @IBOutlet weak var addToNotesButton: UIButton!
    @IBOutlet weak var saveAsButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addPreparationToCalendar(sender: UIButton) {
        self.delegate?.didAddPreparationToCalendar()
    }

    @IBAction func addToNotes(sender: UIButton) {
        self.delegate?.didAddToNotes()
    }

    @IBAction func saveAs(sender: UIButton) {
        self.delegate?.didSaveAss()
    }
    
}
