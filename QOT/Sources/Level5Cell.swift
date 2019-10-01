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
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private weak var levelTitle: UILabel!
    @IBOutlet private weak var levelText: UILabel!
    @IBOutlet weak var level1Button: AnimatedButton!
    @IBOutlet weak var level2Button: AnimatedButton!
    @IBOutlet weak var level3Button: AnimatedButton!
    @IBOutlet weak var level4Button: AnimatedButton!
    @IBOutlet weak var level5Button: AnimatedButton!
    @IBOutlet weak var knowledgeProgress: UIProgressView!
    @IBOutlet weak var saveButton: AnimatedButton!
    @IBOutlet weak var readinessProgress: UIProgressView!
    @IBOutlet weak var awarenssProgress: UIProgressView!
    @IBOutlet weak var masteryProgress: UIProgressView!
    @IBOutlet weak var progressStackView: UIStackView!
    var levelMessages: [Level5ViewModel.LevelDetail] = []
    weak var delegate: DailyBriefViewControllerDelegate?
    var savedAnswer: Int = 0
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
        delegate?.saveAnswerValue(savedAnswer + 1, from: self)
        let closeButtonItem = createCloseButton()
        QOTAlert.show(title: nil, message: confirmationMessage, bottomItems: [closeButtonItem])
        updateUI(levelMessages.at(index: savedAnswer)?.levelContent)
    }

    @objc func dismissAction() {
        QOTAlert.dismiss()
    }

    func createCloseButton() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        button.setImage(R.image.ic_close_rounded(), for: .normal)
        button.imageView?.contentMode = .center
        button.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: .Default, height: .Default))
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
        ThemeText.dailyBriefLevelTitle.apply(levelMessages.at(index: savedAnswer)?.levelTitle, to: levelTitle)
        updateUI(levelMessages.at(index: savedAnswer)?.levelContent)
        setButtonBackgroundColor()
        setProgress()
    }

    func setUpButtons() {
        ThemeBorder.accent.apply(saveButton)
        buttons.forEach {(button) in
            ThemeButton.clear.apply(button)
        }
    }

    func setButtonBackgroundColor() {
        buttons.forEach {(button) in
            button.backgroundColor = savedAnswer == button.tag ? .accent40 : .clear
        }
    }

    func setButtonText(_ buttonText: String?) {
        saveButton.setTitle(buttonText, for: .normal)
        ThemeView.level1.apply(saveButton)
    }

    @IBAction func didPressLevel(_ sender: UIButton) {
        setButtonText("Save")
        savedAnswer = sender.tag
        initialSetup()
        saveButton.isEnabled = true
        delegate?.didUpdateLevel5()
    }

    func setProgress() {
        let array: [[Float]] = [[0.2, 0.0, 0.0, 0.0],
                                [0.40, 0.25, 0.0, 0.0],
                                [0.60, 0.50, 0.33, 0.0],
                                [0.80, 0.75, 0.66, 0.50],
                                [1.0, 1.0, 1.0, 1.0]]
        let item = array[savedAnswer]
        knowledgeProgress.setProgress(item[0], animated: true)
        readinessProgress.setProgress(item[1], animated: true)
        awarenssProgress.setProgress(item[2], animated: true)
        masteryProgress.setProgress(item[3], animated: true)

    }
}
