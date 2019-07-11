//
//  MyLibraryCategoryListWorker.swift
//  QOT
//
//  Created by Sanggeon Park on 06.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyLibraryCategoryListWorker {

    private let service = UserStorageService.main

    func loadData(_ completion: @escaping (_ initiated: Bool, _ categories: [MyLibraryCategoryListModel]?) -> Void) {
        service.getUserStorages { (storages, initiated, error) in
            var userStorages = [MyLibraryCategoryListModel]()
            let sorted = storages?.sorted(by: { (first, second) -> Bool in
                first.modifiedAt?.timeIntervalSince1970 ?? 0 > second.modifiedAt?.timeIntervalSince1970 ?? 0
            })
            let bookmarks = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .BOOKMARK ? storage : nil
            })

            let downloads = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .DOWNLOAD ? storage : nil
            })

            let notes = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .NOTE ? storage : nil
            })

            let links = sorted?.compactMap({ (storage) -> QDMUserStorage? in
                storage.userStorageType == .EXTERNAL_LINK ? storage : nil
            })
            // FIXME: change to localized string

            userStorages.append(self.viewModelWith(title: "ALL", items: sorted, icon: "my_library_group", type: .ALL))
            userStorages.append(self.viewModelWith(title: "Bookmarks", items: bookmarks, icon: "my_library_bookmark", type: .BOOKMARKS))
            userStorages.append(self.viewModelWith(title: "Downloads", items: downloads, icon: "my_library_download", type: .DOWNLOADS))
            userStorages.append(self.viewModelWith(title: "Links", items: links, icon: "my_library_link", type: .LINKS))
            userStorages.append(self.viewModelWith(title: "Notes", items: notes, icon: "my_library_note_light", type: .NOTES))
            completion(initiated, userStorages)
        }
    }

    func viewModelWith(title: String, items: [QDMUserStorage]?, icon: String, type: MyLibraryCategoryType) -> MyLibraryCategoryListModel {
        return MyLibraryCategoryListModel(title: title,
                                          itemCount: items?.count ?? 0,
                                          lastUpdated: items?.first?.modifiedAt,
                                          iconName: icon, type: type)
    }
}
