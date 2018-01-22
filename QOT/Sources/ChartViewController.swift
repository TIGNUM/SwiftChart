//
//  ChartViewController.swift
//  QOT
//
//  Created by karmic on 11.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage

protocol ChartViewControllerDelegate: class {

    func didSelectAddSensor()

    func didSelectOpenSettings()
}

final class ChartViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ChartViewModel
    private var pageControls = [PageControl]()
    private let headerHeight: CGFloat = 20
    private let footerHeight: CGFloat = 30

    private lazy var tableView: UITableView = {
        return UITableView(style: .grouped,
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        chartViews.keys.forEach { chartViews[$0] = nil }
        tableView.reloadData()
    }
}

// MARK: - Private

private extension ChartViewController {

    func setupView() {
        view.addSubview(tableView)
        view.setFadeMask(at: .top)

        if #available(iOS 11.0, *) {
            tableView.edgeAnchors == view.edgeAnchors
        } else {
            tableView.topAnchor == view.topAnchor + Layout.statusBarHeight + Layout.paddingTop
            tableView.bottomAnchor == view.bottomAnchor
            tableView.leadingAnchor == view.leadingAnchor
            tableView.trailingAnchor == view.trailingAnchor
        }
    }

    func createPageControls() {
        viewModel.sortedSections.forEach { (sectionType: StatisticsSectionType) in
            let pageControl = PageControl(frame: .zero)
            pageControl.numberOfPages = sectionType.chartTypes.count
            pageControl.currentPage = 0
            pageControl.isUserInteractionEnabled = false
            pageControl.size(forNumberOfPages: sectionType.chartTypes.count)
            pageControls.append(pageControl)
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ChartViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((view.frame.width - ChartViewModel.chartViewPadding) * ChartViewModel.chartRatio) +
            ChartViewModel.chartCellOffset
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let leadingOffset = ChartViewModel.leadingOffset(frameWidth: tableView.bounds.width)
        let view = UIView(frame: CGRect(x: leadingOffset + 11, y: 0, width: tableView.bounds.width, height: headerHeight))
        let label = UILabel(frame: view.frame)
        let headline = viewModel.sectionTitle(in: section).uppercased()
        view.addSubview(label)
        label.attributedText = Style.subTitle(headline, .white).attributedString()

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

    func didSelectAddSensor() {
        AppDelegate.current.appCoordinator.presentAddSensorView(viewController: self)
    }

    func didSelectOpenSettings() {
        UIApplication.openAppSettings()
    }
}

// MARK: - UIScrollViewDelegate

extension ChartViewController: UIScrollViewDelegate {

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView.currentSection < pageControls.count else { return }
        let pageControl = pageControls[scrollView.currentSection]
        pageControl.numberOfPages = viewModel.numberOfItems(in: scrollView.currentSection)
    }

    private func centerTableView() {
        guard let pathForCenterCell = tableView.indexPathForRow(at: CGPoint(x: tableView.bounds.midX,
                                                                            y: tableView.bounds.midY)) else { return }
        tableView.scrollToRow(at: pathForCenterCell, at: .middle, animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        enum ScrollDirection {
            case up
            case stationary
            case down
        }
        let cellHeight = ChartViewModel.chartCellSize(frameWidth: view.frame.width).height + headerHeight + footerHeight
        let originalTargetPage = targetContentOffset.pointee.y / cellHeight
        let scrollDirection: ScrollDirection = (velocity.y < 0) ? .up : (velocity.y > 0) ? .down : .stationary
        let targetPage: Int
        switch scrollDirection {
        case .stationary: targetPage = Int(round(originalTargetPage))
        case .up: targetPage = Int(floor(originalTargetPage))
        case .down: targetPage = Int(ceil(originalTargetPage))
        }

        targetContentOffset.pointee.y = (CGFloat(targetPage) * cellHeight) - (tableView.contentInset.top + headerHeight)
    }
}

// MARK: - UIScrollView

private extension UIScrollView {

    var currentSection: Int {
        guard bounds.size.height > 0 else { return 0 }
        let section = Int(round(contentOffset.y / (bounds.size.height * 0.75)))

        return section >= 0 ? section : 0
    }
}
