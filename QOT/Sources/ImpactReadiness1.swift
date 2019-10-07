//
//  ImpactReadiness1.swift
//  QOT
//
//  Created by Srikanth Roopa on 26.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class ImpactReadiness1: BaseDailyBriefCell {

    @IBOutlet weak var toBeVisionImage: UIImageView!
    @IBOutlet weak var bucketTitle: UILabel!
    @IBOutlet weak var impactReadinessScore: UILabel!
    @IBOutlet weak var impactReadinessOutOf100Label: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var impactReadinessButton: AnimatedButton!
    weak var delegate: DailyBriefViewControllerDelegate?
    private var score: Int = 0
    @IBOutlet weak var impactReadinessView: UIImageView!
    @IBOutlet weak var buttonLeft: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonRight: UIButton!
    typealias actionClosure = (() -> Void)
    private var actionLeft: actionClosure? = nil
    private var actionRight: actionClosure? = nil
    var trackState: Bool = false
    var showDailyCheckInScreen = false

    override func awakeFromNib() {
        super.awakeFromNib()
        impactReadinessButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        toBeVisionImage.gradientBackground(top: true)
        toBeVisionImage.gradientBackground(top: false)
        skeletonManager.addSubtitle(impactReadinessScore)
        skeletonManager.addSubtitle(impactReadinessOutOf100Label)
        skeletonManager.addSubtitle(content)
        skeletonManager.addOtherView(toBeVisionImage)
        skeletonManager.addOtherView(impactReadinessButton)
        bucketTitle.isHidden = true
    }

    @IBAction func impactReadinessButton(_ sender: Any) {
        // tell someone it's selected. -1 indicates the default condition.
        if showDailyCheckInScreen {
            delegate?.showDailyCheckInQuestions()
        } else {
            trackState = !trackState
            impactReadinessButton.flipImage(trackState)
            NotificationCenter.default.post(name: .dispayDailyCheckInScore, object: nil)
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
        bucketTitle.isHidden = false

        skeletonManager.hide()
        showDailyCheckInScreen = (model.domainModel?.dailyCheckInAnswerIds?.isEmpty != false &&
                                  model.domainModel?.dailyCheckInResult == nil)
        ThemeText.dailyBriefTitle.apply((model.title ?? "").uppercased(), to: bucketTitle)
        ThemeText.dailyBriefSubtitle.apply(model.readinessIntro, to: content)
        let score: Int = model.readinessScore ?? 0
        if score == -1 {
            ThemeText.readinessScore.apply(" - ", to: impactReadinessScore)
        } else {
            ThemeText.readinessScore.apply(String(score), to: impactReadinessScore)
        }
        toBeVisionImage.setImage(url: model.dailyCheckImageURL, placeholder: R.image.tbvPlaceholder())
        self.score = model.readinessScore ?? 0
        ThemeView.level1.apply(self)
        ThemeText.navigationBarHeader.apply(R.string.localized.dailyBriefTitle(), to: titleLabel)
        buttonLeft.isHidden = tapLeft == nil
        buttonRight.isHidden = tapRight == nil
        actionLeft = tapLeft
        actionRight = tapRight
        buttonLeft.addTarget(self, action: #selector(didTapLeft), for: .touchUpInside)
        buttonRight.addTarget(self, action: #selector(didTapRight), for: .touchUpInside)
        if showDailyCheckInScreen {
            impactReadinessButton.setTitle(R.string.localized.impactReadinessCellButtonGetStarted(), for: .normal)
        } else {
            impactReadinessButton.setTitle(R.string.localized.impactReadinessCellButtonExplore(), for: .normal)
            impactReadinessButton.setImage(UIImage(named: "arrowDown.png"), for: .normal)
            impactReadinessButton.setInsets(forContentPadding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), imageTitlePadding: 10.0)
            impactReadinessButton.layoutIfNeeded()
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
