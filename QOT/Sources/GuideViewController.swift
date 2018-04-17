//
//  GuideViewController.swift
//  QOT
//
//  Created by karmic on 29.11.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import LoremIpsum
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
    var interactor: GuideInteractorInterface?
    var router: GuideRouterInterface?
    var isImageVisible: Bool = false

    private lazy var tableView: UITableView = {
        return UITableView(style: .plain,
                           contentInsets: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0),
                           estimatedRowHeight: 100,
                           delegate: self,
                           dataSource: self,
                           dequeables: GuideTableViewCell.self,
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

    func updateHeader(greeting: String, message: String, image: URL?) {
        isImageVisible = (image != nil)
        greetingView.configure(message: message, greeting: greeting, userImage: image)
        syncHeaderView()
    }

    func updateDays(days: [Guide.Day]) {
        self.days = days
        tableView.reloadData()
        updateTabBarBadge()
    }

    func updateTabBarBadge() {
        guard let today = days.first else { return }

        let incompletedItems = today.items.filter { $0.status == .todo && $0.affectsTabBarBadge == true }
        let showBadge = incompletedItems.count > 0
        UserDefault.newGuideItem.setBoolValue(value: showBadge)
    }
}

// MARK: - Private

private extension GuideViewController {

    func setupView() {
        tableView.tableHeaderView = greetingView

        let backgroundImageView = UIImageView(image: R.image._1_1Learn())
        view.addSubview(fadeContainerView)
        fadeContainerView.addSubview(backgroundImageView)
        fadeContainerView.addSubview(tableView)
        fadeContainerView.addSubview(loadingView)

        if #available(iOS 11.0, *) {

        } else {
            // FIXME: We need to find a way to handle this across the app in a sane mannor
            tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 80, right: 0)
        }

        fadeContainerView.verticalAnchors == view.verticalAnchors
        fadeContainerView.horizontalAnchors == view.horizontalAnchors
        tableView.edgeAnchors == fadeContainerView.edgeAnchors
        backgroundImageView.edgeAnchors == fadeContainerView.edgeAnchors
        loadingView.edgeAnchors == fadeContainerView.edgeAnchors

        fadeContainerView.setFade(top: 100, bottom: 85)
        view.layoutIfNeeded()
    }

    func syncHeaderView() {
        let header = greetingView
        let height = isImageVisible ? 230 : 130
        header.bounds = CGRect(x: 0, y: 0, width: Int(tableView.contentSize.width), height: height)
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
        case .dailyPrep(let items, let feedback):
            let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: item.title,
                           type: item.subtitle,
                           dailyPrepFeedback: feedback,
                           dailyPrepItems: items,
                           status: item.status)
            return cell
        case .text(let value):
            let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
            cell.configure(title: item.title, content: value, type: item.subtitle, status: item.status)
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

        router?.open(item: item)
        interactor?.didTapItem(item)
    }

    private func itemAt(indexPath: IndexPath) -> Guide.Item {
        return days[indexPath.section].items[indexPath.row]
    }
}
