//
//  Level5Cell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 01.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class Level5Cell: BaseDailyBriefCell {

    @IBOutlet weak var headerView: UIView!
    private weak var baseHeaderView: QOTBaseHeaderView?
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var buttons: [AnimatedButton]!
    @IBOutlet private weak var levelTitle: UILabel!
    @IBOutlet private weak var levelText: UILabel!
    @IBOutlet weak var level1Button: AnimatedButton!
    @IBOutlet weak var level2Button: AnimatedButton!
    @IBOutlet weak var level3Button: AnimatedButton!
    @IBOutlet weak var level4Button: AnimatedButton!
    @IBOutlet weak var level5Button: AnimatedButton!
    @IBOutlet weak var knowledgeProgress: UIProgressView!
    @IBOutlet weak var saveButton: RoundedButton!
    @IBOutlet weak var readinessProgress: UIProgressView!
    @IBOutlet weak var awarenssProgress: UIProgressView!
    @IBOutlet weak var masteryProgress: UIProgressView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet private weak var knowledgeLabel: UILabel!
    @IBOutlet private weak var awarenessLabel: UILabel!
    @IBOutlet private weak var readinessLabel: UILabel!
    @IBOutlet private weak var masteryLabel: UILabel!

    var levelMessages: [Level5ViewModel.LevelDetail] = []
    weak var delegate: DailyBriefViewControllerDelegate?
    var savedAnswer: Int?
    var tmpAnswer: Int = 0
    var confirmationMessage: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        baseHeaderView = R.nib.qotBaseHeaderView.firstView(owner: self)
        baseHeaderView?.addTo(superview: headerView, showSkeleton: true)
        skeletonManager.addSubtitle(questionLabel)
        skeletonManager.addSubtitle(levelTitle)
        skeletonManager.addSubtitle(levelText)
        for button in buttons {
            skeletonManager.addOtherView(button)
        }
        skeletonManager.addOtherView(saveButton)
        skeletonManager.addOtherView(progressStackView)
        setUpButtons()
    }

    @IBAction func save(_ sender: UIButton) {
        saveButton.setTitle("Saved", for: .normal)
        saveButton.layer.borderWidth = 0
        saveButton.isEnabled = false
        ThemeView.selectedButton.apply(saveButton)
        savedAnswer = tmpAnswer
        delegate?.saveAnswerValue(tmpAnswer + 1, from: self)
        delegate?.showAlert(message: confirmationMessage)
        updateUI(levelMessages.at(index: tmpAnswer)?.levelContent)
    }

    func configure(with model: Level5ViewModel?) {
        skeletonManager.hide()
        baseHeaderView?.configure(title: model?.title, subtitle: model?.intro)
        knowledgeLabel.text = AppTextService.get(.daily_brief_section_level_5_label_knowledge)
        awarenessLabel.text = AppTextService.get(.daily_brief_section_level_5_label_awareness)
        readinessLabel.text = AppTextService.get(.daily_brief_section_level_5_label_readiness)
        masteryLabel.text = AppTextService.get(.daily_brief_section_level_5_label_mastery)
        ThemeText.dailyBriefTitle.apply(model?.title, to: baseHeaderView?.titleLabel)
        ThemeText.dailyBriefSubtitle.apply(model?.intro, to: baseHeaderView?.subtitleTextView)
        ThemeText.level5Question.apply(model?.question, to: questionLabel)
        confirmationMessage = model?.confirmationMessage
        levelMessages = model?.levelMessages ?? []
        savedAnswer = nil
        if let selectedValue = model?.domainModel?.latestGetToLevel5Value {
            tmpAnswer = max(selectedValue - 1, 0)
        }
        if let currentAnswer = model?.domainModel?.currentGetToLevel5Value {
            savedAnswer = max(currentAnswer - 1, 0)
            tmpAnswer = max(currentAnswer - 1, 0)
        }
        updateButtonStatus()
        initialSetup()
    }

    func updateUI(_ questionContent: String?) {
        ThemeText.dailyBriefLevelContent.apply(questionContent, to: levelText)
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
            self.levelText.layoutIfNeeded()
        }
    }

    //    when the bucket is loaded set level 1 as default
    func initialSetup() {
        ThemeText.dailyBriefLevelTitle.apply(levelMessages.at(index: tmpAnswer)?.levelTitle, to: levelTitle)
        updateUI(levelMessages.at(index: tmpAnswer)?.levelContent)
        setButtonBackgroundColor()
        setProgress()
    }

    func setUpButtons() {
        ThemeBorder.accent.apply(saveButton)
    }

    func setButtonBackgroundColor() {
        buttons.forEach {(button) in
            ThemeButton.dailyBriefButtons.apply(button, selected: tmpAnswer == button.tag)
        }
    }

    func setButtonText(_ buttonText: String?) {
        ThemableButton.level5.apply(saveButton, title: buttonText)
        ThemeView.level1.apply(saveButton)
    }

    @IBAction func didPressLevel(_ sender: UIButton) {
        tmpAnswer = sender.tag
        updateButtonStatus()
        initialSetup()
        delegate?.didUpdateLevel5()
    }

    func updateButtonStatus() {

        if tmpAnswer == savedAnswer {
            setButtonText(AppTextService.get(.daily_brief_section_level_5_button_saved))
            ThemeButton.dailyBriefButtons.apply(saveButton, selected: true)
            saveButton.isEnabled = false
        } else {
            setButtonText(AppTextService.get(.daily_brief_section_level_5_button_save))
            ThemeButton.dailyBriefButtons.apply(saveButton, selected: false)
            saveButton.isEnabled = true
        }
    }

    func setProgress() {
        let array: [[Float]] = [[0.2, 0.0, 0.0, 0.0],
                                [0.40, 0.25, 0.0, 0.0],
                                [0.60, 0.50, 0.33, 0.0],
                                [0.80, 0.75, 0.66, 0.50],
                                [1.0, 1.0, 1.0, 1.0]]
        let item = array[tmpAnswer]
        knowledgeProgress.setProgress(item[0], animated: true)
        readinessProgress.setProgress(item[1], animated: true)
        awarenssProgress.setProgress(item[2], animated: true)
        masteryProgress.setProgress(item[3], animated: true)

    }
}
