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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem] {
        guard let isTeamOwner = interactor.team?.thisUserIsOwner else { return [] }
        let title = isTeamOwner ? AppTextService.get(.my_x_team_tbv_section_rating_explanation_right_button) : AppTextService.get(.my_x_team_tbv_section_rating_explanation_right_button_member)

        return [roundedBarButtonItem(title: title,
                                     buttonWidth: 160,
                                     action: #selector(startRating),
                                     backgroundColor: .black,
                                     borderColor: .accent40)]
    }

    @objc func startRating() {
        trackUserEvent(.OPEN, value: interactor.team?.remoteID, valueType: .START_RATING, action: .TAP)
//        TODO  Start rating
    }
}

// MARK: - VisionRatingExplanationViewControllerInterface
extension VisionRatingExplanationViewController: VisionRatingExplanationViewControllerInterface {
    func setupView() {
        guard let isTeamOwner = interactor.team?.thisUserIsOwner else { return }
        playIconBackgroundView.corner(radius: playIconBackgroundView.bounds.size.width/2)
        ThemeText.ratingExplanationTitle.apply(AppTextService.get(isTeamOwner ? .my_x_team_tbv_section_rating_explanation_title : .my_x_team_tbv_section_rating_explanation_member_title), to: titleLabel)
        let ownerText = AppTextService.get(.my_x_team_tbv_section_rating_explanation_text)
        let memberText = AppTextService.get(.my_x_team_tbv_section_rating_explanation_member_text).replacingOccurrences(of: "${TEAM_NAME}", with: interactor.team?.name?.uppercased() ?? "")
        ThemeText.ratingExplanationText.apply(isTeamOwner ? ownerText : memberText, to: textLabel)
        ThemeText.ratingExplanationVideoTitle.apply(AppTextService.get(.my_x_team_tbv_section_rating_explanation_video_title), to: videoTitleLabel)
        updateBottomNavigation([createBlackCloseButton(#selector(didTapBackButton))], bottomNavigationRightBarItems())
    }
}

extension VisionRatingExplanationViewController: MyToBeVisionRateViewControllerProtocol {
    func doneAction() {
//       show tracker results
    }
}
