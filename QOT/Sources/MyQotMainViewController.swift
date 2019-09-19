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

final class MyQotMainViewController: UIViewController, ScreenZLevelBottom {

    // MARK: - Properties

    var interactor: MyQotMainInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?
    @IBOutlet private weak var collectionView: UICollectionView!
    private var indexPathDeselect: IndexPath?

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

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level1.color)
        interactor?.refreshParams()
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
        if differenceList.count > 0 {
            self.removeLoadingSkeleton()
        }
        collectionView.reload(using: differenceList) { [weak self] (data) in
            self?.interactor?.updateViewModelListNew(data)
        }
    }

    func getCell(_ collectionView: UICollectionView,
                _ indexPath: IndexPath,
                _ myQotViewModelItem: MyQotViewModel.Item?) -> UICollectionViewCell {
            switch indexPath.section {
            case MyQotViewModel.Section.header.rawValue:
                let cell: NavBarCollectionViewCell = collectionView.dequeueCell(for: indexPath)
                let title = R.string.localized.myQOTTitle()
                cell.configure(title: title, tapLeft: { [weak self] in
                    self?.delegate?.moveToCell(item: 1)
                })
                return cell
            default:
                let cell: MyQotMainCollectionViewCell = collectionView.dequeueCell(for: indexPath)
                cell.configure(title: myQotViewModelItem?.title ?? "",
                               subtitle: myQotViewModelItem?.subtitle ?? "",
                               isRed: myQotViewModelItem?.showSubtitleInRed ?? false)
                return cell
            }
    }
}

extension MyQotMainViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return interactor?.qotViewModelNew()?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case MyQotViewModel.Section.header.rawValue:
            return 1
        default:
            return interactor?.qotViewModelNew()?[section].elements.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model: MyQotViewModel.Item?
        if let dataSource = interactor?.qotViewModelNew()?.at(index: indexPath.section)?.elements,
            dataSource.count > 0 {
            model = dataSource[indexPath.item]
            return getCell(collectionView, indexPath, model)
        }
        return getCell(collectionView, indexPath, nil)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case MyQotViewModel.Section.header.rawValue:
            return CGSize(width: view.frame.width, height: ThemeView.level1.headerBarHeight)
        default:
            return qotBoxSize
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathDeselect = indexPath
        switch indexPath.section {
        case MyQotViewModel.Section.header.rawValue:
            return
        default:
            let qotSection = MyQotSection.allCases[indexPath.row]
            switch qotSection {
            case .profile:
                interactor?.presentMyProfile()
            case .library:
                interactor?.presentMyLibrary()
            case .preps:
                interactor?.presentMyPreps()
            case .sprints:
                interactor?.presentMySprints()
            case .data:
                interactor?.presentMyDataScreen()
            case .toBeVision:
                interactor?.presentMyToBeVision()
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? NavBarCollectionViewCell {
            cell.updateAlpha(basedOn: scrollView.contentOffset.y)
        }
        delegate?.handlePan(offsetY: scrollView.contentOffset.y)
    }
}
