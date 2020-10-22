//
//  VisionRatingExplanationViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 17.08.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class VisionRatingExplanationViewController: BaseViewController {

    // MARK: - Properties
    var interactor: VisionRatingExplanationInteractorInterface!
    private lazy var router = VisionRatingExplanationRouter(viewController: self)
    @IBOutlet private weak var checkMarkView: UIView!
    @IBOutlet private weak var checkmarkLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    @IBOutlet private weak var playIconBackgroundView: UIView!
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var checkButton: UIButton!
    private var skeletonManager = SkeletonManager()
    private var videoID: Int?
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
        setupButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateBottomNavigation(bottomNavigationLeftBarItems(), bottomNavigationRightBarItems())
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    @IBAction func buttonChecked(_ sender: Any) {
        checkButton.isSelected.toggle()
        checkButton.backgroundColor = checkButton.isSelected ? .accent70 : .clear
        //        TODO option to send notification to all members
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem] {
        return [roundedBarButtonItem(title: rightBarButtonTitle,
                                     buttonWidth: .Save,
                                     action: rightBarButtonAction,
                                     backgroundColor: .clear,
                                     borderColor: .accent40)]
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem] {
        let blackButton = dismissNavigationItemBlack(action: #selector(didTapDismissButton))
        return [blackButton]
    }
}

// MARK: - Actions
extension VisionRatingExplanationViewController {
    @objc func startRating() {
        trackUserEvent(.OPEN, value: interactor.team.remoteID, valueType: .TEAM_TO_BE_VISION_RATING, action: .TAP)
        interactor.startTeamTrackerPoll { [weak self] (poll, team) in
            self?.router.showRateScreen(trackerPoll: poll, team: team, delegate: self)
            self?.updateBottomNavigation([], [])
        }
    }

    @objc func startTeamTBVGenerator() {
        let team = interactor.team
        trackUserEvent(.OPEN, value: interactor.team.remoteID, valueType: .TEAM_TBV_GENERATOR, action: .TAP)
        interactor.startTeamTBVPoll { [weak self] (poll) in
            self?.router.showTeamTBVGenerator(poll: poll, team: team)
            self?.updateBottomNavigation([], [])
        }
    }

    @objc func videoTapped(_ sender: UITapGestureRecognizer) {
        if let launchURL = URLScheme.contentItem.launchURLWithParameterValue(String(videoID ?? 0)) {
            UIApplication.shared.open(launchURL, options: [:], completionHandler: nil)
        }
    }

    func setupButtons() {
        checkButton.layer.borderWidth = 1
        checkButton.layer.borderColor = UIColor.accent.cgColor
        checkButton.corner(radius: 2)
    }
}

// MARK: - VisionRatingExplanationViewControllerInterface
extension VisionRatingExplanationViewController: VisionRatingExplanationViewControllerInterface {
    func setupView(type: Explanation.Types) {
        playIconBackgroundView.circle()
        ThemeText.ratingExplanationText.apply(AppTextService.get(.my_x_team_tbv_section_feature_explanation_checkmark),
                                              to: checkmarkLabel)
        updateBottomNavigation(bottomNavigationLeftBarItems(), bottomNavigationRightBarItems())
        switch type {
        case .ratingOwner, .tbvPollOwner:
            checkMarkView.isHidden = false
        default:
            checkMarkView.isHidden = true
        }
    }

    func setupLabels(title: String, text: String, videoTitle: String) {
        ThemeText.ratingExplanationTitle.apply(title.uppercased(), to: titleLabel)
        let adaptedText = text.replacingOccurrences(of: "${TEAM_NAME}", with: (interactor.team.name ?? "").uppercased())
        ThemeText.ratingExplanationText.apply(adaptedText, to: textLabel)
        ThemeText.ratingExplanationVideoTitle.apply(videoTitle, to: videoTitleLabel)

    }

    func setupVideo(thumbNailURL: URL?, placeholder: UIImage?, videoURL: URL?, duration: String, remoteID: Int) {
        videoView.isHidden = videoURL == nil
        self.videoID = remoteID
        videoImageView.setImage(url: thumbNailURL, skeletonManager: skeletonManager) { (_) in /* */}
        videoDescriptionLabel.text = duration
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(self.videoTapped(_:)))
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(videoTap)
    }

    func setupRightBarButtonItem(title: String, type: Explanation.Types) {
        rightBarButtonTitle = title
        switch type {
        case .ratingUser,
             .ratingOwner: rightBarButtonAction = #selector(startRating)
        case .tbvPollOwner,
             .tbvPollUser: rightBarButtonAction = #selector(startTeamTBVGenerator)
        }
    }
}

extension VisionRatingExplanationViewController: TBVRateDelegate {
    func doneAction() {

    }
}
