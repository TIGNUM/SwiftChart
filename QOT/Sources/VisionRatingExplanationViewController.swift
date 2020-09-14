//
//  VisionRatingExplanationViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

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
    private var rightBarButtonTitle = ""
    private var rightBarButtonAction = #selector(startRating)

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
        return [roundedBarButtonItem(title: rightBarButtonTitle,
                                     buttonWidth: .Default,
                                     action: rightBarButtonAction,
                                     backgroundColor: .carbon,
                                     borderColor: .accent40)]
    }
}

// MARK: - Actions
extension VisionRatingExplanationViewController {
    @objc func startRating() {
        trackUserEvent(.OPEN, value: interactor.team?.remoteID, valueType: .TEAM_TO_BE_VISION_RATING, action: .TAP)
        router.showRateScreen(with: 0)
    }

    @objc func startTBVGenerator() {
        trackUserEvent(.OPEN, value: interactor.team?.remoteID, valueType: .TEAM_TBV_GENERATOR, action: .TAP)
    }
}

// MARK: - VisionRatingExplanationViewControllerInterface
extension VisionRatingExplanationViewController: VisionRatingExplanationViewControllerInterface {
    func setupView() {
        playIconBackgroundView.circle()
        updateBottomNavigation([createBlackCloseButton(#selector(didTapBackButton))], bottomNavigationRightBarItems())
    }

    func setupLabels(title: String, text: String, videoTitle: String) {
        ThemeText.ratingExplanationTitle.apply(title, to: titleLabel)
        ThemeText.ratingExplanationText.apply(text, to: textLabel)
        ThemeText.ratingExplanationVideoTitle.apply(videoTitle, to: videoTitleLabel)
    }

    func setupVideo(thumbNailURL: URL?, placeholder: UIImage?, videoURL: URL?, duration: String) {

    }

    func setupRightBarButtonItem(title: String, type: Explanation.Types) {
        rightBarButtonTitle = title
        switch type {
        case .ratingUser, .ratingOwner: rightBarButtonAction = #selector(startRating)
        case .tbvPollOwner, .tbvPollUser: rightBarButtonAction = #selector(startTBVGenerator)
        }
    }
}

extension VisionRatingExplanationViewController: MyToBeVisionRateViewControllerProtocol {
    func doneAction() {

    }
}
