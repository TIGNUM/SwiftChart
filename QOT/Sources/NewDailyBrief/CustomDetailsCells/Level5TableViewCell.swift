//
//  Level5TableViewCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 23.11.2020.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

class Level5TableViewCell: BaseDailyBriefCell {
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var buttons: [AnimatedButton]!
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
    weak var delegate: BaseDailyBriefDetailsViewControllerInterface?
    var savedAnswer: Int?
    var tmpAnswer: Int = 0
    var confirmationMessage: String?
    var model: Level5ViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButtons()
    }

    @IBAction func save(_ sender: UIButton) {
        setButtonText(AppTextService.get(.daily_brief_section_level_5_button_saved).uppercased())
        ThemeButton.whiteRounded.apply(saveButton, selected: false)
        saveButton.isEnabled = false
        savedAnswer = tmpAnswer
        delegate?.saveAnswerValue(tmpAnswer, from: self)
        delegate?.showAlert(message: confirmationMessage)
        updateUI(levelMessages.at(index: tmpAnswer)?.levelContent)
    }

    func configure(with model: Level5ViewModel?) {
        self.model = model
        knowledgeLabel.text = AppTextService.get(.daily_brief_section_level_5_label_knowledge)
        awarenessLabel.text = AppTextService.get(.daily_brief_section_level_5_label_awareness)
        readinessLabel.text = AppTextService.get(.daily_brief_section_level_5_label_readiness)
        masteryLabel.text = AppTextService.get(.daily_brief_section_level_5_label_mastery)
        ThemeText.level5Question.apply(model?.question, to: questionLabel)
        confirmationMessage = model?.confirmationMessage
        if let intro = model?.intro,
           let messages = model?.levelMessages,
           let question = model?.question {
            let levelDetailZero = Level5ViewModel.LevelDetail.init(levelTitle: question, levelContent: intro)
            levelMessages.append(levelDetailZero)
            levelMessages.append(contentsOf: messages)

        }
        savedAnswer = nil
        if let selectedValue = model?.domainModel?.latestGetToLevel5Value {
            tmpAnswer = max(selectedValue, 0)
        }
        if let currentAnswer = model?.domainModel?.currentGetToLevel5Value {
            savedAnswer = max(currentAnswer, 0)
            tmpAnswer = max(currentAnswer, 0)
        }
        updateButtonStatus()
        initialSetup()
    }

    func updateUI(_ questionContent: String?) {
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }

    //    when the bucket is loaded set level 1 as default
    func initialSetup() {
        questionLabel.text = tmpAnswer != 0 ? String.empty : model?.question
        updateUI(levelMessages.at(index: tmpAnswer)?.levelContent)
        setButtonBackgroundColor()
        setProgress()
    }

    func setUpButtons() {
        ThemeButton.whiteRounded.apply(saveButton)
    }

    func setButtonBackgroundColor() {
        buttons.forEach {(button) in
            ThemeButton.level5Button.apply(button, selected: tmpAnswer == button.tag)
        }
    }

    func setButtonText(_ buttonText: String?) {
        saveButton.setTitle(buttonText, for: .normal)
        ThemeButton.whiteRounded.apply(saveButton)
    }

    @IBAction func didPressLevel(_ sender: UIButton) {
        tmpAnswer = tmpAnswer == sender.tag ? 0 : sender.tag
        updateButtonStatus()
        initialSetup()
        if let level5Model = model {
            level5Model.domainModel?.currentGetToLevel5Value = tmpAnswer
            delegate?.didUpdateLevel5(with: level5Model)
        }
    }

    func updateButtonStatus() {
        if tmpAnswer == savedAnswer {
            setButtonText(AppTextService.get(.daily_brief_section_level_5_button_save).uppercased())
            ThemeButton.whiteRounded.apply(saveButton, selected: false)
            saveButton.isEnabled = false
        } else {
            setButtonText(AppTextService.get(.daily_brief_section_level_5_button_save).uppercased())
            ThemeButton.whiteRounded.apply(saveButton, selected: false)
            saveButton.isEnabled = true
        }
    }

    func setProgress() {
        let array: [[Float]] = [[0.0, 0.0, 0.0, 0.0],
                                [0.2, 0.0, 0.0, 0.0],
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
