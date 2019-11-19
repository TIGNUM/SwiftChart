//
//  MyLibraryUserStorageInterface.swift
//  QOT
//
//  Created by Sanggeon Park on 12.06.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

protocol MyLibraryUserStorageViewControllerInterface: UIViewController {
    func setupView()
    func update()
    func reloadData()
    func deleteRow(at indexPath: IndexPath)
    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem])
}

protocol MyLibraryUserStoragePresenterInterface {
    func setupView()
    func present()
    func presentData()
    func deleteRow(at index: Int)
    func presentAlert(title: String, message: String, buttons: [UIBarButtonItem])
    func presentNoInternetAlert()
}

protocol MyLibraryUserStorageInteractorInterface: Interactor {
    var title: String { get }
    var addTitle: String { get }
    var showAddButton: Bool { get }
    var showEditButton: Bool { get }
    var canEdit: Bool { get }
    var isEditing: Bool { get }
    var infoViewModel: MyLibraryUserStorageInfoViewModel? { get }
    var bottomButtons: [ButtonParameters]? { get }
    var itemType: MyLibraryCategoryType { get }

    var items: [MyLibraryCellViewModel]? { get }
    func didTapEdit(isEditing: Bool)
    func didTapPlayItem(at row: Int)
    func didTapAddNote()
    func handleSelectedItem(at index: Int) -> Bool
}

protocol MyLibraryUserStorageRouterInterface {
    func presentArticle(id: Int)
    func presentVideo(url: URL, item: QDMContentItem?)
    func presentExternalUrl(_ url: URL)
    func presentCreateNote(noteId: String?)
}
