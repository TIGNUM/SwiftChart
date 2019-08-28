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
    @IBOutlet private weak var viewHeight: NSLayoutConstraint!

    @IBAction func save(_ sender: UIButton) {
        delegate?.saveAnswerValue(sender.tag, from: self)
        self.comeBackView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + Animation.duration_6) {
           self.comeBackView.isHidden = true
        }
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
        setUpButtons()
        contentView.backgroundColor = .carbon
        saveButtons.forEach {(button) in saveButtonsUI(button: button)}
        viewHeight.constant = UIScreen.main.bounds.height / 2.5
        comeBackView.isHidden = true
    }

    func setUpButtons() {
        buttons.forEach {(button) in button.backgroundColor = .clear }
        buttons.forEach {(button) in
            button.circle()
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.accent.cgColor }
    }

    func saveButtonsUI(button: UIButton) {
     button.corner(radius: Layout.cornerRadius20, borderColor: .accent)
    }

    public func hideAllViews() {
        views.forEach {(view) in view.isHidden = true}
    }

    func configure(with: Level5CellViewModel?) {
        introLabel.text = with?.intro
        titleLabel.text = with?.title
        questionLabel.text = with?.question
        self.level1Title.text = with?.level1Title?.uppercased()
        self.level2Title.text = with?.level2Title?.uppercased()
        self.level3Title.text = with?.level3Title?.uppercased()
        self.level4Title.text = with?.level4Title?.uppercased()
        self.level5Title.text = with?.level5Title?.uppercased()
        self.level1Text.text = with?.level1Text
        self.level2Text.text = with?.level2Text
        self.level3Text.text = with?.level3Text
        self.level4Text.text = with?.level4Text
        self.level5Text.text = with?.level5Text

        if let selectedValue = with?.currentLevel {
            hideAllViews()
            setUpButtons()
            let valueIndex = selectedValue - 1
            buttons[valueIndex].backgroundColor = UIColor.accent.withAlphaComponent(0.4)
            views[valueIndex].isHidden = false
            viewHeight.constant = UIScreen.main.bounds.height * 1.25
        }
    }
}
