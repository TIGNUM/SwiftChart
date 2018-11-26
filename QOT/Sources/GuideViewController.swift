//
//  GuideViewController.swift
//  QOT
//
//  Created by karmic on 29.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class GuideViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let sectionHeaderHeight: CGFloat = 24
    private var days: [Guide.Day] = []
    private let loadingView = BlurLoadingView(lodingText: R.string.localized.guideLoading(),
                                              activityIndicatorStyle: .whiteLarge)
    private var greetingView = GuideGreetingView.instantiateFromNib()
    private let backgroundGradientView = UIImageView(image: R.image.background_guide_gradient())
    var interactor: GuideInteractorInterface?
    var router: GuideRouterInterface?
    private lazy var tableView: UITableView = {
        let topInset: CGFloat = view.bounds.height * (UIDevice.isPad ? Layout.multiplier_06 : -Layout.multiplier_06)
        return UITableView(style: .grouped,
                           contentInsets: UIEdgeInsets(top: topInset, left: 0, bottom: 16, right: 0),
                           estimatedRowHeight: 100,
                           delegate: self,
                           dataSource: self,
                           dequeables: GuideWhatsHotTableViewCell.self,
									   GuideToBeVisionTableViewCell.self,
                                       GuideTableViewCell.self,
                                       GuideDailyPrepTableViewCell.self,
                                       GuidePreparationTableViewCell.self)
    }()

    // MARK: - Init

    init(configurator: Configurator<GuideViewController>) {
        super.init(nibName: nil, bundle: nil)
        configurator(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        setupView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.reload()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        UIApplication.shared.setStatusBarStyle(.lightContent)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        syncHeaderView()
    }
}

extension GuideViewController: GuideViewControllerInterface {

    func setLoading(_ loading: Bool) {
        loadingView.animateHidden(!loading)
    }

    func updateHeader(greeting: String, message: String) {
        greetingView.configure(message: message, greeting: greeting)
        syncHeaderView()
    }

    func updateDays(days: [Guide.Day]) {
        self.days = days
        tableView.reloadData()
        updateTabBarBadge()
    }

    func updateTabBarBadge() {
        var newGuideItems = [Guide.Item]()
        days.forEach { (day: Guide.Day) in
            day.items.forEach { (item: Guide.Item) in
                if item.status == .done && item.affectsTabBarBadge == true {
                    newGuideItems.append(item)
                }
            }
        }
    }
}

// MARK: - Private

private extension GuideViewController {

    func setupView() {
        view.backgroundColor = .navy
        tableView.tableHeaderView = greetingView
        tableView.estimatedRowHeight = 427
        view.addSubview(backgroundGradientView)
        view.addSubview(tableView)
        view.addSubview(loadingView)
        backgroundGradientView.trailingAnchor == view.trailingAnchor
        backgroundGradientView.topAnchor == view.topAnchor + (view.bounds.height * Layout.multiplier_003)
        backgroundGradientView.leftAnchor == view.leftAnchor + (view.bounds.width * Layout.multiplier_03)
		if #available(iOS 11.0, *) {
			tableView.edgeAnchors == view.edgeAnchors
		} else {
			tableView.topAnchor == view.topAnchor
			tableView.leadingAnchor == view.leadingAnchor
			tableView.trailingAnchor == view.trailingAnchor
			tableView.bottomAnchor == view.bottomAnchor
		}
		loadingView.edgeAnchors == view.edgeAnchors
        view.layoutIfNeeded()
        syncHeaderView()
    }

    func syncHeaderView() {
        let header = greetingView
        header.bounds = CGRect(x: 0,
                               y: 0,
                               width: Int(tableView.contentSize.width),
                               height: Int(view.frame.height * Layout.multiplier_035))
        header.setNeedsLayout()
        header.layoutIfNeeded()
        var frame = header.frame
        frame.size.height = header.bounds.height
        header.frame = frame
        tableView.tableHeaderView = header
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return days.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemAt(indexPath: indexPath)
        switch item.content {
        case .whatsHotArticle(let title, let body, let image):
            let cell: GuideWhatsHotTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, body: body, image: image, status: item.status)
            return cell
        case .toBeVision(let title, let body, let image):
            let cell: GuideToBeVisionTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, body: body, status: item.status, image: image)
            cell.delegate = self
            return cell
        case .dailyPrep(let items, let feedback, let whyDPMTitle, let whyDPMDescription):
            // FIXME: set whyDPM TITLE and Description
            let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
			cell.delegate = self
			cell.itemTapped = itemAt(indexPath: indexPath)
            cell.configure(dailyPrepFeedback: feedback,
                           dailyPrepItems: items,
                           status: item.status,
                           yPosition: cell.frame.origin.y,
                           whyDPMTitle: whyDPMTitle, whyDPMDescription: whyDPMDescription)
            return cell
        case .learningPlan(let value, let strategiesCompleted):
            let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: item.title,
                           content: value,
                           type: item.subtitle,
                           status: item.status,
                           strategiesCompleted: strategiesCompleted)
            return cell
        case .preparation(let title, let body):
            let cell: GuidePreparationTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: title, body: body, status: item.status)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 30, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        let label = UILabel(frame: view.frame)
        let headline = DateFormatter.mediumDate.string(from: days[section].localStartOfDay)
        view.addSubview(label)
        label.backgroundColor = UIColor.pineGreen.withAlphaComponent(0.6)
        label.attributedText = Style.navigationTitle(headline, .white40).attributedString()
        label.sizeToFit()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemAt(indexPath: indexPath)
		if item.isDailyPrep == true { return }
        router?.open(item: item)
        interactor?.didTapItem(item)

        if item.isWhatsHot == true && item.status == .todo {
            interactor?.didTapWhatsHotItem(item)
        } else if item.isToBeVision {
            interactor?.didTapMyToBeVision(item)
        }
    }

    private func itemAt(indexPath: IndexPath) -> Guide.Item {
        return days[indexPath.section].items[indexPath.row]
    }
}

// MARK: - GuideDailyPrepTableViewCellDelegate

extension GuideViewController: GuideDailyPrepTableViewCellDelegate {

	func didTapFeedbackButton(for item: Guide.Item) {
		router?.open(item: item)
	}

    func didTapInfoButton() {
        let configurator = ScreenHelpConfigurator.make(.dailyPrep)
        let infoViewController = ScreenHelpViewController(configurator: configurator, category: .dailyPrep)
        present(infoViewController, animated: true)
    }
}

// MARK: - GuideToBeVisionTableViewCellDelegate

extension GuideViewController: GuideToBeVisionTableViewCellDelegate {

    func didTapToBeVisionInfoButton() {
        let configurator = ScreenHelpConfigurator.make(.toBeVision)
        let infoViewController = ScreenHelpViewController(configurator: configurator, category: .toBeVision)
        present(infoViewController, animated: true)
    }
}
