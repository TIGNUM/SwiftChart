//
//  ImpactReadiness1.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal
import HealthKit

final class ImpactReadiness1: BaseDailyBriefCell {

    private var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var toBeVisionImage: UIImageView!
    @IBOutlet private weak var impactReadinessScore: UILabel!
    @IBOutlet private weak var impactReadinessOutOf100Label: UILabel!
    @IBOutlet private weak var content: UILabel!
    @IBOutlet private weak var impactReadinessButton: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var score: Int = 0
    @IBOutlet private weak var impactReadinessView: UIImageView!
    @IBOutlet private weak var buttonLeft: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var buttonRight: UIButton!
    typealias actionClosure = (() -> Void)
    private var actionLeft: actionClosure? = nil
    private var actionRight: actionClosure? = nil
    var trackState: Bool = false
    private var showDailyCheckInScreen = false
    @IBOutlet private weak var exploreScoreButton: AnimatedButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        toBeVisionImage.gradientBackground(top: true)
        toBeVisionImage.gradientBackground(top: false)
        skeletonManager.addSubtitle(impactReadinessScore)
        skeletonManager.addSubtitle(impactReadinessOutOf100Label)
        skeletonManager.addSubtitle(content)
        skeletonManager.addOtherView(toBeVisionImage)
        skeletonManager.addOtherView(impactReadinessButton)
        skeletonManager.addOtherView(exploreScoreButton)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        baseHeaderView?.titleLabel.isHidden = true
        exploreScoreButton.isHidden = true
        impactReadinessButton.isHidden = true
    }

    @IBAction func exploreScoreButton(_ sender: Any) {
        trackState = !trackState
        exploreScoreButton.flipImage(trackState)
        NotificationCenter.default.post(name: .dispayDailyCheckInScore, object: nil)
       }

    @IBAction func impactReadinessButton(_ sender: Any) {
        if let launchURL = URLScheme.dailyCheckIn.launchURLWithParameterValue("") {
            AppDelegate.current.launchHandler.process(url: launchURL)
        }
    }

    @objc func didTapLeft() {
        actionLeft?()
    }

    @objc func didTapRight() {
        actionRight?()
    }

    func configure(viewModel: ImpactReadinessCellViewModel?, tapLeft: actionClosure?, tapRight: actionClosure?) {
        guard let model = viewModel else { return }
        baseHeaderView?.titleLabel.isHidden = false

        skeletonManager.hide()
        showDailyCheckInScreen = (model.domainModel?.dailyCheckInAnswerIds?.isEmpty != false &&
                                  model.domainModel?.dailyCheckInResult == nil)
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: nil)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefSubtitle.apply(model.readinessIntro, to: content)
        let score: Int = model.readinessScore ?? 0
        if score == -1 {
            ThemeText.readinessScore.apply(" - ", to: impactReadinessScore)
        } else {
            ThemeText.readinessScore.apply(String(score), to: impactReadinessScore)
        }
        toBeVisionImage.setImage(url: model.dailyCheckImageURL, placeholder: R.image.tbvPlaceholder()) { (_) in /* */}
        self.score = model.readinessScore ?? 0
        ThemeView.level1.apply(self)
        ThemeText.navigationBarHeader.apply(AppTextService.get(.daily_brief_section_header_title), to: titleLabel)
        buttonLeft.isHidden = tapLeft == nil
        buttonRight.isHidden = tapRight == nil
        exploreScoreButton.isHidden = true
        impactReadinessButton.isHidden = true
        actionLeft = tapLeft
        actionRight = tapRight
        buttonLeft.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        buttonRight.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
        impactReadinessOutOf100Label.text = AppTextService.get(.daily_brief_section_impact_readiness_label_out_of_100)
        exploreScoreButton.isEnabled = viewModel?.enableButton ?? true

        if showDailyCheckInScreen {
            impactReadinessButton.isHidden = false
            impactReadinessButton.setTitle(AppTextService.get(.daily_brief_section_impact_readiness_null_state_button_start_dci), for: .normal)
            impactReadinessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
            ThemeButton.dailyBriefButtons.apply(impactReadinessButton)
        } else {
            trackState = model.isExpanded
            exploreScoreButton.setTitle(AppTextService.get(.daily_brief_section_impact_readiness_button_explore_score), for: .normal)
            exploreScoreButton.isHidden = false
            ThemeButton.dailyBriefWithoutBorder.apply(exploreScoreButton)
            exploreScoreButton.flipImage(trackState)
            exploreScoreButton.setTitle(AppTextService.get(.daily_brief_section_impact_readiness_button_explore_score), for: .normal)
            exploreScoreButton.setInsets(forContentPadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), imageTitlePadding: 10.0)
            exploreScoreButton.setImage(UIImage(named: "arrowUp.png"), for: .normal)
        }
    }
}

extension UIButton {
    func setInsets( forContentPadding contentPadding: UIEdgeInsets, imageTitlePadding: CGFloat) {
        self.contentEdgeInsets = UIEdgeInsets(
            top: contentPadding.top,
            left: contentPadding.left + imageTitlePadding,
            bottom: contentPadding.bottom,
            right: contentPadding.right
        )
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitlePadding, bottom: 0, right: imageTitlePadding)
    }
}
