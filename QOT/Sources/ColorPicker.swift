//
//  ColorPicker.swift
//  QOT
//
//  Created by karmic on 02.07.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

final class ColorPicker: UIView {

    enum Color: Int, CaseIterable {
        case pink = 0
        case purple = 1
        case green = 2
        case yellow = 3
        case blue = 4

        func get(_ hexColors: [String]) -> UIColor {
            guard let hex = hexColors.at(index: rawValue) else { return .clear }
            return UIColor(hex: hex)
        }
    }

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
    @IBOutlet private weak var labelContainer: UIView!
    @IBOutlet private weak var trailingConstraintPurple: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraintGreen: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraintYellow: NSLayoutConstraint!
    @IBOutlet private weak var trailingConstraintBlue: NSLayoutConstraint!
    weak var delegate: MyXTeamSettingsViewController?
    private var isOpen = false
    private var selectedColor = UIColor.clear
    private var teamColors = [String]()
    private var teamId = String.empty
    private lazy var teamPink: UIColor = Color.pink.get(teamColors)
    private lazy var teamPurple: UIColor = Color.purple.get(teamColors)
    private lazy var teamGreen: UIColor = Color.green.get(teamColors)
    private lazy var teamYellow: UIColor = Color.yellow.get(teamColors)
    private lazy var teamBlue: UIColor = Color.blue.get(teamColors)

    override func awakeFromNib() {
        super.awakeFromNib()
        NewThemeView.dark.apply(self)
        NewThemeView.dark.apply(labelContainer)
        colorBlue.circle()
        colorPurple.circle()
        colorGreen.circle()
        colorYellow.circle()
        colorPink.circle()
    }

    func configure(teamId: String, teamColors: [String], selectedColor: UIColor) {
        self.teamId = teamId
        self.teamColors = teamColors
        self.selectedColor = selectedColor
        setupColors()
        updateOrder()
    }
}

// MARK: - Action
private extension ColorPicker {
    @IBAction func didSelectColorPink() {
        selectedColor = teamPink
        hideSelectors()
        colorSelectorPink.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorPurple() {
        selectedColor = teamPurple
        hideSelectors()
        colorSelectorPurple.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorGreen() {
        selectedColor = teamGreen
        hideSelectors()
        colorSelectorGreen.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorYellow() {
        selectedColor = teamYellow
        hideSelectors()
        colorSelectorYellow.isHidden = false
        showColors()
    }

    @IBAction func didSelectColorBlue() {
        selectedColor = teamBlue
        hideSelectors()
        colorSelectorBlue.isHidden = false
        showColors()
    }
}

// MARK: - Private
private extension ColorPicker {
    func setupColors() {
        colorBlue.backgroundColor = teamBlue
        colorYellow.backgroundColor = teamYellow
        colorGreen.backgroundColor = teamGreen
        colorPurple.backgroundColor = teamPurple
        colorPink.backgroundColor = teamPink

        colorSelectorPink.backgroundColor = teamPink
        colorSelectorPurple.backgroundColor = teamPurple
        colorSelectorGreen.backgroundColor = teamGreen
        colorSelectorYellow.backgroundColor = teamYellow
        colorSelectorBlue.backgroundColor = teamBlue
    }

    func showColors() {
        if isOpen {
            UIView.animate(withDuration: Animation.duration_03, animations: {
                self.updateOrder()
                self.trailingConstraintPurple.constant = .zero
                self.trailingConstraintGreen.constant = .zero
                self.trailingConstraintYellow.constant = .zero
                self.trailingConstraintBlue.constant = .zero
                self.labelContainer.alpha = 1
                self.layoutIfNeeded()
            }, completion: { _ in
                self.postTeamColor(self.selectedColor)
            })
        } else {
            UIView.animate(withDuration: Animation.duration_03) {
                self.labelContainer.alpha = .zero
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
        if selectedColor == teamBlue {
            colorContainerBlue.superview?.bringSubviewToFront(colorContainerBlue)
        }
        if selectedColor == teamYellow {
            colorContainerYellow.superview?.bringSubviewToFront(colorContainerYellow)
        }
        if selectedColor == teamGreen {
            colorContainerGreen.superview?.bringSubviewToFront(colorContainerGreen)
        }
        if selectedColor == teamPurple {
            colorContainerPurple.superview?.bringSubviewToFront(colorContainerPurple)
        }
        if selectedColor == teamPink {
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

    func postTeamColor(_ color: UIColor) {
        let colorHexString = color.toHexString
        NotificationCenter.default.post(name: .didSelectTeamColor,
                                        object: colorHexString,
                                        userInfo: [Team.KeyColor: colorHexString])
    }
}
