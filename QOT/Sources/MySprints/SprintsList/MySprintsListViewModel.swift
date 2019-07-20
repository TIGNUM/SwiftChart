//
//  MySprintsListViewModel.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 18/07/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MySprintsListViewModel {

    var isEditing: Bool = false
    var shouldShowEditButton: Bool = false
    var canEdit: Bool = false
    var infoViewModel: MyLibraryUserStorageInfoViewModel? = nil
    var bottomButtons: [ButtonParameters]? = nil

    var displayData = [MySprintsListDataViewModel]()

    func item(at indexPath: IndexPath) -> MySprintsListSprintModel? {
        guard indexPath.section < displayData.count, indexPath.row < displayData[indexPath.section].items.count else {
            return nil
        }
        return displayData[indexPath.section].items[indexPath.row]
    }
}
