//
//  ToolsViewModel.swift
//  QOT
//
//  Created by Lee Arromba on 22/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

final class ToolsViewModel: LibraryViewModelInterface {
    
    // MARK: - Properties
    
    private let categories: AnyRealmCollection<ContentCategory>
    let updates = PublishSubject<CollectionUpdate, NoError>()
    let fadeMaskLocation: UIView.FadeMaskLocation
    
    var sectionCount: Int {
        return categories.count
    }
    
    var tableViewBackground: UIImageView? {
        return nil
    }
    
    // MARK: - Init
    
    init(services: Services, fadeMaskLocation: UIView.FadeMaskLocation) {
        self.categories = services.contentService.toolsCategories()
        self.fadeMaskLocation = fadeMaskLocation
    }
}

// MARK: - Public

extension ToolsViewModel {
    
    func titleForSection(_ section: Int) -> NSAttributedString {
        let title = categories[section].title.uppercased()
        let headline = Style.subTitle(title, .white).attributedString()
        return headline
    }
    
    func contentCollection(at indexPath: IndexPath) -> [ContentCollection] {
        return Array(categories[indexPath.section].contentCollections(section: .library))
    }
    
    func contentCollectionType(at indexPath: IndexPath) -> LibraryTableViewCell.CollectionViewCellType {
        return .category
    }
    
    func contentCount(at indexPath: IndexPath) -> Int {
        return categories[indexPath.section].contentCollections(section: .library).count
    }
    
    func heightForRowAt(_ indexPath: IndexPath) -> CGFloat {
        return 313
    }
}
