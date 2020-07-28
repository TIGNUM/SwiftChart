//
//  MyQotMainViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyQotNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(MyQotNavigationController.classForCoder())
}

final class MyQotMainViewController: BaseViewController, ScreenZLevelBottom {

    // MARK: - Properties
    var interactor: MyQotMainInteractorInterface!
    weak var delegate: CoachCollectionViewControllerDelegate?
    private var indexPathDeselect: IndexPath?
    private var isDragging = false
    private var teamHeader: HorizontalHeaderView?
    @IBOutlet private weak var collectionView: UICollectionView!

    private lazy var headerSize: CGSize = {
        return CGSize(width: collectionView.updatedCollectionViewHeaderWidth(),
                      height: ThemeView.level1.headerBarHeight)
    }()

    private lazy var teamHeaderSize: CGSize = {
        return CGSize(width: collectionView.updatedCollectionViewHeaderWidth(),
                      height: .TeamHeader)
    }()

    private lazy var qotBoxSize: CGSize = {
        let widthAvailbleForAllItems = collectionView.updatedCollectionViewItemWidth()
        let widthForOneItem = widthAvailbleForAllItems / 2
        let heightAvailableForAllItems = collectionView.updatedCollectionViewHeight()
        let heightForOneItem = heightAvailableForAllItems / 3
        return CGSize(width: widthForOneItem, height: heightForOneItem)
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showPendingInvites),
                                               name: .didSelectTeamInvite,
                                               object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(color: .carbon)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()

        if let indexPath = indexPathDeselect {
            collectionView.deselectItem(at: indexPath, animated: true)
            indexPathDeselect = nil
        }
    }

    @objc func showPendingInvites() {
        interactor.presentTeamPendingInvites()
    }
}

// MARK: - MyQotMainViewControllerInterface
extension MyQotMainViewController: MyQotMainViewControllerInterface {
    func setupView() {
        ThemeView.level1.apply(view)
        ThemeView.level1.apply(collectionView)
        navigationController?.navigationBar.isHidden = true
        collectionView.registerDequeueable(MyQotMainCollectionViewCell.self)
        collectionView.registerDequeueable(NavBarCollectionViewCell.self)
        collectionView.registerDequeueable(HorizontalHeaderCollectionViewCell.self)

        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 0, left: 24, bottom: 0, right: 24)
        layout.sectionHeadersPinToVisibleBounds = true
    }

    func reload() {
        collectionView.reloadData()
    }

    func getNavigationHeaderCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NavBarCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(title: AppTextService.get(.my_qot_section_header_title),
                       tapLeft: { self.delegate?.moveToCell(item: 1) },
                       tapRight: { self.interactor.presentMyProfile() })
        interactor.getSettingsButtonTitle { (title) in
            cell.setSettingsButton(title)
        }
        return cell
    }

    func getTeamHeaderCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HorizontalHeaderCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        interactor.updateTeamHeaderItems { (items) in
            cell.configure(headerItems: items)
        }
        return cell
    }

    func getCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let item = interactor.getItem(at: indexPath)
        let cell: MyQotMainCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        item?.subtitle { (subtitle) in
            cell.configure(title: item?.title, subtitle: subtitle)
        }
        interactor.isCellEnabled(for: item) { (enabled) in
            cell.setEnabled(enabled)
        }
        return cell
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension MyQotMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return interactor.sectionCount
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor.itemCount(in: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0: return getNavigationHeaderCell(collectionView, indexPath)
        case 1: return getTeamHeaderCell(collectionView, indexPath)
        default: return getCell(collectionView, indexPath)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0: return headerSize
        case 1: return teamHeaderSize
        default: return qotBoxSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathDeselect = indexPath
        interactor.handleSelection(at: indexPath)
    }
}

// MARK: - UIScrollViewDelegate
extension MyQotMainViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? NavBarCollectionViewCell {
            cell.updateAlpha(basedOn: scrollView.contentOffset.y)
        }
        delegate?.handlePan(offsetY: scrollView.contentOffset.y,
                            isDragging: isDragging,
                            isScrolling: scrollView.isDragging || scrollView.isDecelerating)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        isDragging = false
        scrollViewDidScroll(scrollView)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidScroll(scrollView)
    }
}
