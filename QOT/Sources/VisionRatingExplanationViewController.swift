//
//  VisionRatingExplanationViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class VisionRatingExplanationViewController: UIViewController {

    // MARK: - Properties
    var interactor: VisionRatingExplanationInteractorInterface!
    private lazy var router: VisionRatingExplanationRouterInterface = VisionRatingExplanationRouter(viewController: self)
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    @IBOutlet private weak var playIconBackgroundView: UIView!

    // MARK: - Init
    init(configure: Configurator<VisionRatingExplanationViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }
}

// MARK: - Private
private extension VisionRatingExplanationViewController {

}

// MARK: - Actions
private extension VisionRatingExplanationViewController {

}

// MARK: - VisionRatingExplanationViewControllerInterface
extension VisionRatingExplanationViewController: VisionRatingExplanationViewControllerInterface {
    func setupView() {
        playIconBackgroundView.corner(radius: playIconBackgroundView.bounds.size.width/2)
        ThemeText.ratingExplanationTitle.apply(AppTextService.get(.my_x_team_tbv_section_rating_explanation_title), to: titleLabel)
        ThemeText.ratingExplanationText.apply(AppTextService.get(.my_x_team_tbv_section_rating_explanation_text), to: textLabel)
        ThemeText.ratingExplanationVideoTitle.apply(AppTextService.get(.my_x_team_tbv_section_rating_explanation_video_title), to: videoTitleLabel)
    }
}
