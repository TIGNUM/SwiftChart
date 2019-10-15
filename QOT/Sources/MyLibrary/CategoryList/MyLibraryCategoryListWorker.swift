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

    lazy var titleText: String = {
        return AppTextService.get(AppTextKey.my_qot_view_title_my_library)
    }()

    func loadData(_ completion: @escaping (_ initiated: Bool, _ categories: [MyLibraryCategoryListModel]?) -> Void) {
        service.getUserStorages { [weak self] (storages, initiated, error) in
            guard let strongSelf = self else {
                return
            }
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

            userStorages.append(strongSelf.viewModelWith(title: AppTextService.get(AppTextKey.my_qot_my_library_view_title_all),
                                                         items: sorted,
                                                         icon: R.image.my_library_group(),
                                                         type: .ALL))
            userStorages.append(strongSelf.viewModelWith(title: AppTextService.get(AppTextKey.my_qot_my_library_view_title_bookmarks),
                                                         items: bookmarks,
                                                         icon: R.image.my_library_bookmark(),
                                                         type: .BOOKMARKS))
            userStorages.append(strongSelf.viewModelWith(title: AppTextService.get(AppTextKey.my_qot_my_library_view_title_downloads),
                                                         items: downloads,
                                                         icon: R.image.my_library_download(),
                                                         type: .DOWNLOADS))
            userStorages.append(strongSelf.viewModelWith(title: AppTextService.get(AppTextKey.my_qot_my_library_view_title_links),
                                                         items: links,
                                                         icon: R.image.my_library_link(),
                                                         type: .LINKS))
            userStorages.append(strongSelf.viewModelWith(title: AppTextService.get(AppTextKey.my_qot_my_library_view_title_notes),
                                                         items: notes,
                                                         icon: R.image.my_library_note_light(),
                                                         type: .NOTES))
            completion(initiated, userStorages)
        }
    }

    func viewModelWith(title: String, items: [QDMUserStorage]?, icon: UIImage?, type: MyLibraryCategoryType) -> MyLibraryCategoryListModel {
        return MyLibraryCategoryListModel(title: title,
                                          itemCount: items?.count ?? 0,
                                          lastUpdated: items?.first?.modifiedAt,
                                          icon: icon,
                                          type: type)
    }
}
