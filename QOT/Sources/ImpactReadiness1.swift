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

    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var toBeVisionImage: UIImageView!
    @IBOutlet private weak var impactReadinessScore: UILabel!
    @IBOutlet private weak var impactReadinessOutOf100Label: UILabel!
    @IBOutlet private weak var content: UILabel!
    @IBOutlet weak var intro: UILabel!
    @IBOutlet private weak var impactReadinessButton: AnimatedButton!
    @IBOutlet private weak var impactReadinessView: UIImageView!
    @IBOutlet private weak var buttonLeft: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var buttonRight: UIButton!
    typealias ActionClosure = (() -> Void)
    weak var delegate: DailyBriefViewControllerDelegate?
    private weak var baseHeaderView: QOTBaseHeaderView?
    private var score: Int = 0
    private var actionLeft: ActionClosure?
    private var actionRight: ActionClosure?
    private var showDailyCheckInScreen = false
    private var feedbackRelatedLink: QDMAppLink?

    override func awakeFromNib() {
        super.awakeFromNib()
        toBeVisionImage.gradientBackground(top: true)
        toBeVisionImage.gradientBackground(top: false)
        skeletonManager.addSubtitle(impactReadinessScore)
        skeletonManager.addSubtitle(impactReadinessOutOf100Label)
        skeletonManager.addSubtitle(content)
        skeletonManager.addOtherView(toBeVisionImage)
        skeletonManager.addOtherView(impactReadinessButton)
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        baseHeaderView?.titleLabel.isHidden = true
    }

    @IBAction func impactReadinessButton(_ sender: Any) {
        if let link = feedbackRelatedLink {
            trackUserEvent(.OPEN, value: link.appLinkId, stringValue: "DAILY_CHECK_IN_1", valueType: "APP_LINK", action: .TAP)
            link.launch()
        } else if let launchURL = URLScheme.dailyCheckIn.launchURLWithParameterValue("") {
            AppDelegate.current.launchHandler.process(url: launchURL)
        }
    }

    @objc func didTapLeft() {
        actionLeft?()
    }

    @objc func didTapRight() {
        actionRight?()
    }

    func configure(viewModel: ImpactReadinessCellViewModel?, tapLeft: ActionClosure?, tapRight: ActionClosure?) {
        guard let model = viewModel else { return }
        baseHeaderView?.titleLabel.isHidden = false
        skeletonManager.hide()
        showDailyCheckInScreen = (model.domainModel?.dailyCheckInAnswerIds?.isEmpty != false &&
                                  model.domainModel?.dailyCheckInResult == nil)
        baseHeaderView?.configure(title: (model.title ?? "").uppercased(), subtitle: nil)
        baseHeaderView?.subtitleTextViewBottomConstraint.constant = 0
        ThemeText.dailyBriefSubtitle.apply(model.readinessIntro, to: intro)
        ThemeText.dailyBriefSand.apply(model.feedback, to: content)
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
        impactReadinessButton.isHidden = true
        actionLeft = tapLeft
        actionRight = tapRight
        buttonLeft.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        buttonRight.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
        impactReadinessOutOf100Label.text = AppTextService.get(.daily_brief_section_impact_readiness_label_out_of_100)
        ThemeButton.dailyBriefButtons.apply(impactReadinessButton)
        self.feedbackRelatedLink = model.feedbackRelatedLink
        if showDailyCheckInScreen {
            impactReadinessButton.isHidden = false
            impactReadinessButton.setTitle(AppTextService.get(.daily_brief_section_impact_readiness_null_state_button_start_dci), for: .normal)
            impactReadinessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
            impactReadinessButton.setButtonContentInset(padding: 16)
        } else if let linkCTA = model.linkCTA {
            impactReadinessButton.isHidden = false
            impactReadinessButton.setTitle(linkCTA, for: .normal)
            impactReadinessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent40)
            impactReadinessButton.setButtonContentInset(padding: 16)
        }
    }
}
