//
//  MyToBeVisionTrackerViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class MyToBeVisionTrackerViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyToBeVisionTrackerInteractorInterface?
    var viewModel: MYTBVDataViewModel?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var loaderView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return generateBottomNavigationBarRighButtonItems()
    }

    @objc func doneAction() {
        trackUserEvent(.CLOSE, action: .TAP)
        dismiss(animated: true, completion: nil)
    }

    func reloadSubHeadingSection() {
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    private func generateBottomNavigationBarRighButtonItems() -> [UIBarButtonItem]? {
        if interactor?.controllerType == .tracker {
            return [roundedBarButtonItem(title: R.string.localized.tbvTrackerViewControllerDoneButton(), buttonWidth: 71, action: #selector(doneAction), backgroundColor: .carbon, borderColor: .accent)]
        } else {
            return nil
        }
    }
}

extension MyToBeVisionTrackerViewController: MyToBeVisionTrackerViewControllerInterface {

    func setupView(with data: MYTBVDataViewModel) {
        view.backgroundColor = .carbon
        viewModel = data
        tableView.registerDequeueable(TBVDataGraphTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphSubHeadingTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphAnswersTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphHeaderView.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }

    func showScreenLoader() {
        loaderView.isHidden = false
    }

    func hideScreenLoader() {
        loaderView.isHidden = true
    }
}

extension MyToBeVisionTrackerViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return MYTBVDataViewModel.Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch MYTBVDataViewModel.Section.allCases[section] {
        case .graph, .header:
            return 1
        case .sentence:
            return viewModel?.selectedAnswers?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch MYTBVDataViewModel.Section.allCases[indexPath.section] {
        case .header:
            let cell: TBVDataGraphSubHeadingTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            cell.isShowMoreClicked = viewModel?.subHeading?.isSelected ?? false
            let subHeading = interactor?.formattedSubHeading(title: viewModel?.subHeading?.title ?? "")
            cell.configure(subHeading: subHeading)
            cell.callback = {[weak self] newValue in
                self?.viewModel?.subHeading?.isSelected = newValue
                self?.reloadSubHeadingSection()
            }
            return cell
        case .graph:
            let cell: TBVDataGraphTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            if interactor?.controllerType == .tracker {
                cell.setup(items: viewModel?.graph?.ratings, config: .tbvTrackerConfig(), range: .defaultRange())
            } else {
                cell.setup(items: viewModel?.graph?.ratings, config: .tbvDataConfig(), range: .defaultRange())
            }
            return cell
        case .sentence:
            let cell: TBVDataGraphAnswersTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(answer: viewModel?.selectedAnswers?[indexPath.row])
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch MYTBVDataViewModel.Section.allCases[section] {
        case .header:
            return MYTBVDataViewModel.Section.header.height
        case .sentence:
            return MYTBVDataViewModel.Section.sentence.height
        default:
            return 0.1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        switch MYTBVDataViewModel.Section.allCases[section] {
        case .header:
            let headerView: TBVDataGraphHeaderView = tableView.dequeueHeaderFooter()
            let title = interactor?.formattedHeaderView(title: viewModel?.title ?? "")
            headerView.configure(title: title)
            return headerView
        case .sentence:
            let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
            headerView.config = TitleTableHeaderView.Config(backgroundColor: .carbon,
                                                            font: .sfProtextMedium(ofSize: 14),
                                                            textColor: .sand40)
            headerView.title = viewModel?.graph?.heading?.uppercased() ?? ""
            return headerView
        default:
            return nil
        }
    }
}

extension MyToBeVisionTrackerViewController: TBVDataGraphSubHeadingTableViewCellProtocol {
    func showMore() {
        if interactor?.controllerType == .tracker {
            trackUserEvent(.SELECT, valueType: "TBVTrackerShowMore", action: .TAP)
        } else {
            trackUserEvent(.SELECT, valueType: "TBVDataShowMore", action: .TAP)
        }
    }

    func showLess() {
        if interactor?.controllerType == .tracker {
            trackUserEvent(.SELECT, valueType: "TBVTrackerShowLess", action: .TAP)
        } else {
            trackUserEvent(.SELECT, valueType: "TBVDataShowLess", action: .TAP)
        }
    }
}

extension MyToBeVisionTrackerViewController: TBVDataGraphTableViewCellProtocol {
    func didSelect(date: Date?) {
        if interactor?.controllerType == .tracker {
            trackUserEvent(.SELECT, valueType: "TBVTrackerDate", action: .TAP)
        } else {
            trackUserEvent(.SELECT, valueType: "TBVDataDate", action: .TAP)
        }
        viewModel?.selectedDate = date
        viewModel = interactor?.setSelection(for: date)
        tableView.reloadData()
    }
}
