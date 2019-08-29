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

    @IBOutlet private weak var comeBackView: UIView!
    @IBOutlet private weak var comeBackLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var introLabel: UILabel!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private var buttons: [UIButton]!
    @IBOutlet private var levelTitles: [UILabel]!
    @IBOutlet private weak var level1Title: UILabel!
    @IBOutlet private weak var level2Title: UILabel!
    @IBOutlet private weak var level3Title: UILabel!
    @IBOutlet private weak var level4Title: UILabel!
    @IBOutlet private weak var level5Title: UILabel!
    @IBOutlet private weak var level1Text: UILabel!
    @IBOutlet private weak var level2Text: UILabel!
    @IBOutlet private weak var level3Text: UILabel!
    @IBOutlet private weak var level4Text: UILabel!
    @IBOutlet private weak var level5Text: UILabel!
    @IBOutlet private var views: [UIView]!
    @IBOutlet private var saveButtons: [UIButton]!
    var delegate: DailyBriefViewControllerDelegate?

    @IBAction func save(_ sender: UIButton) {
        delegate?.saveAnswerValue(sender.tag, from: self)
        QOTAlert.show(title: R.string.localized.level5AlertTitle(), message: R.string.localized.level5AlertMessage())
        saveButtons.forEach {(button) in
            button.setTitle(R.string.localized.level5ButtonSaved(), for: .normal)
        }
    }

    @IBAction func selectNumber(_ sender: UIButton) {
        hideAllViews()
        setUpButtons()
        sender.backgroundColor = .accent40
        views[sender.tag].isHidden = false
        delegate?.changedGetToLevel5Value(sender.tag + 1, from: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        hideAllViews()
        views.first?.isHidden = false
        setUpButtons()
        contentView.backgroundColor = .carbon
        saveButtons.forEach {(button) in saveButtonsUI(button: button)}
        comeBackView.isHidden = true
    }

    func setUpButtons() {
        buttons.forEach {(button) in button.backgroundColor = .clear }
        buttons.forEach {(button) in
            button.circle()
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.accent40.cgColor }
    }

    func saveButtonsUI(button: UIButton) {
        button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    public func hideAllViews() {
        views.forEach {(view) in view.isHidden = true}
    }

    func configure(with: Level5CellViewModel?) {
        ThemeView.level2.apply(self)
        ThemeText.dailyBriefTitle.apply((with?.title ?? "").uppercased(), to: titleLabel)
        ThemeText.level5Question.apply(with?.question, to: questionLabel)
        ThemeText.sprintTitle.apply(with?.level1Title, to: level1Title)
        ThemeText.sprintTitle.apply(with?.level2Title, to: level2Title)
        ThemeText.sprintTitle.apply(with?.level3Title, to: level3Title)
        ThemeText.sprintTitle.apply(with?.level4Title, to: level4Title)
        ThemeText.sprintTitle.apply(with?.level5Title, to: level5Title)
        ThemeText.sprintText.apply(with?.level1Text, to: level1Text)
        ThemeText.sprintText.apply(with?.level2Text, to: level2Text)
        ThemeText.sprintText.apply(with?.level3Text, to: level3Text)
        ThemeText.sprintText.apply(with?.level4Text, to: level4Text)
        ThemeText.sprintText.apply(with?.level5Text, to: level5Text)

        if let selectedValue = with?.currentLevel {
            hideAllViews()
            setUpButtons()
            let valueIndex = selectedValue - 1
            buttons[valueIndex].backgroundColor = UIColor.accent.withAlphaComponent(0.4)
            views[valueIndex].isHidden = false
        }
    }
}
