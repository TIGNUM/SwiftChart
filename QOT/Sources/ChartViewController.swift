//
//  ChartViewController.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ReactiveKit

protocol ChartViewControllerDelegate: class {
    func didSelectAddSensor()
    func didSelectOpenSettings()
    func didTapInfoView(pageName: PageName?)
}

final class ChartViewController: UIViewController, FullScreenLoadable, PageViewControllerNotSwipeable {

    // MARK: - Properties

    private let topPadding: CGFloat = 20
    private let viewModel: ChartViewModel
    private var pageControls = [PageControl]()
    private let headerHeight: CGFloat = 20
    private let footerHeight: CGFloat = 30
    private let disposeBag = DisposeBag()
    var infoPageName: PageName?
    var loadingView: BlurLoadingView?
    var isLoading: Bool = false {
        didSet {
            showLoading(isLoading, text: R.string.localized.loadingData())
        }
    }

    private lazy var tableView: UITableView = {
        return UITableView(style: .grouped,
                           contentInsets: .zero,
                           delegate: self,
                           dataSource: self,
                           dequeables: ChartTableViewCell.self)
    }()

    // MARK: - Init

    init(viewModel: ChartViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        createPageControls()
        observeViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        chartViews.keys.forEach { chartViews[$0] = nil }
        tableView.reloadData()
        infoPageName = nil
        updateReadyState()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureContentInset(inset: UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0), scrollView: tableView)
    }

    @available(iOS 11.0, *)
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        configureContentInset(inset: UIEdgeInsets(top: topPadding, left: 0, bottom: 0, right: 0), scrollView: tableView)
    }
}

// MARK: - Private

private extension ChartViewController {

    func updateReadyState() {
        isLoading = !viewModel.isReady()
    }

    func observeViewModel() {
//        viewModel.updates.observeNext { [unowned self] (update) in
//            switch update {
//            case .reload, .update:
//                self.createPageControls()
//                self.tableView.reloadData()
//                self.updateReadyState()
//            }
//        }.dispose(in: disposeBag)
    }

    func setupView() {
        view.addSubview(tableView)
        tableView.edgeAnchors == view.edgeAnchors
    }

    func createPageControls() {
        for (index, sectionType) in viewModel.sortedSections.enumerated() {
            let pageControl = PageControl(frame: .zero)
            pageControl.numberOfPages = viewModel.numberOfItems(in: index)
            pageControl.currentPage = 0
            pageControl.isUserInteractionEnabled = false
            pageControl.size(forNumberOfPages: sectionType.chartTypes.count)
            pageControls.append(pageControl)
        }
    }

    func cellHeight() -> CGFloat {
        return ((view.frame.width - ChartViewModel.chartViewPadding) * ChartViewModel.chartRatio) +
            ChartViewModel.chartCellOffset
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.isReady() ? viewModel.numberOfSections : 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let leadingOffset = ChartViewModel.leadingOffset(frameWidth: tableView.bounds.width)
        let view = UIView(frame: CGRect(x: leadingOffset + 11, y: 0, width: tableView.bounds.width, height: headerHeight))
        let label = UILabel(frame: view.frame)
        let headline = viewModel.sectionTitle(in: section).uppercased()
        view.addSubview(label)
        label.attributedText = Style.subTitle(headline).attributedString()
        return view
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: -3, width: tableView.bounds.width, height: 10))
        let pageControl = pageControls[section]
        pageControl.frame = view.frame
        view.addSubview(pageControl)
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ChartTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.setup(viewModel: viewModel,
                   currentSection: indexPath.section,
                   screenType: screenType,
                   pageControl: pageControls[indexPath.section])
        cell.delegate = self
        return cell
    }
}

// MARK: - StatisticsViewControllerDelegate

extension ChartViewController: ChartViewControllerDelegate {
    func didTapInfoView(pageName: PageName?) {
        if pageName == .tabBarItemData {
            infoPageName = nil
        } else {
            infoPageName = pageName
            viewModel.pageTracker.track(self)
        }
    }

    func didSelectAddSensor() {
        AppDelegate.current.appCoordinator.presentAddSensor(from: self)
    }

    func didSelectOpenSettings() {
        UIApplication.openAppSettings()
    }
}

// MARK: - UIScrollViewDelegate

extension ChartViewController: UIScrollViewDelegate {

    private func centerTableView() {
        guard let pathForCenterCell = tableView.indexPathForRow(at: CGPoint(x: tableView.bounds.midX,
                                                                            y: tableView.bounds.midY)) else { return }
        tableView.scrollToRow(at: pathForCenterCell, at: .middle, animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let targetPage = max(0, round(page(offset: targetContentOffset.pointee)))
        let y = (targetPage * pageHeight()) - tableView.contentInset.top
        targetContentOffset.pointee.y = y
    }

    func page(offset: CGPoint) -> CGFloat {
        return (offset.y + tableView.contentInset.top) / pageHeight()
    }

    private func pageHeight() -> CGFloat {
        return cellHeight() + headerHeight + footerHeight
    }
}
