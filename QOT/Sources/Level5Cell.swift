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

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introLabel: UILabel!
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
    var levelMessages: [Level5ViewModel.LevelDetail] = []
    weak var delegate: DailyBriefViewControllerDelegate?
    var savedAnswer: Int?
    var tmpAnswer: Int = 0
    var confirmationMessage: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        skeletonManager.addTitle(titleLabel)
        skeletonManager.addSubtitle(introLabel)
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
        let closeButtonItem = createCloseButton()
        QOTAlert.show(title: nil, message: confirmationMessage, bottomItems: [closeButtonItem])
        updateUI(levelMessages.at(index: tmpAnswer)?.levelContent)
    }

    @objc func dismissAction() {
        QOTAlert.dismiss()
    }

    func createCloseButton() -> UIBarButtonItem {
        let button = RoundedButton.init(title: nil, target: self, action: #selector(dismissAction))
        let heightConstraint = NSLayoutConstraint.init(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint.init(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 40)
        button.addConstraints([heightConstraint, widthConstraint])
        button.setImage(R.image.ic_close(), for: .normal)
        ThemeButton.closeButton(.dark).apply(button)
        return UIBarButtonItem(customView: button)
    }

    func configure(with: Level5ViewModel?) {
        skeletonManager.hide()
        ThemeText.dailyBriefTitle.apply(with?.title, to: titleLabel)
        ThemeText.dailyBriefSubtitle.apply(with?.intro, to: introLabel)
        ThemeText.level5Question.apply(with?.question, to: questionLabel)
        confirmationMessage = with?.confirmationMessage
        levelMessages = with?.levelMessages ?? []
        if let selectedValue = with?.domainModel?.currentGetToLevel5Value ?? with?.domainModel?.latestGetToLevel5Value {
            tmpAnswer = selectedValue - 1
            savedAnswer = tmpAnswer
        }
        if with?.domainModel?.currentGetToLevel5Value == nil && with?.domainModel?.latestGetToLevel5Value != nil {
            savedAnswer = nil
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
            ThemeButton.level5.apply(button, selected: tmpAnswer == button.tag)
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
            setButtonText("Saved")
            ThemeButton.level5.apply(saveButton, selected: true)
            saveButton.isEnabled = false
        } else {
            setButtonText("Save")
            ThemeButton.level5.apply(saveButton, selected: false)
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
