//
//  ColorPicker.swift
//  QOT
//
//  Created by karmic on 02.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ColorPicker: UIView {

    private var skeletonManager = SkeletonManager()

    @IBOutlet private weak var colorPink: UIButton!
    @IBOutlet private weak var colorPurple: UIButton!
    @IBOutlet private weak var colorGreen: UIButton!
    @IBOutlet private weak var colorYellow: UIButton!
    @IBOutlet private weak var colorBlue: UIButton!

    @IBOutlet private weak var colorContainerBlue: UIView!
    @IBOutlet private weak var colorContainerYellow: UIView!
    @IBOutlet private weak var colorContainerGreen: UIView!
    @IBOutlet private weak var colorContainerPurple: UIView!
    @IBOutlet private weak var colorContainerPink: UIView!

    @IBOutlet private weak var colorSelectorBlue: UIView!
    @IBOutlet private weak var colorSelectorYellow: UIView!
    @IBOutlet private weak var colorSelectorGreen: UIView!
    @IBOutlet private weak var colorSelectorPurple: UIView!
    @IBOutlet private weak var colorSelectorPink: UIView!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var trailingConstraintPurple: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraintGreen: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraintYellow: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraintBlue: NSLayoutConstraint!

    weak var delegate: MyXTeamSettingsViewController?

    private var isOpen = false
    private var selectedColor = UIColor.teamPink

    override func awakeFromNib() {
        super.awakeFromNib()
        colorBlue.circle()
        colorPurple.circle()
        colorGreen.circle()
        colorYellow.circle()
        colorPink.circle()

        colorBlue.backgroundColor = .teamBlue
        colorYellow.backgroundColor = .teamYellow
        colorGreen.backgroundColor = .teamGreen
        colorPurple.backgroundColor = .teamPurple
        colorPink.backgroundColor = .teamPink

        colorSelectorPink.backgroundColor = .teamPink
        colorSelectorPurple.backgroundColor = .teamPurple
        colorSelectorGreen.backgroundColor = .teamGreen
        colorSelectorYellow.backgroundColor = .teamYellow
        colorSelectorBlue.backgroundColor = .teamBlue
    }

    func addTo(superview: UIView) {
         superview.fill(subview: self)
     }

    @IBAction func editTapped(_ sender: Any) {
        delegate?.presentEditTeam()
    }

    func configure(name: String) {
        ThemeText.linkMenuItem.apply(name, to: nameLabel)
    }
}

// MARK: - Action
private extension ColorPicker {
    @IBAction func didSelectColorPink() {
        selectedColor = .teamPink
        hideSelectors()
        colorSelectorPink.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorPurple() {
        selectedColor = .teamPurple
        hideSelectors()
        colorSelectorPurple.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorGreen() {
        selectedColor = .teamGreen
        hideSelectors()
        colorSelectorGreen.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorYellow() {
        selectedColor = .teamYellow
        hideSelectors()
        colorSelectorYellow.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorBlue() {
        selectedColor = .teamBlue
        hideSelectors()
        colorSelectorBlue.isHidden = false
        showColors()
    }
}

private extension ColorPicker {
    func showColors() {
        if isOpen {
            UIView.animate(withDuration: 0.3) {
                self.updateOrder()
                self.trailingConstraintPurple.constant = 0
                self.trailingConstraintGreen.constant = 0
                self.trailingConstraintYellow.constant = 0
                self.trailingConstraintBlue.constant = 0
                self.nameLabel.alpha = 1
                self.editButton.alpha = 1
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.nameLabel.alpha = 0
                self.editButton.alpha = 0
                self.trailingConstraintPurple.constant = 76
                self.trailingConstraintGreen.constant = 76 * 2
                self.trailingConstraintYellow.constant = 76 * 3
                self.trailingConstraintBlue.constant = 76 * 4
                self.layoutIfNeeded()
            }
        }
        isOpen = !isOpen
    }

    func updateOrder() {
        if selectedColor == .teamBlue {
            colorContainerBlue.superview?.bringSubviewToFront(colorContainerBlue)
        }
        if selectedColor == .teamYellow {
            colorContainerYellow.superview?.bringSubviewToFront(colorContainerYellow)
        }
        if selectedColor == .teamGreen {
            colorContainerGreen.superview?.bringSubviewToFront(colorContainerGreen)
        }
        if selectedColor == .teamPurple {
            colorContainerPurple.superview?.bringSubviewToFront(colorContainerPurple)
        }
        if selectedColor == .teamPink {
            colorContainerPink.superview?.bringSubviewToFront(colorContainerPink)
        }
    }

    func hideSelectors() {
        colorSelectorPink.isHidden = true
        colorSelectorPurple.isHidden = true
        colorSelectorGreen.isHidden = true
        colorSelectorYellow.isHidden = true
        colorSelectorBlue.isHidden = true
    }
}
