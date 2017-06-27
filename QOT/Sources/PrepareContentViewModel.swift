//
//  PrepareContentViewModel.swift
//  QOT
//
//  Created by karmic on 27/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import LoremIpsum

struct PrepareItem {
    var title: String
    var subTitle: String
    var readMoreID: Int?

    init(title: String, subTitle: String, readMoreID: Int?) {
        self.title = title
        self.subTitle = subTitle
        self.readMoreID = readMoreID
    }
}



final class PrepareContentViewModel {

    struct Video {
        let url: URL
        let placeholderURL: URL?
    }
    
    // MARK: - Properties

    //this should be removed when we receive the actual object with the data on viewModel init
    fileprivate var data: [PrepareItem] = []
    
    fileprivate var headerToggleState: [Bool] = []
    let updates = PublishSubject<CollectionUpdate, NoError>()
    
    var title: String = ""
    var subTitle: String = ""
    var contentText: String = ""
    var videoPlaceholder: URL?
    var video: URL?
    
    var items: [PrepareContentItemType] = []

    // MARK: - MockData
    
    func createMockData() {
        
        title = LoremIpsum.title()
        subTitle = LoremIpsum.title()
        contentText = LoremIpsum.words(withNumber: Int.random(between: 30, and: 100))
        videoPlaceholder = URL(string: "http://missionemanuel.org/wp-content/uploads/2015/02/photo-video-start-icon1.png?w=640")
        video = URL(string: "https://www.youtube.com/watch?v=ScMzIvxBSi4")
        
        for _ in 0...Int.random(between: 5, and: 10) {
            
            let newItem = PrepareItem(title: LoremIpsum.title(),
                               subTitle: LoremIpsum.words(withNumber: Int.random(between: 30, and: 100)),
                               readMoreID: Int.randomID)
            
            data.append(newItem)
        }
    }

    // TODO: Implement following methods

    // 1. Implement following init method for prepare list... See: https://zpl.io/Z1pglQ8 & https://zpl.io/ZW59tm & https://zpl.io/ZdIaoX

//    init(title: String, subtitle: String, video: Video?, description: String, items: [PrepareItem]) {
//
//    }

    // 2. Implement following init method for prepare check list. See: https://zpl.io/9yv39
    // 
    // Note that the subtitle is now dyncamic and shows the number of items checked.
    // `checkedIDs` has the id of checked PrepareItems and when they were checked. 

//    init(title: String, video: Video?, description: String, items: [PrepareItem], checkedIDs: [Int: Date]) {
//    
//    }

    // 3. Add id to `PrepareItem` field

    // 4. Use followin to track which items are checked. This dictionary should remain public

    //    var checkedIDs: [Int: Date]

    // 5. Delete the existing init method. Pass in mock data using above init methods

    init() {
        createMockData()
        makeItems()
    }

    // MARK: - Public

    var itemCount: Int {
        return items.count
    }

    func item(at index: Int) -> PrepareContentItemType {
        return items[index]
    }

    func didTapHeader(index: Int) {
        headerToggleState[index] = !headerToggleState[index]
//        updates.next(.reload)
    }
    
    func isCellExpanded(at: Int) -> Bool {
        return headerToggleState[at]
    }
}

// MARK: - Private

private extension PrepareContentViewModel {
    
    func fillHeaderStatus() {
        for _ in 0...items.count {
            headerToggleState.append(false)
        }
    }

    func makeItems() {
        
        items.append(.titleItem(title: title, subTitle: subTitle, contentText: contentText, placeholderURL: videoPlaceholder, videoURL: video))
        
        for element in data {
            items.append(.item(title: element.title, subTitle: element.subTitle, readMoreID: element.readMoreID))
        }

        items.append(.tableFooter(preparationID: 1)) //TODO: we need to set the actual ID
        
        fillHeaderStatus()
    }
}

enum PrepareContentItemType {
    case titleItem(title: String, subTitle: String, contentText: String, placeholderURL: URL?, videoURL: URL?)
    case item(title: String, subTitle: String, readMoreID: Int?)
    case tableFooter(preparationID: Int)
}
