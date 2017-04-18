//
//  PrepareContentActionButtonsTableViewCell.swift
//  QOT
//
//  Created by Type-IT on 10.04.2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol PrepareContentActionButtonsTableViewCellDelegate: class {
    func didAddPreparationToCalendar(sectionID: String?, cell: UITableViewCell)
    func didAddToNotes(sectionID: String?, cell: UITableViewCell)
    func didSaveAss(sectionID: String?, cell: UITableViewCell)
}

class PrepareContentActionButtonsTableViewCell: UITableViewCell, Dequeueable {

    weak var delegate: PrepareContentActionButtonsTableViewCellDelegate?

    @IBOutlet weak var addPreparationToCalendarButton: UIButton!
    @IBOutlet weak var addToNotesButton: UIButton!
    @IBOutlet weak var saveAsButton: UIButton!
    var sectionID: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func addPreparationToCalendar(sender: UIButton) {
        delegate?.didAddPreparationToCalendar(sectionID: sectionID, cell: self)
    }

    @IBAction func addToNotes(sender: UIButton) {
        delegate?.didAddToNotes(sectionID: sectionID, cell: self)
    }

    @IBAction func saveAs(sender: UIButton) {
        delegate?.didSaveAss(sectionID: sectionID, cell: self)
    }
    
}
