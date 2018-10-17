//
//  PrepareSectionHeaderView.swift
//  QOT
//
//  Created by karmic on 04.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PrepareSectionHeaderView: UIView {

    // MARK: - Properties

    @IBOutlet private weak var topSeperatorView: UIView!
    @IBOutlet private weak var bottomSeperatorView: UIView!
    @IBOutlet private weak var calendarImageView: UIImageView!
    @IBOutlet private weak var eventNameLabel: UILabel!
    @IBOutlet private weak var eventDateLabel: UILabel!
    @IBOutlet private weak var completedTasksLabel: UILabel!
    @IBOutlet private weak var editButton: UIButton!
    weak var delegate: PrepareContentViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        eventNameLabel.textColor = .nightModeMainFont
        eventDateLabel.textColor = .nightModeMainFont
        completedTasksLabel.textColor = .nightModeBlack30
        eventNameLabel.font = Font.H6NavigationTitle
        eventDateLabel.font = Font.H7SectorTitle
        completedTasksLabel.font = Font.H7Title
        topSeperatorView.backgroundColor = .nightModeBlack30
        bottomSeperatorView.backgroundColor = .nightModeBlack30
        calendarImageView.image = R.image.shortcutItemPrepare()?.withRenderingMode(.alwaysTemplate)
        calendarImageView.tintColor = .nightModeBlack30
        backgroundColor = .nightModeBackground
        editButton.corner(radius: Layout.CornerRadius.eight.rawValue)
        editButton.backgroundColor = .azure
        editButton.setAttributedTitle(attributed(title: R.string.localized.prepareEditPreparationList()),
                                      for: .normal)
        editButton.setAttributedTitle(attributed(title: R.string.localized.prepareEditPreparationList()),
                                      for: .selected)
    }

    func configure(eventName: String, eventDate: String, completedTasks: String) {
        eventNameLabel.addCharactersSpacing(spacing: 2, text: eventName, uppercased: true)
        eventDateLabel.addCharactersSpacing(spacing: 2, text: eventDate, uppercased: true)
        completedTasksLabel.addCharactersSpacing(spacing: 2, text: completedTasks, uppercased: true)
    }

    func upddateCompletedTasks(_ completedTasks: String) {
        completedTasksLabel.addCharactersSpacing(spacing: 2, text: completedTasks, uppercased: true)
    }
}

// MARK: - Private

private extension PrepareSectionHeaderView {

    func attributed(title: String) -> NSAttributedString {
        return NSAttributedString(string: title,
                                  letterSpacing: 1,
                                  font: .bentonBookFont(ofSize: 16),
                                  textColor: .white,
                                  alignment: .center)
    }

    @IBAction func didTabEditPreparationButton() {
        delegate?.didTapAddRemove()
    }
}
