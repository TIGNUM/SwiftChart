//
//  MyLibraryBookmarkTableViewCell.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ArticleBookmarkTableViewCell: BaseMyLibraryTableViewCell, BaseMyLibraryTableViewCellInterface, Dequeueable {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var preview: UIImageView!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var infoText: UILabel!
}
