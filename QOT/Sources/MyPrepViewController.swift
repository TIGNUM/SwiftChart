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

    fileprivate let disposeBag = DisposeBag()
    fileprivate lazy var tableView: UITableView = {
        return UITableView(
            delegate: self,
            dataSource: self,
            dequeables: MyPrepTableViewCell.self
        )
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

    let viewModel: MyPrepViewModel
    weak var delegate: MyPrepViewControllerDelegate?

    // MARK: - Life Cycle

    init(viewModel: MyPrepViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        viewModel.updates.observeNext { [unowned self] (change: MyPrepViewModel.CollectionUpdate) in
            switch change {
            case .willBegin:
                self.tableView.beginUpdates()
            case .didFinish:
                self.tableView.endUpdates()
            case .reload:
                self.tableView.reloadData()
            case .update(let deletions, _, _):
                self.tableView.deleteRows(at: deletions, with: .automatic)
            }
        }.dispose(in: disposeBag)

        viewModel.itemCountUpdate.observeNext {[unowned self] itemCount in
            self.emptyLabel.isHidden = !(itemCount == 0)
        }.dispose(in: disposeBag)
    }
}

// MARK: - Private

private extension MyPrepViewController {

    func setupView() {
        view.backgroundColor = .clear
        view.addSubview(tableView)
        view.applyTopFade()

        tableView.topAnchor == view.topAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top, left: 0.0, bottom: 64.0, right: 0.0)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MyPrepViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(at: indexPath.row)

        let cell: MyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
        let count: String = String(format: "%02d/%02d", item.finishedPreparationCount, item.totalPreparationCount)

        var timeToEvent = ""

        if let startDate = item.startDate {
            timeToEvent = Date().timeToDateAsString(startDate)
        }

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
