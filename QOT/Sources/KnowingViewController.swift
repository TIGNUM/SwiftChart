//
//  KnowingViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class KnowingNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(KnowingNavigationController.classForCoder())
}

final class KnowingViewController: HomeViewController {

    // MARK: - Properties

    private var indexPathDeselect: IndexPath?
    var interactor: KnowingInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?
    private let headerViewID = "ComponentHeaderView"

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
        self.showLoadingSkeleton(with: [.fiveLinesWithTopBroad, .twoLinesAndTag, .threeLinesAndTwoColumns, .threeLinesAndTwoColumns, .threeLinesLeftColumn])
        ThemeView.level1.apply(self.view)

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setStatusBar(colorMode: ColorMode.dark)
        setStatusBar(color: ThemeView.level1.color)
        interactor?.loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackPage()
        if let indexPath = indexPathDeselect {
            collectionView.deselectItem(at: indexPath, animated: true)
            indexPathDeselect = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? StrategyListViewController {
            StrategyListConfigurator.configure(viewController: controller, selectedStrategyID: sender as? Int)
        } else if
            let controller = (segue.destination as? UINavigationController)?.viewControllers.first as? ArticleViewController,
            let selectedID = sender as? Int {
                ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
        }
    }
}

// MARK: - Private

private extension KnowingViewController {}

// MARK: - KnowingViewControllerInterface

extension KnowingViewController: KnowingViewControllerInterface {
    func scrollToSection(_ section: Int) {}

    func setupView() {
        navigationController?.navigationBar.isHidden = true
        ThemeView.level1.apply(view)
        collectionView.backgroundColor = .clear
        collectionView.registerDequeueable(NavBarCollectionViewCell.self)
        collectionView.registerDequeueable(WhatsHotCollectionViewCell.self)
        collectionView.registerDequeueable(StrategyCategoryCollectionViewCell.self)
        collectionView.registerDequeueable(StrategyFoundationCollectionViewCell.self)
        collectionView.register(UINib(resource: R.nib.componentHeaderView),
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerViewID)
    }

    func reload() {
        self.removeLoadingSkeleton()
        collectionView.reloadData()
    }
}

extension KnowingViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Knowing.Section.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Knowing.Section.header.rawValue:
            return 1
        case Knowing.Section.strategies.rawValue:
            return interactor?.strategies().count ?? 0
        default:
            return interactor?.whatsHotArticles().count ?? 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Knowing.Section.header.rawValue:
            let cell: NavBarCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let title = R.string.localized.knowTitle()
            cell.configure(title: title, tapRight: { [weak self] in
                self?.delegate?.moveToCell(item: 1)
            })
            return cell
        case Knowing.Section.strategies.rawValue:
            if indexPath.item == 0 {
                let cell: StrategyFoundationCollectionViewCell = collectionView.dequeueCell(for: indexPath)
                let strategy = interactor?.foundationStrategy()
                cell.configure(categoryTitle: strategy?.title ?? "",
                               viewCount: strategy?.viewedCount ?? 0,
                               itemCount: strategy?.itemCount ?? 0)
                return cell
            } else {
                let cell: StrategyCategoryCollectionViewCell = collectionView.dequeueCell(for: indexPath)
                let strategy = interactor?.fiftyFiveStrategies()[indexPath.item - 1]
                cell.configure(categoryTitle: strategy?.title ?? "",
                               viewCount: strategy?.viewedCount ?? 0,
                               itemCount: strategy?.itemCount ?? 0)
                return cell
            }
        default:
            let cell: WhatsHotCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let whatsHotArticle = interactor?.whatsHotArticles()[indexPath.item]
            cell.configure(title: whatsHotArticle?.title,
                           publishDate: whatsHotArticle?.publishDate,
                           author: whatsHotArticle?.author,
                           timeToRead: whatsHotArticle?.timeToRead,
                           imageURL: whatsHotArticle?.image,
                           isNew: whatsHotArticle?.isNew ?? false,
                           forcedColorMode: .dark)
            return cell
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case Knowing.Section.header.rawValue:
            return CGSize(width: view.frame.width, height: ThemeView.level1.headerBarHeight)
        case Knowing.Section.strategies.rawValue:
            if indexPath.item == 0 {
                return CGSize(width: view.frame.width, height: 96)
            } else {
                return CGSize(width: view.frame.width * 0.5, height: 96)
            }
        default:
            return CGSize(width: view.frame.width, height: 214)
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case Knowing.Section.header.rawValue:
            return CGSize(width: view.frame.width, height: 0)
        default:
            if let componentHeader = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, at: IndexPath(row: 0, section: section)) as? ComponentHeaderView,
            let sectionType = Knowing.Section(rawValue: section),
            let header = interactor?.header(for: sectionType) {
                componentHeader.configure(title: header.title, subtitle: header.subtitle, secondary: true)
                return CGSize(width: view.frame.width, height: componentHeader.calculateHeight(for: self.collectionView.frame.size.width))
            }
            return CGSize(width: view.frame.width, height: 155)
        }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            switch indexPath.section {
            case Knowing.Section.header.rawValue:
                break
            case Knowing.Section.strategies.rawValue:
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                    withReuseIdentifier: headerViewID,
                                                                                    for: indexPath as IndexPath) as? ComponentHeaderView {
                    let header = interactor?.header(for: Knowing.Section.strategies)
                    headerView.configure(title: header?.title, subtitle: header?.subtitle, secondary: false)
                    return headerView
                }
            default:
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                    withReuseIdentifier: headerViewID,
                                                                                    for: indexPath as IndexPath) as? ComponentHeaderView {
                    let header = interactor?.header(for: Knowing.Section.whatsHot)
                    headerView.configure(title: header?.title, subtitle: header?.subtitle, secondary: true)
                    return headerView
                }
            }
        default:
            break
        }
        return UICollectionReusableView()
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathDeselect = indexPath
        switch indexPath.section {
        case Knowing.Section.header.rawValue:
            break
        case Knowing.Section.strategies.rawValue:
            if indexPath.item == 0 {
                let foundation = interactor?.foundationStrategy()
                trackUserEvent(.SELECT, value: foundation?.remoteID, valueType: .CONTENT, action: .TAP)
                interactor?.presentStrategyList(selectedStrategyID: nil)
            } else {
                let strategy = interactor?.fiftyFiveStrategies()[indexPath.item - 1]
                trackUserEvent(.SELECT, value: strategy?.remoteID, valueType: .CONTENT, action: .TAP)
                interactor?.presentStrategyList(selectedStrategyID: strategy?.remoteID)
            }
        default:
            let whatsHotArticle = interactor?.whatsHotArticles()[indexPath.item]
            trackUserEvent(.OPEN, value: whatsHotArticle?.remoteID ?? 0, valueType: .CONTENT, action: .TAP)
            interactor?.presentWhatsHotArticle(selectedID: whatsHotArticle?.remoteID ?? 0)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? NavBarCollectionViewCell {
            cell.updateAlpha(basedOn: scrollView.contentOffset.y)
        }
        delegate?.handlePan(offsetY: scrollView.contentOffset.y)
    }
}
