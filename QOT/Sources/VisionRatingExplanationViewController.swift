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
    @IBOutlet private weak var checkMarkView: UIView!
    @IBOutlet private weak var checkmarkLabel: UILabel!
    private lazy var router: VisionRatingExplanationRouterInterface = VisionRatingExplanationRouter(viewController: self)
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var videoView: UIView!
    @IBOutlet private weak var videoTitleLabel: UILabel!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    @IBOutlet private weak var playIconBackgroundView: UIView!
    @IBOutlet private weak var videoImageView: UIImageView!
    private var videoID: Int?
    private var rightBarButtonTitle = ""
    private var rightBarButtonAction = #selector(startRating)
    @IBOutlet weak var checkButton: UIButton!
    let skeletonManager = SkeletonManager()

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
        skeletonManager.addOtherView(videoView)
        skeletonManager.addOtherView(checkMarkView)
        skeletonManager.addOtherView(checkButton)
        skeletonManager.addSubtitle(textLabel)
        skeletonManager.addSubtitle(titleLabel)
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
                                     buttonWidth: .Cancel,
                                     action: rightBarButtonAction,
                                     backgroundColor: .clear,
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
        ThemeText.ratingExplanationText.apply(AppTextService.get(.my_x_team_tbv_section_feature_explanation_checkmark), to: checkmarkLabel)
        updateBottomNavigation([createBlackCloseButton(#selector(didTapBackButton))], bottomNavigationRightBarItems())
        switch type {
        case .ratingOwner, .tbvPollOwner:
            checkMarkView.isHidden = false
        default:
            checkMarkView.isHidden = true
        }
        skeletonManager.hide()
    }

    func setupLabels(title: String, text: String, videoTitle: String) {
        ThemeText.ratingExplanationTitle.apply(title.uppercased(), to: titleLabel)
        let adaptedText = text.replacingOccurrences(of: "${TEAM_NAME}", with: (interactor.team?.name ?? "").uppercased())
        ThemeText.ratingExplanationText.apply(adaptedText, to: textLabel)
        ThemeText.ratingExplanationVideoTitle.apply(videoTitle, to: videoTitleLabel)

    }

    func setupVideo(thumbNailURL: URL?, placeholder: UIImage?, videoURL: URL?, duration: String, remoteID: Int) {
        if videoURL == nil {
            videoView.isHidden = true
        }
        self.videoID = remoteID
        videoImageView.setImage(url: thumbNailURL, skeletonManager: self.skeletonManager) { (_) in /* */}
        videoDescriptionLabel.text = duration
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(self.videoTapped(_:)))
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(videoTap)
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
