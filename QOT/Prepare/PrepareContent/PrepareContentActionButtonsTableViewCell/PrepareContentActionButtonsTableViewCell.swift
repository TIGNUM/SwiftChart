//
//  PrepareContentActionButtonsTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentActionButtonsTableViewCellDelegate {
    func didAddPreparationToCalendar(sectionID: String, cell: UITableViewCell)
    func didAddToNotes(sectionID: String, cell: UITableViewCell)
    func didSaveAss(sectionID: String, cell: UITableViewCell)
}

class PrepareContentActionButtonsTableViewCell: UITableViewCell, Dequeueable {

    var delegate: PrepareContentActionButtonsTableViewCellDelegate?

    @IBOutlet weak var addPreparationToCalendarButton: UIButton!
    @IBOutlet weak var addToNotesButton: UIButton!
    @IBOutlet weak var saveAsButton: UIButton!
    var item: String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addPreparationToCalendar(sender: UIButton) {
        self.delegate?.didAddPreparationToCalendar(sectionID: self.item, cell: self)
    }

    @IBAction func addToNotes(sender: UIButton) {
        self.delegate?.didAddToNotes(sectionID: self.item, cell: self)
    }

    @IBAction func saveAs(sender: UIButton) {
        self.delegate?.didSaveAss(sectionID: self.item, cell: self)
    }
    
}
