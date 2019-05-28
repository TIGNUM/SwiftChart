//
//  PrepareCheckListViewController.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class PrepareCheckListViewController: UIViewController {

    // MARK: - Properties

    var interactor: PrepareCheckListInteractorInterface?

    private lazy var tableView: UITableView = {
        return UITableView(style: .grouped,
                           delegate: self,
                           dataSource: self,
                           dequeables: PrePareCheckListContentItemTableViewCell.self)
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .carbonDark
        let attributedTitle = NSAttributedString(string: R.string.localized.morningControllerDoneButton().capitalized,
                                                 letterSpacing: 0.2,
                                                 font: .sfProTextSemibold(ofSize: 14),
                                                 textColor: .accent,
                                                 alignment: .center)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    init(configure: Configurator<PrepareCheckListViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension PrepareCheckListViewController {

}

// MARK: - Actions

private extension PrepareCheckListViewController {
    @objc func dismissView() {
        dismiss(animated: false) {
            NotificationCenter.default.post(name: .dismissCoachView, object: nil)
        }
    }
}

// MARK: - PrepareCheckListViewControllerInterface

extension PrepareCheckListViewController: PrepareCheckListViewControllerInterface {
    func setupView() {
        view.addSubview(tableView)
        doneButton.corner(radius: 20)
        view.addSubview(doneButton)
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
            tableView.safeTopAnchor == view.safeTopAnchor
            tableView.leftAnchor == view.leftAnchor
            tableView.rightAnchor == view.rightAnchor
            tableView.contentInset.top = 84
            tableView.contentInset.bottom = view.safeMargins.bottom
        } else {
            tableView.topAnchor == view.topAnchor
            tableView.bottomAnchor == view.bottomAnchor
            tableView.rightAnchor == view.rightAnchor
            tableView.leftAnchor == view.leftAnchor
            tableView.contentInset.top = 84
        }
        doneButton.heightAnchor == 40
        doneButton.widthAnchor == 72
        doneButton.bottomAnchor == view.bottomAnchor - 24
        doneButton.rightAnchor == view.rightAnchor - 24
        tableView.bottomAnchor == view.safeBottomAnchor - (view.bounds.height * Layout.multiplier_06)
        tableView.estimatedSectionHeaderHeight = 100
        view.backgroundColor = .sand
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PrepareCheckListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.rowCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PrePareCheckListContentItemTableViewCell = tableView.dequeueCell(for: indexPath)
        let item = interactor?.item(at: indexPath)
        let attributedString = interactor?.attributedText(title: item?.title, itemFormat: item?.itemFormat)
        let hasSeperator = interactor?.hasBottomSeperator(at: indexPath) ?? false
        let hasListMark = interactor?.hasListMark(at: indexPath) ?? false
        let hasHeaderMark = interactor?.hasHeaderMark(at: indexPath) ?? false
        cell.configure(attributedString: attributedString,
                       hasListMark: hasListMark,
                       hasSeperator: hasSeperator,
                       hasHeaderMark: hasHeaderMark)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return interactor?.rowHeight(at: indexPath) ?? 0
    }
}
