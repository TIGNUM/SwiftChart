//
//  PrepareContentReviewNotesTableViewCell.swift
//  QOT
//
//  Created by karmic on 21.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PrepareContentReviewNotesTableViewCell: UITableViewCell, Dequeueable {

    enum NotesType {
        case notes
        case intentionPerceiving
        case intentionKnowing
        case intentionFeeling
        case reflectionNotes
        case reflectionVision

        var row: Int {
            switch self {
            case .intentionPerceiving: return 0
            case .intentionKnowing: return 1
            case .intentionFeeling: return 2
            case .reflectionNotes: return 0
            case .reflectionVision: return 1
            case .notes: return 0
            }
        }

        var contentItemID: Int {
            switch self {
            case .intentionPerceiving: return 103432
            case .intentionKnowing: return 103433
            case .intentionFeeling: return 103434
            case .reflectionNotes: return 103435
            case .reflectionVision: return 103436
            case .notes: return 0
            }
        }
    }

    enum ReviewNotesType {
        case intentions
        case reflection

        var numberOfRowsInSection: Int {
            switch self {
            case .intentions: return 3
            case .reflection: return 2
            }
        }

        var navbarTitle: String {
            switch self {
            case .intentions: return R.string.localized.prepareReviewNotesIntentionsNavbarTitle()
            case .reflection: return R.string.localized.prepareReviewNotesReflectionsNavbarTitle()
            }
        }

        func placeholder(at row: Int) -> String {
            switch (self, row) {
            case (.intentions, 0): return R.string.localized.prepareReviewNotesIntentionsPerceivedPlaceholder()
            case (.intentions, 1): return R.string.localized.prepareReviewNotesIntentionsPersonGroupPlaceholder()
            case (.intentions, 2): return R.string.localized.prepareReviewNotesIntentionsPlaceholder()
            case (.reflection, 0): return R.string.localized.prepareReviewNotesReflectionBrainSuccessPlaceholder()
            case (.reflection, 1): return R.string.localized.prepareReviewNotesReflectionWishPlaceholder()
            default: return R.string.localized.prepareReviewNotesIntentionsPlaceholder()
            }
        }

        func contentItemID(at row: Int) -> Int {
            switch self {
            case .intentions:
                switch row {
                case 0: return NotesType.intentionPerceiving.contentItemID
                case 1: return NotesType.intentionKnowing.contentItemID
                case 2: return NotesType.intentionFeeling.contentItemID
                default: return 0
                }
            case .reflection:
                switch row {
                case 0: return NotesType.reflectionNotes.contentItemID
                case 1: return NotesType.reflectionVision.contentItemID
                default: return 0
                }
            }
        }
    }

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var reviewNotesButton: UIButton!
    private var reviewsNotesTyp = ReviewNotesType.intentions
    private var viewModel: PrepareContentViewModel?
    private weak var delegate: PrepareContentViewControllerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()

        contentView.backgroundColor = .white
    }

    func configure(title: String,
                   buttonTitle: String,
                   reviewNotesType: ReviewNotesType,
                   delegate: PrepareContentViewControllerDelegate?,
                   viewModel: PrepareContentViewModel) {
        self.reviewsNotesTyp = reviewNotesType
        self.delegate = delegate
        self.viewModel = viewModel
        titleLabel.attributedText = NSMutableAttributedString(string: title,
                                                              letterSpacing: 2,
                                                              font: Font.PText,
                                                              textColor: .black,
                                                              alignment: .left)
        reviewNotesButton.setAttributedTitle(NSMutableAttributedString(string: buttonTitle,
                                                                        letterSpacing: 2,
                                                                        font: Font.PText,
                                                                        textColor: .black40,
                                                                        alignment: .left), for: .normal)
    }
}

// MARK: - Actions

extension PrepareContentReviewNotesTableViewCell {

    @IBAction private func reviewNotesButtonTapped(_ sender: UIButton) {
        delegate?.didTapReviewNotesButton(sender: sender, reviewNotesType: reviewsNotesTyp, viewModel: viewModel)
    }
}
