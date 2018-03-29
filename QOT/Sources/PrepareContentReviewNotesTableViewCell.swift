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

        var placeholder: String {
            switch self {
            case .intentions: return R.string.localized.prepareReviewNotesIntentionsPlaceholder()
            case .reflection: return R.string.localized.prepareReviewNotesReflectionsPlaceholder()
            }
        }

        func title(at row: Int) -> String {
            switch self {
            case .intentions:
                switch row {
                case 0: return R.string.localized.prepareReviewNotesIntentionPreceivingTitle()
                case 1: return R.string.localized.prepareReviewNotesIntentionKnowingTitle()
                case 2: return R.string.localized.prepareReviewNotesIntentionFeelingTitle()
                default: return ""
                }
            case .reflection:
                switch row {
                case 0: return R.string.localized.prepareReviewNotesReflectionPositiveTitle()
                case 1: return R.string.localized.prepareReviewNotesReflectionImproveTitle()
                default: return ""
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
