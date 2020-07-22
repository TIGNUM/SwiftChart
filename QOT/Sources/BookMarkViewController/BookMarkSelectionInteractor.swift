//
//  BookMarkSelectionInteractor.swift
//  QOT
//
//  Created by Sanggeon Park on 20.07.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class BookMarkSelectionInteractor {

    // MARK: - Properties

    private let worker: BookMarkSelectionWorker
    private let presenter: BookMarkSelectionPresenterInterface
    private let router: BookMarkSelectionRouterInterface
    private let contentId: Int
    private let contentType: UserStorageContentType
    var viewModels = [BookMarkSelectionModel]()

    lazy var headerTitle = {
        AppTextService.get(.bookmark_library_selection_normal_header_title)
    }()

    lazy var myLibraryCellTitle = {
        AppTextService.get(.bookmark_library_selection_normal_cell_my_library_title)
    }()

    lazy var myLibraryCellSubtitle = {
        AppTextService.get(.bookmark_library_selection_normal_cell_my_library_subtitle)
    }()

    lazy var memberCountTemplateString = {
        AppTextService.get(.bookmark_library_selection_normal_cell_participiant_count_template)
    }()

    lazy var saveButtonTitle = {
        AppTextService.get(.bookmark_library_selection_normal_save_button_title)
    }()

    // MARK: - Init

    init(contentId: Int,
         contentType: UserStorageContentType,
         worker: BookMarkSelectionWorker,
         presenter: BookMarkSelectionPresenterInterface,
         router: BookMarkSelectionRouterInterface) {
        self.contentId = contentId
        self.contentType = contentType
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor

    func viewDidLoad() {
        worker.viewModels(for: contentType, contentId: contentId) { [weak self] (viewModels) in
            self?.viewModels = viewModels
            self?.presenter.loadData()
        }
    }
}

// MARK: - BookMarkSelectionInteractorInterface

extension BookMarkSelectionInteractor: BookMarkSelectionInteractorInterface {
    func didTapItem(index: Int) {
        guard index < viewModels.count else { return }
        viewModels[index].isSelected = !viewModels[index].isSelected
    }

    func save() {
        worker.update(viewModels: viewModels) { [weak self] (isChanged) in
            self?.router.dismiss(isChanged)
        }
    }

    func dismiss() {
        router.dismiss(false)
    }
}
