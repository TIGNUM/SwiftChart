//
//  AskPermissionPresenter.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class AskPermissionPresenter {

    // MARK: - Properties
    private weak var viewController: AskPermissionViewControllerInterface?

    // MARK: - Init
    init(viewController: AskPermissionViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - AskPermissionInterface
extension AskPermissionPresenter: AskPermissionPresenterInterface {
    func setupView(_ contentCollection: QDMContentCollection?, type: AskPermission.Kind?) {
        let viewModel = createViewModel(contentCollection, type: type)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.setupView(viewModel)
        }
    }
}

// MARK: - Private
private extension AskPermissionPresenter {
    func createViewModel(_ content: QDMContentCollection?,
                         type: AskPermission.Kind?) -> AskPermission.ViewModel {
        return AskPermission.ViewModel(title: valueText(for: type?.titleTag, content),
                                       description: valueText(for: type?.bodyTag, content),
                                       imageURL: URL(string: content?.thumbnailURLString ?? ""),
                                       buttonTitleCancel: valueText(for: type?.buttonCancelTag, content),
                                       buttonTitleConfirm: valueText(for: type?.buttonConfirmTag, content))
    }

    func valueText(for tag: String?, _ content: QDMContentCollection?) -> String? {
        return content?.contentItems.filter {
            $0.searchTagsDetailed.contains(where: { ($0.name ?? "").lowercased() == tag?.lowercased() }) }.first?.valueText
    }
}
