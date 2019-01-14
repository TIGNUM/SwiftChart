//
//  PrepareNotesViewController.swift
//  QOT
//
//  Created by karmic on 05.10.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class PrepareNotesViewController: UIViewController {

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

        var placeholder: String {
            switch self {
            case .intentionPerceiving: return R.string.localized.prepareReviewNotesIntentionsPerceivedPlaceholder()
            case .intentionKnowing: return R.string.localized.prepareReviewNotesIntentionsPersonGroupPlaceholder()
            case .intentionFeeling: return R.string.localized.prepareReviewNotesIntentionsPlaceholder()
            case .reflectionNotes: return R.string.localized.prepareReviewNotesReflectionBrainSuccessPlaceholder()
            case .reflectionVision: return R.string.localized.prepareReviewNotesReflectionWishPlaceholder()
            case .notes: return R.string.localized.prepareNotesPlaceholder()
            }
        }

        var navBarTitle: String {
            switch self {
            case .intentionPerceiving,
                 .intentionKnowing,
                 .intentionFeeling: return R.string.localized.prepareReviewNotesIntentionsNavbarTitle()
            case .reflectionNotes,
                 .reflectionVision: return R.string.localized.prepareReviewNotesReflectionsNavbarTitle()
            case .notes: return R.string.localized.prepareReviewNotesGeneralNavbarTitle()
            }
        }
    }

    enum ReviewNotesType {
        case intentions
        case reflection
        case general

        static var allValues: [ReviewNotesType] {
            return [.intentions, .reflection, .general]
        }

        var numberOfRowsInSection: Int {
            switch self {
            case .intentions: return 3
            case .reflection: return 2
            case .general: return 1
            }
        }

        var navbarTitle: String {
            switch self {
            case .intentions: return R.string.localized.prepareReviewNotesIntentionsNavbarTitle()
            case .reflection: return R.string.localized.prepareReviewNotesReflectionsNavbarTitle()
            case .general: return R.string.localized.prepareReviewNotesGeneralNavbarTitle()
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

        func title(at row: Int) -> String {
            switch (self, row) {
            case (.intentions, 0): return R.string.localized.prepareReviewNotesIntentionPreceivingTitle()
            case (.intentions, 1): return R.string.localized.prepareReviewNotesIntentionFeelingTitle()
            case (.intentions, 2): return R.string.localized.prepareReviewNotesIntentionKnowingTitle()
            case (.reflection, 0): return R.string.localized.prepareReviewNotesReflectionPositiveTitle()
            case (.reflection, 1): return R.string.localized.prepareReviewNotesReflectionImproveTitle()
            default: return R.string.localized.prepareReviewNotesGeneralTitle()
            }
        }

        func notesType(at row: Int) -> NotesType {
            switch (self, row) {
            case (.intentions, 0): return NotesType.intentionPerceiving
            case (.intentions, 1): return NotesType.intentionKnowing
            case (.intentions, 2): return NotesType.intentionFeeling
            case (.reflection, 0): return NotesType.reflectionNotes
            case (.reflection, 1): return NotesType.reflectionVision
            default: return NotesType.notes
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
            default: return 0
            }
        }
    }

    // MARK: - Properties

    @IBOutlet private weak var tableView: UITableView!
    var viewModel: PrepareContentViewModel?
    private var selectedNotes = NotesType.notes

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            let navigationController = segue.destination as? UINavigationController,
            let notesController = navigationController.childViewControllers.first as? PrepareContentNotesViewController {
                notesController.notesType = selectedNotes
                let text = selectedNotes == .notes ? viewModel?.notes : viewModel?.notesDictionary[selectedNotes.contentItemID]
                notesController.text = text
                notesController.delegate = viewModel
        }
    }
}

// MARK: - Private

private extension PrepareNotesViewController {

    func setupView() {
        tableView.registerDequeueable(PrepareNotesTableViewCell.self)
        tableView.estimatedRowHeight = Layout.padding_80
        tableView.backgroundColor = .nightModeBackground
        view.backgroundColor = .nightModeBackground
    }
}

extension PrepareNotesViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return ReviewNotesType.allValues.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ReviewNotesType.allValues[section].numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrepareNotesTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: ReviewNotesType.allValues[indexPath.section].title(at: indexPath.row))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedNotes = ReviewNotesType.allValues[indexPath.section].notesType(at: indexPath.row)
        performSegue(withIdentifier: R.segue.prepareNotesViewController.prepareNotesSegueIdentifier, sender: nil)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Layout.padding_64
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = R.nib.prepareNotesHeaderView.instantiate(withOwner: self).first as? PrepareNotesHeaderView
        view?.configure(title: ReviewNotesType.allValues[section].navbarTitle)
        return view
    }
}
