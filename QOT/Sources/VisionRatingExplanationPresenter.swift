//
//  VisionRatingExplanationPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class VisionRatingExplanationPresenter {

    // MARK: - Properties
    private weak var viewController: VisionRatingExplanationViewControllerInterface?

    // MARK: - Init
    init(viewController: VisionRatingExplanationViewControllerInterface?) {
        self.viewController = viewController
    }
}

// MARK: - VisionRatingExplanationInterface
extension VisionRatingExplanationPresenter: VisionRatingExplanationPresenterInterface {
    func setupView(type: Explanation.Types, videoItem: QDMContentItem?) {
        viewController?.setupRightBarButtonItem(title: AppTextService.get(.button_title_start), type: type)
        viewController?.setupLabels(title: type.title,
                                    text: type.text,
                                    videoTitle: type.videoTitle)
        viewController?.setupVideo(thumbNailURL: URL(string: videoItem?.valueImageURL ?? ""),
                                   placeholder: R.image.preloading(),
                                   videoURL: URL(string: videoItem?.valueMediaURL ?? ""),
                                   duration: videoItem?.durationString ?? "",
                                   remoteID: videoItem?.remoteID ?? .zero)
        viewController?.setupView(type: type)
    }
}
