//
//  NoteTableViewCell.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 05/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell, BaseMyLibraryTableViewCellInterface, Dequeueable {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var infoText: UILabel!
}
