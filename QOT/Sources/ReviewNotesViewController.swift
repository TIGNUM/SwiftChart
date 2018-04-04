//
//  ReviewNotesViewController.swift
//  QOT
//
//  Created by karmic on 26.03.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import UIKit

final class ReviewNotesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    private let cellIdentifier = R.reuseIdentifier.reviewNotesTableViewCell_ID.identifier
    private var viewModel: PrepareContentViewModel!
    private var reviewNotesType = PrepareContentReviewNotesTableViewCell.ReviewNotesType.intentions

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupTableView()
    }

    func configure(viewModel: PrepareContentViewModel?,
                   reviewNotesType: PrepareContentReviewNotesTableViewCell.ReviewNotesType) {
        self.viewModel = viewModel
        self.reviewNotesType = reviewNotesType
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            let noteViewController = segue.destination as? PrepareContentNotesViewController,
            let row = tableView.indexPathForSelectedRow?.row else { return }

        let notesType: PrepareContentReviewNotesTableViewCell.NotesType
        let text: String?
        switch (reviewNotesType, row) {
        case (.intentions, 0):
            notesType = .intentionPerceiving
            text = viewModel.notesDictionary[notesType.contentItemID]
        case (.intentions, 1):
            notesType = .intentionKnowing
            text = viewModel.notesDictionary[notesType.contentItemID]
        case (.intentions, 2):
            notesType = .intentionFeeling
            text = viewModel.notesDictionary[notesType.contentItemID]
        case (.reflection, 0):
            notesType = .reflectionNotes
            text = viewModel.notesDictionary[notesType.contentItemID]
        case (.reflection, 1):
            notesType = .reflectionVision
            text = viewModel.notesDictionary[notesType.contentItemID]
        default: fatalError("Invalid setup")
        }
        noteViewController.text = text
        noteViewController.notesType = notesType
        noteViewController.delegate = viewModel
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }
}

// MARK: - Private

private extension ReviewNotesViewController {

    func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black40
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: Font.H5SecondaryHeadline,
                                                                   NSAttributedStringKey.foregroundColor: UIColor.black]
        title = reviewNotesType.navbarTitle
    }

    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 16, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ReviewNotesViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewNotesType.numberOfRowsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                       for: indexPath) as? ReviewNotesTableViewCell,
            let headline = viewModel.notesHeadline(with: reviewNotesType.contentItemID(at: indexPath.row)) else {
                fatalError("SettingsTableViewCell DOES NOT EXIST!!!")
        }
        let contentItemID = reviewNotesType.contentItemID(at: indexPath.row)
        cell.configure(title: headline,
                       notes: viewModel.notesDictionary[contentItemID],
                       reviewNotesType: reviewNotesType)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
