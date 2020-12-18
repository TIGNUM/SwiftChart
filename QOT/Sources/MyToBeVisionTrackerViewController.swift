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

    var interactor: TBVRateHistoryInteractorInterface!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loaderView: UIView!
    private var report: ToBeVisionReport?

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        interactor.addObserver()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
    }
}

// MARK: - Actions
private extension MyToBeVisionTrackerViewController {
    @objc func doneAction() {
        trackUserEvent(.CLOSE, action: .TAP)
        dismiss(animated: true)
    }
}

// MARK: - TBVRateHistoryViewControllerInterface
extension MyToBeVisionTrackerViewController: TBVRateHistoryViewControllerInterface {
    func setupView(with data: ToBeVisionReport) {
        self.report = data
        ThemeView.level3.apply(view)
        tableView.registerDequeueable(TBVDataGraphTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphSubHeadingTableViewCell.self)
        tableView.registerDequeueable(TBVDataGraphAnswersTableViewCell.self)
        tableView.registerDequeueable(TitleTableHeaderView.self)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: BottomNavigationContainer.height, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }

    func showErrorNoReportAvailable(title: String, message: String) {
        let closeButtonItem = createCloseButton(#selector(dismissAlert))
        QOTAlert.show(title: title, message: message, bottomItems: [closeButtonItem])
    }

    @objc func dismissAlert() {
        QOTAlert.dismiss()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension MyToBeVisionTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return TBVGraph.Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch TBVGraph.Section.allCases[section] {
        case .graph,
             .header: return 1
        case .sentence: return interactor.numberOfRows
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TBVGraph.Section.allCases[indexPath.section] {
        case .header:
            let cell: TBVDataGraphSubHeadingTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(subHeading: interactor.subtitle)
            return cell
        case .graph:
            let cell: TBVDataGraphTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.delegate = self
            cell.setup(report: interactor.getDataModel,
                       config: interactor.getDisplayType.config,
                       range: .defaultRange())
            return cell
        case .sentence:
            let cell: TBVDataGraphAnswersTableViewCell = tableView.dequeueCell(for: indexPath)
            if let sentence = interactor.sentence(in: indexPath.row) {
                cell.configure(sentence, selectedDate: interactor.selectedDate, isTeam: interactor.isUserInteractionEnabled)
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.lightGrey.withAlphaComponent(0.1)
                cell.selectedBackgroundView = backgroundView
            }
            cell.accessoryView = interactor.isUserInteractionEnabled ? UIImageView(image: R.image.ic_disclosure()) : nil
            cell.accessoryView?.tintColor = .white
            cell.isUserInteractionEnabled = interactor.isUserInteractionEnabled
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch TBVGraph.Section.allCases[indexPath.section] {
        case .sentence:
            if let controller = R.storyboard.teamVisionTrackerDetails.teamVisionTrackerDetailsID(),
               let report = report,
               let sentence = interactor.sentence(in: indexPath.row) {
                let configurator = TeamVisionTrackerDetailsConfigurator.make(report: report,
                                                                             sentence: sentence,
                                                                             selectedDate: interactor.selectedDate)
                configurator(controller)
                pushToStart(childViewController: controller)
            }
        default: break
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch TBVGraph.Section.allCases[section] {
        case .header: return TBVGraph.Section.header.height
        case .sentence: return TBVGraph.Section.sentence.height
        default: return 0.1
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch TBVGraph.Section.allCases[section] {
        case .header:
            let headerView = R.nib.qotBaseHeaderView.firstView(owner: self)
            let title = interactor.title
            headerView?.configure(title: title, subtitle: nil)
            ThemeText.tbvTrackerHeader.apply(title.uppercased(), to: headerView?.titleLabel)
            return headerView
        case .sentence:
            let headerView: TitleTableHeaderView = tableView.dequeueHeaderFooter()
            headerView.configure(title: interactor.graphTitle, theme: .level3)
            return headerView
        default:
            return nil
        }
    }
}

extension MyToBeVisionTrackerViewController: TBVDataGraphProtocol {
    func didSelect(date: Date) {
        let dateString = DateFormatter.displayTime.string(from: date)
        trackUserEvent(.SELECT, stringValue: dateString, valueType: "TBV_RATE_DATE", action: .TAP)
        interactor.setSelection(for: date)
        tableView.reloadData()
    }
}

// MARK: - BottomNavigationItems
extension MyToBeVisionTrackerViewController {
    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return interactor.getDisplayType == .tracker ? nil : super.bottomNavigationLeftBarItems()
    }

    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        let doneItem = doneButtonItem(#selector(doneAction), borderColor: .accent40)
        return interactor.getDisplayType == .tracker ? [doneItem] : nil
    }
}
