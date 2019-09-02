//
//  Level5Cell.swift
//  QOT
//
//  Created by Anais Plancoulaine on 01.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class Level5Cell: UITableViewCell, Dequeueable {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private weak var levelTitle: UILabel!
    @IBOutlet private weak var levelText: UILabel!
    @IBOutlet private var views: [UIView]!
    @IBOutlet private var saveButtons: [UIButton]!
    @IBOutlet weak var level1Button: UIButton!
    @IBOutlet weak var level2Button: UIButton!
    @IBOutlet weak var level3Button: UIButton!
    @IBOutlet weak var level4Button: UIButton!
    @IBOutlet weak var level5Button: UIButton!
    @IBOutlet weak var knowledgeProgress: UIProgressView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var readinessProgress: UIProgressView!
    @IBOutlet weak var awarenssProgress: UIProgressView!
    @IBOutlet weak var masteryProgress: UIProgressView!
    var levelMessages: [Level5ViewModel.LevelDetail] = []
    var delegate: DailyBriefViewControllerDelegate?
    var savedAnswer: Int = 0
    var confirmationMessage: String?

    @IBAction func save(_ sender: UIButton) {
        saveButton.setTitle("Saved", for: .normal)
        delegate?.saveAnswerValue(savedAnswer, from: self)
        QOTAlert.show(title: nil, message: confirmationMessage)
    }

    func configure(with: Level5ViewModel?) {
        ThemeText.dailyBriefTitle.apply(with?.title, to: titleLabel)
        ThemeText.dailyBriefLevelContent.apply(with?.intro, to: introLabel)
        ThemeText.registrationCodeDescription.apply(with?.question, to: questionLabel)
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

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpButtons()
        ThemeView.level2.apply(self)
    }
    //
    func setUpButtons() {
        saveButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        buttons.forEach {(button) in
            button.corner(radius: button.frame.width / 2, borderColor: .accent40)
        }
    }

    func setButtonBackgroundColor() {
        buttons.forEach {(button) in
            button.backgroundColor = savedAnswer == button.tag ? .accent40 : .clear
        }
    }

    func setButtonText(_ buttonText: String?) {
        saveButton.setTitle(buttonText, for: .normal)
    }

    @IBAction func didPressLevel(_ sender: UIButton) {
        setButtonText("Save")
        savedAnswer = sender.tag
        initialSetup()
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
