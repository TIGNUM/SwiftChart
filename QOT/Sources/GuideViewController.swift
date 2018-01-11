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

final class GuideViewController: UIViewController, FullScreenLoadable, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let viewModel: GuideViewModel
    private let sectionHeaderHeight: CGFloat = 44
    private var greetingViewHeightAnchor: NSLayoutConstraint?
    private let fadeMaskLocation: UIView.FadeMaskLocation
    private let disposeBag = DisposeBag()
    var loadingView: BlurLoadingView?
    var isLoading: Bool = false {
        didSet {
            showLoading(isLoading, text: R.string.localized.guideLoading())
        }
    }

    private lazy var greetingView: GuideGreetingView? = {
        return Bundle.main.loadNibNamed("GuideGreetingView", owner: self, options: [:])?.first as? GuideGreetingView
    }()

    private lazy var tableView: UITableView = {
        return UITableView(contentInsets: UIEdgeInsets(top: -8, left: 0, bottom: 0, right: 0),
                           estimatedRowHeight: 100,
                           delegate: self,
                           dataSource: self,
                           dequeables: GuideTableViewCell.self,
                                       GuideDailyPrepTableViewCell.self)
    }()

    // MARK: - Init

    init(viewModel: GuideViewModel, fadeMaskLocation: UIView.FadeMaskLocation) {
        self.viewModel = viewModel
        self.fadeMaskLocation = fadeMaskLocation

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

        viewModel.createTodaysGuideIfNeeded()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateReadyState()
    }
}

// MARK: - Private

private extension GuideViewController {

    func updateReadyState() {
        isLoading = !viewModel.isReady
    }

    func reload() {
        tableView.reloadData()
        updateReadyState()
        updateGreetingView(viewModel.message, viewModel.greeting())
    }

    func observeViewModel() {
        viewModel.updates.observeNext { [unowned self] sectionCount in
            self.reload()
        }.dispose(in: disposeBag)
    }

    func setupView() {
        guard let greetingView = self.greetingView else { return }
        updateGreetingView(viewModel.message, viewModel.greeting())
        view.addSubview(greetingView)
        view.addSubview(tableView)
        greetingView.topAnchor == view.topAnchor + UIApplication.shared.statusBarFrame.height
        greetingView.leadingAnchor == view.leadingAnchor
        greetingView.trailingAnchor == view.trailingAnchor
        greetingViewHeightAnchor = greetingView.heightAnchor >= view.heightAnchor * 0.1
        tableView.topAnchor == greetingView.bottomAnchor
        tableView.leadingAnchor == view.leadingAnchor
        tableView.trailingAnchor == view.trailingAnchor
        tableView.bottomAnchor == view.bottomAnchor
        tableView.backgroundColor = .pineGreen
        view.setFadeMask(at: fadeMaskLocation)
        view.layoutIfNeeded()
    }

    func updateGreetingView(_ message: String, _ greeting: String) {
        greetingView?.configure(message, greeting)
    }

    func open(item: Guide.Item) {
        guard let linkURL = item.link.url else { return }
        AppDelegate.current.launchHandler.process(url: linkURL, notificationID: item.notificationID, guideItem: item)
    }

    func dailyPrepTableViewCell(item: Guide.Item, indexPath: IndexPath) -> GuideDailyPrepTableViewCell {
        let cell: GuideDailyPrepTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: item.title,
                       type: item.subtitle,
                       dailyPrep: item.dailyPrep,
                       status: item.status)
        return cell
    }

    func guideTableViewCell(item: Guide.Item, indexPath: IndexPath) -> GuideTableViewCell {
        let cell: GuideTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: item.title,
                       content: item.content.value,
                       type: item.subtitle,
                       status: item.status)
        return cell
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension GuideViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(section: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = viewModel.item(indexPath: indexPath)
        if item.isDailyPrep == true {
            return dailyPrepTableViewCell(item: item, indexPath: indexPath)
        }
        return guideTableViewCell(item: item, indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 30, y: 0, width: tableView.bounds.width, height: sectionHeaderHeight))
        let label = UILabel(frame: view.frame)
        let dateCreated = DateFormatter.mediumDate.string(from: viewModel.header(section: section))
        let headline = String(format: "%@", dateCreated)
        view.addSubview(label)
        view.backgroundColor = .pineGreen
        label.attributedText = Style.navigationTitle(headline, .white40).attributedString()
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = viewModel.item(indexPath: indexPath)
        guard item.isDailyPrepCompleted == false else { return }
        open(item: item)

        if item.isDailyPrep == false {
            viewModel.setCompleted(item: item) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
                self.updateGreetingView(self.viewModel.message, self.viewModel.greeting())
            }
        }
    }
}
