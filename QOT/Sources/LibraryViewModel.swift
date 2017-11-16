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

final class LibraryViewModel {

    // MARK: - Properties

    private let categories: AnyRealmCollection<ContentCategory>
    let tools: Bool
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var sectionCount: Int {
        return categories.count
    }
    
    var tableViewBackground: UIImageView? {
        return tools == false ? UIImageView(image: R.image.backgroundSidebar()) : nil
    }    

    // MARK: - Init

    init(services: Services, tools: Bool = false) {
        self.tools = tools
        self.categories = tools == false ? services.contentService.libraryCategories() : services.contentService.toolsCategories()
    }
}

// MARK: - Public

extension LibraryViewModel {
    
    func titleForSection(_ section: Int) -> NSAttributedString {
        let title = categories[section].title.uppercased()
        let headline = Style.subTitle(title, .white).attributedString()
        let smallHeadline = Style.headlineSmall(title, .white).attributedString()
        
        return tools == true ? headline : (section == 0 ? smallHeadline : headline)
    }

    func contentCollection(at indexPath: IndexPath) -> [ContentCollection] {
        return Array(categories[indexPath.section].contentCollections(section: .library))
    }

    func contentCount(at indexPath: IndexPath) -> Int {
        return categories[indexPath.section].contentCollections(section: .library).count
    }
}
