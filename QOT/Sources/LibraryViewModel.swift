//
//  LibraryViewModel.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class LibraryViewModel: LibraryViewModelInterface {

    // MARK: - Properties

    private let categories: AnyRealmCollection<ContentCategory>
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return categories.count
    }
    
    var tableViewBackground: UIImageView? {
        return UIImageView(image: R.image.backgroundSidebar())
    }    

    // MARK: - Init

    init(services: Services) {
        self.categories = services.contentService.libraryCategories()
    }
}

// MARK: - Public

extension LibraryViewModel {
    
    func titleForSection(_ section: Int) -> NSAttributedString {
        let title = categories[section].title.uppercased()
        let headline = Style.subTitle(title, .white).attributedString()
        let smallHeadline = Style.headlineSmall(title, .white).attributedString()
        return (section == 0 ? smallHeadline : headline)
    }

    func contentCollection(at indexPath: IndexPath) -> [ContentCollection] {
        return Array(categories[indexPath.section].contentCollections(section: .library))
    }
    
    func contentCollectionType(at indexPath: IndexPath) -> LibraryTableViewCell.CollectionViewCellType {
        return (indexPath.section == 0) ? .latestPost : .category
    }

    func contentCount(at indexPath: IndexPath) -> Int {
        return categories[indexPath.section].contentCollections(section: .library).count
    }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 316 : 313
    }
}
