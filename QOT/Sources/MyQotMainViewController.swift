//
//  MyQotMainViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 11.06.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal
import DifferenceKit

final class MyQotNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(MyQotNavigationController.classForCoder())
}

final class MyQotMainViewController: BaseViewController, ScreenZLevelBottom {

    // MARK: - Properties
    var interactor: MyQotMainInteractorInterface!
    weak var delegate: CoachCollectionViewControllerDelegate?
    @IBOutlet private weak var collectionView: UICollectionView!
    private var indexPathDeselect: IndexPath?
    private var isDragging = false
    private var teamHeaderItems = [TeamHeader]()

    private lazy var qotBoxSize: CGSize = {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return .zero }

        let widthAvailbleForAllItems = (
            collectionView.frame.width
            - layout.minimumInteritemSpacing
            - layout.sectionInset.left
            - layout.sectionInset.right)
        let widthForOneItem = widthAvailbleForAllItems / 2
        let heightAvailableForAllItems = (
            collectionView.frame.height
                - (layout.minimumLineSpacing + layout.sectionInset.top + layout.sectionInset.bottom) * 2
                - ThemeView.level1.headerBarHeight)
        let heightForOneItem = heightAvailableForAllItems / 3

        return CGSize(width: widthForOneItem, height: heightForOneItem)
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level1.color)
        interactor.refreshParams()
        collectionView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()

        if let indexPath = indexPathDeselect {
            collectionView.deselectItem(at: indexPath, animated: true)
            indexPathDeselect = nil
        }
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
    }

    func updateViewNew(_ differenceList: StagedChangeset<IndexPathArray>) {
        collectionView.reload(using: differenceList) { [weak self] (data) in
            self?.interactor.updateViewModelListNew(data)
        }
    }

    func updateTeamHeader(teamHeaderItems: [TeamHeader]) {
        self.teamHeaderItems = teamHeaderItems
        collectionView.reloadData()
    }

    func getNavigationHeaderCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        let cell: NavBarCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        interactor.getSettingsTitle {
            cell.setSettingsButton($0 ?? "")
            cell.configure(title: AppTextService.get(.my_qot_section_header_title),
                           tapLeft: { self.delegate?.moveToCell(item: 1) },
                           tapRight: { self.interactor.presentMyProfile() })
        }
        return cell
    }

    func getTeamHeaderCell(_ collectionView: UICollectionView, _ indexPath: IndexPath) -> UICollectionViewCell {
        return getNavigationHeaderCell(collectionView, indexPath)
    }

    func getCell(_ collectionView: UICollectionView,
                 _ indexPath: IndexPath,
                 _ myQotItem: MyQot.Item?) -> UICollectionViewCell {
        let cell: MyQotMainCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        interactor.isCellEnabled(for: myQotItem?.sections) { (enabled) in
            cell.configure(title: myQotItem?.title, subtitle: myQotItem?.subtitle, enabled: enabled)
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
        switch MyQot.Section(rawValue: indexPath.section) {
        case .navigationHeader:
            return getNavigationHeaderCell(collectionView, indexPath)
        case .teamHeader:
            return getTeamHeaderCell(collectionView, indexPath)
        default:
            return getCell(collectionView, indexPath, interactor.getItem(at: indexPath))
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch MyQot.Section(rawValue: indexPath.section) {
        case .navigationHeader,
             .teamHeader:
            return CGSize(width: view.frame.width, height: ThemeView.level1.headerBarHeight)
        default:
            return qotBoxSize
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
