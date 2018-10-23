//
//  LibraryViewModelInterface.swift
//  QOT
//
//  Created by Lee Arromba on 22/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol LibraryViewModelInterface {
    var sectionCount: Int { get }
    func titleForSection(_ section: Int) -> NSAttributedString
    func contentCollection(at indexPath: IndexPath) -> [ContentCollection]
    func contentCollectionType(at indexPath: IndexPath) -> LibraryTableViewCell.CollectionViewCellType
    func contentCount(at indexPath: IndexPath) -> Int
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat
}
