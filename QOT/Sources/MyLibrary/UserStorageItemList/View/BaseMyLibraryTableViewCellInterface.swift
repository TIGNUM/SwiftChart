//
//  BaseBookmarkTableViewCellInterface.swift
//  QOT
//
//  Created by Sanggeon Park on 19.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol BaseMyLibraryTableViewCellInterface: UITableViewCell {
    var icon: UIImageView! { get set }
    var contentTitle: UILabel! { get set }
    var infoText: UILabel! { get set }

    func setTitle(_ title: String?)
    func setInfoText(_ text: String?)
}

extension BaseMyLibraryTableViewCellInterface {
    func setTitle(_ title: String?) {
        ThemeText.myLibraryItemsItemName.apply(title?.uppercased(), to: contentTitle)
    }

    func setInfoText(_ text: String?) {
        ThemeText.myLibraryItemsItemDescription.apply(text ?? " ", to: infoText)
    }
}
