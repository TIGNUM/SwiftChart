//
//  PrepareCheckListViewController.swift
//  QOT
//
//  Created by karmic on 24.05.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol PrepareCheckListDelegatge: class {
    func dismissResultView()
    func openEditStrategyView()
}

final class PrepareCheckListViewController: UIViewController {

    // MARK: - Properties

    var interactor: PrepareCheckListInteractorInterface?
    private var resultView: PrepareCheckListResultView?

    private lazy var tableView: UITableView = {
        return UITableView(style: .grouped,
                           delegate: self,
                           dataSource: self)
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .carbonDark
        let attributedTitle = NSAttributedString(string: R.string.localized.morningControllerDoneButton().capitalized,
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14),
                                                 textColor: .accent,
                                                 alignment: .center)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return button
    }()

    private lazy var saveAndContinueButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .carbonDark
        let attributedTitle = NSAttributedString(string: R.string.localized.alertButtonTitleSaveAndContinue(),
                                                 letterSpacing: 0.2,
                                                 font: .sfProtextSemibold(ofSize: 14),
                                                 textColor: .accent,
                                                 alignment: .center)
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(saveAndContinue), for: .touchUpInside)
        return button
    }()

    private lazy var closeeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(R.image.ic_close_rounded(), for: .normal)
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
    func contentItemCell(itemFormat: ContentItemFormat?,
                         title: String?,
                         indexPath: IndexPath) -> PrePareCheckListContentItemTableViewCell {
        let cell: PrePareCheckListContentItemTableViewCell = tableView.dequeueCell(for: indexPath)
        let attributedString = interactor?.attributedText(title: title, itemFormat: itemFormat)
        let hasSeperator = interactor?.hasBottomSeperator(at: indexPath) ?? false
        let hasListMark = interactor?.hasListMark(at: indexPath) ?? false
        let hasHeaderMark = interactor?.hasHeaderMark(at: indexPath) ?? false
        cell.configure(attributedString: attributedString,
                       hasListMark: hasListMark,
                       hasSeperator: hasSeperator,
                       hasHeaderMark: hasHeaderMark)
        return cell
    }

    func eventCell(title: String?, date: Date, type: String?, indexPath: IndexPath) -> PrepareEventTableViewCell {
        let cell: PrepareEventTableViewCell = tableView.dequeueCell(for: indexPath)
        let dateString = String(format: "%@ | %@", date.eventDateString, type ?? "")
        cell.configure(title: title ?? "", dateString: dateString)
        return cell
    }

    func strategyCell(title: String?, duration: String?, indexPath: IndexPath) -> RelatedStrategyTableViewCell {
        let cell: RelatedStrategyTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: title, duration: duration)
        return cell
    }

    func reminderCell(title: String, subTitle: String, isOn: Bool, indexPath: IndexPath) -> ReminderTableViewCell {
        let cell: ReminderTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: title, subTitle: subTitle, isOn: isOn)
        return cell
    }
}

// MARK: - Actions

private extension PrepareCheckListViewController {
    @objc func dismissView() {
        dismiss(animated: false) {
            NotificationCenter.default.post(name: .dismissCoachView, object: nil)
        }
    }

    @objc func saveAndContinue() {
        let resultView = PrepareCheckListResultView.instantiateFromNib()
        resultView.delegate = self
        view.addSubview(resultView)
        resultView.edgeAnchors == view.edgeAnchors
        self.resultView = resultView
    }
}

// MARK: - PrepareCheckListViewControllerInterface

extension PrepareCheckListViewController: PrepareCheckListViewControllerInterface {
    func registerTableViewCell(for checkListType: PrepareCheckListType) {
        switch checkListType {
        case .daily:
            tableView.registerDequeueable(PrePareCheckListContentItemTableViewCell.self)
            tableView.registerDequeueable(PrepareEventTableViewCell.self)
            tableView.registerDequeueable(RelatedStrategyTableViewCell.self)
            tableView.registerDequeueable(ReminderTableViewCell.self)
        case .onTheGo:
            tableView.registerDequeueable(PrePareCheckListContentItemTableViewCell.self)
        case .peakPerformance: return
        }
    }

    func setupView() {
        view.addSubview(tableView)
        if interactor?.type == .onTheGo {
            doneButton.corner(radius: 20)
            view.addSubview(doneButton)
            doneButton.heightAnchor == 40
            doneButton.widthAnchor == 72
            doneButton.bottomAnchor == view.bottomAnchor - 24
            doneButton.rightAnchor == view.rightAnchor - 24
        }
        if interactor?.type == .daily {
            saveAndContinueButton.corner(radius: 20)
            view.addSubview(saveAndContinueButton)
            saveAndContinueButton.heightAnchor == 40
            saveAndContinueButton.widthAnchor == 152
            saveAndContinueButton.bottomAnchor == view.bottomAnchor - 24
            saveAndContinueButton.rightAnchor == view.rightAnchor - 24
        }
        if interactor?.type == .daily || interactor?.type == .peakPerformance {
            view.addSubview(closeeButton)
            closeeButton.heightAnchor == 40
            closeeButton.widthAnchor == 40
            closeeButton.bottomAnchor == view.bottomAnchor - 24
            closeeButton.leftAnchor == view.leftAnchor + 24
        }
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
        tableView.bottomAnchor == view.safeBottomAnchor - (view.bounds.height * Layout.multiplier_06)
        tableView.estimatedSectionHeaderHeight = 100
        view.backgroundColor = .sand
        view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension PrepareCheckListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return interactor?.sectionCount ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.rowCount(in: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = interactor?.item(at: indexPath) else { return UITableViewCell() }
        switch item {
        case .contentItem(let itemFormat, let title):
            return contentItemCell(itemFormat: itemFormat,
                                   title: title,
                                   indexPath: indexPath)
        case .eventItem(let title, let date, let type):
            return eventCell(title: title, date: date, type: type, indexPath: indexPath)
        case .strategy(let title, let readingTime, _):
            return strategyCell(title: title, duration: readingTime, indexPath: indexPath)
        case .reminder(let title, let subTitle, let isOn):
            return reminderCell(title: title, subTitle: subTitle, isOn: isOn, indexPath: indexPath)
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return interactor?.rowHeight(at: indexPath) ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 7 && interactor?.type == .daily {
            let view = EditHeaderView.instantiateFromNib()
            view.delegate = self
            return view
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 7 && interactor?.type == .daily {
            return 44
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let item = interactor?.item(at: indexPath) else { return }
        switch item {
        case .strategy(_, _, let readMoreID):
            interactor?.presentRelatedArticle(readMoreID: readMoreID)
        default: return
        }
    }
}

extension PrepareCheckListViewController: PrepareCheckListDelegatge {
    func openEditStrategyView() {
        interactor?.openEditStrategyView()
    }

    func dismissResultView() {
        resultView?.removeFromSuperview()
        dismissView()
    }
}

extension PrepareCheckListViewController: SelectWeeklyChoicesViewControllerDelegate {

    func dismiss(viewController: SelectWeeklyChoicesViewController, selectedContent: [WeeklyChoice]) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func dismiss(viewController: SelectWeeklyChoicesViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    func didTapRow(_ viewController: SelectWeeklyChoicesViewController,
                   contentCollection: ContentCollection,
                   contentCategory: ContentCategory) {
        interactor?.presentRelatedArticle(readMoreID: contentCollection.remoteID.value ?? 0)
    }
}
