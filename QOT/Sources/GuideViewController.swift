//
//  GuideViewController.swift
//  QOT
//
//  Created by karmic on 29.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import Bond
import ReactiveKit

final class GuideViewController: UIViewController, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let sectionHeaderHeight: CGFloat = 24
    private let fadeContainerView = FadeContainerView()
    private let disposeBag = DisposeBag()
    private var days: [Guide.Day] = []
    private let loadingView = BlurLoadingView(lodingText: R.string.localized.guideLoading(),
                                              activityIndicatorStyle: .whiteLarge)
    private var greetingView = GuideGreetingView.instantiateFromNib()
    private var greetingImageURL: URL?
    var interactor: GuideInteractorInterface?
    var router: GuideRouterInterface?

    private lazy var tableView: UITableView = {
        return UITableView(style: .plain,
                           contentInsets: UIEdgeInsets(top: -64, left: 0, bottom: 16, right: 0),
                           estimatedRowHeight: 100,
                           delegate: self,
                           dataSource: self,
                           dequeables: GuideWhatsHotTableViewCell.self,
									   GuideToBeVisionTableViewCell.self,
                                       GuideTableViewCell.self,
                                       GuideDailyPrepTableViewCell.self)
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
        syncHeaderView(imageURL: greetingImageURL)
    }
}

extension GuideViewController: GuideViewControllerInterface {

    func setLoading(_ loading: Bool) {
        loadingView.animateHidden(!loading)
    }

    func updateHeader(greeting: String, message: String, image: URL?) {
        greetingImageURL = image
        greetingView.configure(message: message, greeting: greeting, userImage: image)
        syncHeaderView(imageURL: image)
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
        tableView.tableHeaderView = greetingView
        tableView.estimatedRowHeight = 300
        let backgroundImageView = UIImageView(image: R.image._1_1Learn())
        view.addSubview(fadeContainerView)
        fadeContainerView.addSubview(backgroundImageView)
        fadeContainerView.addSubview(tableView)
        fadeContainerView.addSubview(loadingView)
		if #available(iOS 11.0, *) {
			tableView.edgeAnchors == fadeContainerView.edgeAnchors
		} else {
			tableView.topAnchor == view.topAnchor + Layout.statusBarHeight
			tableView.leadingAnchor == view.leadingAnchor
			tableView.trailingAnchor == view.trailingAnchor
			tableView.bottomAnchor == view.bottomAnchor - Layout.statusBarHeight
		}
		fadeContainerView.verticalAnchors == view.verticalAnchors
		fadeContainerView.horizontalAnchors == view.horizontalAnchors
		backgroundImageView.edgeAnchors == fadeContainerView.edgeAnchors
		loadingView.edgeAnchors == fadeContainerView.edgeAnchors
        fadeContainerView.setFade(top: view.frame.height * 0.15, bottom: view.frame.height * 0.15)
        view.layoutIfNeeded()
        syncHeaderView(imageURL: greetingImageURL)
    }

    func syncHeaderView(imageURL: URL?) {
        let header = greetingView
        header.bounds = CGRect(x: 0,
                               y: 0,
                               width: Int(tableView.contentSize.width),
                               height: Int(view.frame.height * 0.35))
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
            cell.configure(title: title,
                           body: body,
                           image: image,
                           status: item.status)
            return cell
        case .toBeVision(let title, let body, let image):
            let cell: GuideToBeVisionTableViewCell = tableView.dequeueCell(for: indexPath)
            // FIXME:
            cell.configure(title: title,
                           body: body,
                           status: item.status,
                           image: image)
            return cell
        case .dailyPrep(let items, let feedback):
            let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
			cell.delegate = self
			cell.itemTapped = itemAt(indexPath: indexPath)
            cell.configure(type: item.subtitle,
                           dailyPrepFeedback: feedback,
                           dailyPrepItems: items,
                           status: item.status)
            return cell
        case .learningPlan(let value, let strategiesCompleted):
            let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: item.title,
                           content: value,
                           type: item.subtitle,
                           status: item.status,
                           strategiesCompleted: strategiesCompleted)
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
}
