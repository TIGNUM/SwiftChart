//
//  MyToBeVisionTrackerViewController.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyToBeVisionTrackerViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: MyToBeVisionTrackerInteractorInterface?
    var viewModel: MYTBVDataViewModel?
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var loaderView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        ThemeView.level3.apply(view)
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        if interactor?.controllerType == .tracker {
            return nil
        } else {
            return super.bottomNavigationLeftBarItems()
        }
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        if interactor?.controllerType == .tracker {
            return [roundedBarButtonItem(title: AppTextService.get(AppTextKey.my_qot_my_tbv_view_done_button),
                                         buttonWidth: .Done,
                                         action: #selector(doneAction),
                                         backgroundColor: .carbon,
                                         borderColor: .accent40)]
        } else {
            return nil
        }
    }

    @objc func doneAction() {
        trackUserEvent(.CLOSE, action: .TAP)
        dismiss(animated: true, completion: nil)
    }

    func reloadSubHeadingSection() {
        let indexPath = IndexPath(item: 0, section: 0)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

extension MyToBeVisionTrackerViewController: MyToBeVisionTrackerViewControllerInterface {

    func setupView(with data: MYTBVDataViewModel) {
        viewModel = data
        tableView.registerDequeueable(TBVDataGraphTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphSubHeadingTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphAnswersTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphHeaderView.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
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
            cell.configure(subHeading: viewModel?.subHeading?.title)
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
            let title = viewModel?.title ?? ""
            headerView.configure(title: title)
            return headerView
        case .sentence:
            let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
            headerView.configure(title: viewModel?.graph?.heading?.uppercased() ?? "", theme: .level3)
            return headerView
        default:
            return nil
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
