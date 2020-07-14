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
    private var teamHeaderItems = [TeamHeader]()
    private var qotBoxSize: CGSize {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return .zero
        }

        let widthAvailbleForAllItems =  (collectionView.frame.width - layout.minimumInteritemSpacing - layout.sectionInset.left - layout.sectionInset.right)
        let widthForOneItem = widthAvailbleForAllItems / 2
        let heightAvailableForAllItems = (collectionView.frame.height -
            (layout.minimumLineSpacing + layout.sectionInset.top + layout.sectionInset.bottom) * 2 -
            ThemeView.level1.headerBarHeight)
        let heightForOneItem = heightAvailableForAllItems / 3

        return CGSize(width: widthForOneItem, height: heightForOneItem)
    }

    private var isDragging = false

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        navigationController?.navigationBar.isHidden = true

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showPendingInvites),
                                               name: .didSelectTeam,
                                               object: nil)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level1.color)
        collectionView.reloadData()
        interactor.refreshParams()
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
        ThemeView.level1.apply(self.view)
        ThemeView.level1.apply(collectionView)
        collectionView.registerDequeueable(MyQotMainCollectionViewCell.self)
        collectionView.registerDequeueable(NavBarCollectionViewCell.self)

        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 16
        layout.sectionInset = .init(top: 0, left: 24, bottom: 0, right: 24)
    }

    func updateViewNew(_ differenceList: StagedChangeset<[ArraySection<MyQotViewModel.Section, MyQotViewModel.Item>]>) {
        collectionView.reload(using: differenceList) { [weak self] (data) in
            self?.interactor.updateViewModelListNew(data)
        }
    }

    func updateTeamHeader(teamHeaderItems: [TeamHeader]) {
        self.teamHeaderItems = teamHeaderItems
        collectionView.reloadData()
    }

    func getCell(_ collectionView: UICollectionView,
                 _ indexPath: IndexPath,
                 _ myQotViewModelItem: MyQotViewModel.Item?) -> UICollectionViewCell {
        switch MyQotViewModel.Section.allCases.at(index: indexPath.section) {
        case .header?:
            let cell: NavBarCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let title = AppTextService.get(.my_qot_section_header_title)
            interactor.getSettingsTitle(completion: { (title) in
                cell.setSettingsButton(title ?? "")
            })
            cell.configure(title: title, tapLeft: { [weak self] in
                self?.delegate?.moveToCell(item: 1)
            }) {
                self.interactor.presentMyProfile()
            }
            return cell
        default:
            let cell: MyQotMainCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            interactor.isCellEnabled(for: myQotViewModelItem?.myQotSections) { (enabled) in
                cell.configure(title: myQotViewModelItem?.title,
                               subtitle: myQotViewModelItem?.subtitle,
                               enabled: enabled)
            }
            return cell
        }
    }
}

extension MyQotMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return interactor.qotViewModelNew()?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch MyQotViewModel.Section.allCases.at(index: section) {
        case .header?:
            return 1
        default:
            return interactor.qotViewModelNew()?[section].elements.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = interactor.qotViewModelNew()?.at(index: indexPath.section)?.elements.at(index: indexPath.item)
        return getCell(collectionView, indexPath, model)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch MyQotViewModel.Section.allCases.at(index: indexPath.section) {
        case .header?:
            return CGSize(width: view.frame.width, height: ThemeView.level1.headerBarHeight)
        default:
            return qotBoxSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathDeselect = indexPath
        switch MyQotViewModel.Section.allCases.at(index: indexPath.section) {
        case .header?:
            return
        default:
            switch MyQotSection.allCases.at(index: indexPath.row) {
            case .teamCreate?:
                interactor.presentCreateTeam()
            case .library?:
                interactor.presentMyLibrary()
            case .preps?:
                interactor.presentMyPreps()
            case .sprints?:
                interactor.presentMySprints()
            case .data?:
                interactor.presentMyDataScreen()
            case .toBeVision?:
                interactor.presentMyToBeVision()
            default: return
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch MyQotViewModel.Section.allCases.at(index: section) {
        case .header?: return .zero
        default: return CGSize(width: view.frame.width, height: ThemeView.level1.headerBarHeight)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch MyQotViewModel.Section.allCases.at(index: indexPath.section) {
        case .header?:
            return UICollectionReusableView()
        default:
            let identifier = R.reuseIdentifier.reusableHeaderView_ID.identifier
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                         withReuseIdentifier: identifier,
                                                                         for: indexPath) as? ReusableHeaderView
            header?.configure(headerItems: teamHeaderItems)
            return header ?? UICollectionReusableView()
        }
    }

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
