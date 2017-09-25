//
//  MyPrepViewController.swift
//  QOT
//
//  Created by karmic on 30/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import Bond
import ReactiveKit

protocol MyPrepViewControllerDelegate: class {

    func didTapMyPrepItem(with myPrepItem: MyPrepViewModel.Item, viewController: MyPrepViewController)
}

final class MyPrepViewController: UIViewController {

    // MARK: - Properties

    let viewModel: MyPrepViewModel
    weak var delegate: MyPrepViewControllerDelegate?
    fileprivate let disposeBag = DisposeBag()

    fileprivate lazy var tableView: UITableView = {
        return UITableView(delegate: self,
                           dataSource: self,
                           dequeables: MyPrepTableViewCell.self)
    }()

    fileprivate lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .white40
        label.numberOfLines = 0
        label.prepareAndSetTextAttributes(text: R.string.localized.prepareMyPrepNoSavePreparations(),
                                          font: Font.DPText,
                                          alignment: .center,
                                          lineSpacing: 7,
                                          characterSpacing: 1)
        self.view.addSubview(label)
        label.horizontalAnchors == self.view.horizontalAnchors
        label.verticalAnchors == self.view.verticalAnchors

        return label
    }()

    private lazy var editBarButtonItem: UIBarButtonItem = {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMode))
        editButton.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: Font.H5SecondaryHeadline], for: .normal)
        editButton.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: Font.H5SecondaryHeadline], for: .selected)

        return editButton
    }()

    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelEditMode))
        cancelButton.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: Font.H5SecondaryHeadline], for: .normal)
        cancelButton.setTitleTextAttributes([.foregroundColor: UIColor.white, .font: Font.H5SecondaryHeadline], for: .selected)

        return cancelButton
    }()

    // MARK: - Init

    init(viewModel: MyPrepViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        observeViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        guard viewModel.itemCount > 0 else {
            return
        }

        navigationController?.navigationBar.topItem?.leftBarButtonItem = editBarButtonItem
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tableView.setEditing(false, animated: true)
        navigationController?.navigationBar.topItem?.leftBarButtonItem = nil
    }
}

// MARK: - Actions

private extension MyPrepViewController {

    @objc func editMode() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = cancelBarButtonItem
        tableView.setEditing(true, animated: true)
    }

    @objc func cancelEditMode() {
        navigationController?.navigationBar.topItem?.leftBarButtonItem = editBarButtonItem
        tableView.setEditing(false, animated: true)
    }
}

// MARK: - Private

private extension MyPrepViewController {

    func observeViewModel() {
        viewModel.updates.observeNext { [unowned self] (change: MyPrepViewModel.CollectionUpdate) in
            switch change {
            case .reload,
                 .update: self.updateView()
            default: return
            }
        }.dispose(in: disposeBag)

        viewModel.itemCountUpdate.observeNext {[unowned self] itemCount in
            self.updateView()
        }.dispose(in: disposeBag)
    }

    func setupView() {
        let height: CGFloat = 70
        view.backgroundColor = .clear
        view.addSubview(tableView)
        view.applyFade()
        view.applyFade(origin: CGPoint(x: view.bounds.origin.x, y: view.bounds.origin.y + view.bounds.height - height),
                       height: height,
                       direction: .up)
        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top, left: 0.0, bottom: 64.0, right: 0.0)
    }

    func updateView() {
        let barButtonItem = tableView.isEditing == true ? cancelBarButtonItem : editBarButtonItem
        navigationController?.navigationBar.topItem?.leftBarButtonItem = viewModel.itemCount == 0 ? nil : barButtonItem
        emptyLabel.isHidden = viewModel.itemCount > 0
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPrepViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)
        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
        let count: String = String(format: "%02d/%02d", item.finishedPreparationCount, item.totalPreparationCount)
        let timeToEvent = item.startDate == nil ? "" : Date().timeToDateAsString(item.startDate ?? Date())
        let footer = timeToEvent.isEmpty ? "" : R.string.localized.prepareMyPrepTimeToEvent(timeToEvent)
        cell.setup(with: item.header, text: item.text, footer: footer, count: count)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = viewModel.item(at: indexPath.row)
        delegate?.didTapMyPrepItem(with: item, viewController: self)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 117
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            try? self.viewModel.deleteItem(at: indexPath.row)
        }
    }
}

// MARK: - PageSwipe

extension MyPrepViewController: PageSwipe {

    func canSwipePageDirection(_ direction: PageDirection) -> Bool {
        return direction == .backward
    }
}
