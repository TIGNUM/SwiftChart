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
    private let sectionHeaderHeight: CGFloat = 24
    private let fadeMaskLocation: UIView.FadeMaskLocation
    private let disposeBag = DisposeBag()
    var loadingView: BlurLoadingView?

    var isLoading: Bool = false {
        didSet {
            showLoading(isLoading, text: R.string.localized.guideLoading())
        }
    }

    private var greetingView = GuideGreetingView.instantiateFromNib()

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

        viewModel.reload()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        updateReadyState()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sizeHeaderViewToFit()
    }
}

// MARK: - Private

private extension GuideViewController {

    func sizeHeaderViewToFit() {
        let header = greetingView
        header.bounds = CGRect(x: 0, y: 0, width: tableView.contentSize.width, height: 1000)
        header.setNeedsLayout()
        header.layoutIfNeeded()

        let height = header.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        var frame = header.frame
        frame.size.height = height
        header.frame = frame

        tableView.tableHeaderView = header
    }

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
        tableView.tableHeaderView = greetingView
        greetingView.backgroundColor = .clear
        updateGreetingView(viewModel.message, viewModel.greeting())

        let backgroundImageView = UIImageView(image: R.image._1_1Learn())
        view.addSubview(backgroundImageView)
        view.addSubview(tableView)

        if #available(iOS 11.0, *) {

        } else {
            // FIXME: We need to find a way to handle this across the app in a sane mannor
            tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 80, right: 0)
        }

        tableView.edgeAnchors == view.edgeAnchors
        backgroundImageView.edgeAnchors == view.edgeAnchors
        view.addFadeView(at: .top)
        view.addFadeView(at: .bottom, height: 120)
        view.layoutIfNeeded()
    }

    func updateGreetingView(_ message: String, _ greeting: String) {
        greetingView.configure(message, greeting)
        sizeHeaderViewToFit()
    }

    func open(item: Guide.Item) {
        guard let linkURL = item.link else { return }
        AppDelegate.current.launchHandler.process(url: linkURL, notificationID: item.identifier, guideItem: item)
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
        let dateCreated = DateFormatter.mediumDate.string(from: viewModel.header(section: section))
        let headline = String(format: "%@", dateCreated)
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
        let item = viewModel.item(indexPath: indexPath)
        guard item.isDailyPrepCompleted == false else { return }
        open(item: item)

        if item.isDailyPrep == false {
            viewModel.setCompleted(item: item) {}
        }
    }
}
