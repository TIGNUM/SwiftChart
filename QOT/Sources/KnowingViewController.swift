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

final class KnowingViewController: BaseViewController {

    // MARK: - Properties

    private var indexPathDeselect: IndexPath?
    var interactor: KnowingInteractorInterface?
    weak var delegate: CoachCollectionViewControllerDelegate?
    private let headerViewID = "ComponentHeaderView"
    lazy var collectionView: UICollectionView = {
        return UICollectionView(layout: UICollectionViewFlowLayout(),
                                delegate: self,
                                dataSource: self,
                                dequeables: ComponentCollectionViewCell.self)
    }()

    private var isDragging = false

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
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
            let controller = segue.destination as? ArticleViewController,
            let selectedID = sender as? Int {
                ArticleConfigurator.configure(selectedID: selectedID, viewController: controller)
        }
    }
}

// MARK: - Private

private extension KnowingViewController {
    func setupCollectionView() {
        view.fill(subview: collectionView)
        collectionView.delaysContentTouches = false
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = .zero
            layout.minimumInteritemSpacing = .zero
            layout.sectionInset = .zero
        }
        collectionView.clipsToBounds = false
    }
}

// MARK: - KnowingViewControllerInterface

extension KnowingViewController: KnowingViewControllerInterface {
    func scrollToSection(_ section: Int) {}

    func setupView() {
        navigationController?.navigationBar.isHidden = true
        ThemeView.level1.apply(view)
        setupCollectionView()
        collectionView.backgroundColor = .clear
        collectionView.registerDequeueable(NavBarCollectionViewCell.self)
        collectionView.registerDequeueable(WhatsHotCollectionViewCell.self)
        collectionView.registerDequeueable(StrategyCategoryCollectionViewCell.self)
        collectionView.register(UINib(resource: R.nib.componentHeaderView),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: headerViewID)
    }

    func reload() {
        collectionView.reloadData()
    }
}

extension KnowingViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Knowing.Section.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Knowing.Section.header.rawValue:
            return 1
        case Knowing.Section.strategies.rawValue:
            guard let strategies = interactor?.strategies().count, strategies > .zero else {
                return 6
            }
            return strategies
        default:
            guard let articles = interactor?.whatsHotArticles().count, articles > .zero else {
                return 15
            }
            return articles
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Knowing.Section.header.rawValue:
            let cell: NavBarCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let title = AppTextService.get(.know_section_header_title)
            cell.configure(title: title, tapRight: { [weak self] in
                self?.delegate?.scrollToPage(item: 1)
            })
            return cell
        case Knowing.Section.strategies.rawValue:
            let cell: StrategyCategoryCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            if indexPath.item == .zero {
                let strategy = interactor?.foundationStrategy()
                cell.configure(categoryTitle: strategy?.title,
                               viewCount: strategy?.viewedCount,
                               itemCount: strategy?.itemCount,
                               contentType: .video,
                               shouldShowSeparator: true)
                return cell
            } else {
                guard
                    interactor?.fiftyFiveStrategies().count ?? .zero > indexPath.item - 1,
                    let strategy = interactor?.fiftyFiveStrategies()[indexPath.item - 1] else {
                    cell.configure(categoryTitle: nil,
                                   viewCount: nil,
                                   itemCount: nil)
                    return cell
                }
                cell.configure(categoryTitle: strategy.title,
                               viewCount: strategy.viewedCount,
                               itemCount: strategy.itemCount)
                return cell
            }
        default:
            let cell: WhatsHotCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            let whatsHotArticle = interactor?.whatsHotArticles().at(index: indexPath.item)
            cell.configure(title: whatsHotArticle?.title,
                           publishDate: whatsHotArticle?.publishDate,
                           author: whatsHotArticle?.author,
                           timeToRead: whatsHotArticle?.timeToRead,
                           imageURL: whatsHotArticle?.image,
                           isNew: whatsHotArticle?.isNew,
                           forcedColorMode: .dark)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case Knowing.Section.header.rawValue:
            return CGSize(width: view.frame.width, height: .HeaderBarHeight)
        case Knowing.Section.strategies.rawValue:
            if indexPath.item == .zero {
                return CGSize(width: view.frame.width, height: 126)
            } else {
                return CGSize(width: view.frame.width * 0.5, height: 96)
            }
        default:
            guard let whatsHotArticle = interactor?.whatsHotArticles().at(index: indexPath.item) else {
                return CGSize(width: view.frame.width, height: 196)
            }
            let height = WhatsHotCollectionViewCell.height(title: whatsHotArticle.title,
                                                           publishDate: whatsHotArticle.publishDate,
                                                           author: whatsHotArticle.author,
                                                           timeToRead: whatsHotArticle.timeToRead,
                                                           forWidth: view.frame.width)
            return CGSize(width: view.frame.width, height: height)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case Knowing.Section.header.rawValue:
            return CGSize(width: view.frame.width, height: .zero)
        default:
            if let componentHeader = self.collectionView(collectionView,
                                                         viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader,
                                                         at: IndexPath(row: .zero, section: section)) as? ComponentHeaderView,
                let sectionType = Knowing.Section(rawValue: section),
                let header = interactor?.header(for: sectionType) {
                componentHeader.configure(title: header.title,
                                          subtitle: header.subtitle,
                                          showSeparatorView: section != .zero,
                                          secondary: true)
                return CGSize(width: view.frame.width, height: ComponentHeaderView.height(title: header.title ?? String.empty,
                                                                                          subtitle: header.subtitle ?? String.empty,
                                                                                          forWidth: view.frame.width))
            }
            return CGSize(width: view.frame.width, height: 155)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0, height: 0)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            switch indexPath.section {
            case Knowing.Section.header.rawValue:
                break
            case Knowing.Section.strategies.rawValue:
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                    withReuseIdentifier: headerViewID,
                                                                                    for: indexPath as IndexPath) as? ComponentHeaderView {
                    let header = interactor?.header(for: Knowing.Section.strategies)
                    headerView.configure(title: header?.title,
                                         subtitle: header?.subtitle,
                                         showSeparatorView: false,
                                         secondary: false)
                    return headerView
                }
            default:
                if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                    withReuseIdentifier: headerViewID,
                                                                                    for: indexPath as IndexPath) as? ComponentHeaderView {
                    let header = interactor?.header(for: Knowing.Section.whatsHot)
                    headerView.configure(title: header?.title,
                                         subtitle: header?.subtitle,
                                         showSeparatorView: true,
                                         secondary: true)
                    return headerView
                }
            }
        default:
            break
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPathDeselect = indexPath
        switch indexPath.section {
        case Knowing.Section.header.rawValue:
            break
        case Knowing.Section.strategies.rawValue:
            if indexPath.item == .zero {
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
            trackUserEvent(.OPEN, value: whatsHotArticle?.remoteID ?? .zero, valueType: .CONTENT, action: .TAP)
            interactor?.presentWhatsHotArticle(selectedID: whatsHotArticle?.remoteID ?? .zero)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let cell = collectionView.cellForItem(at: IndexPath(item: .zero, section: .zero)) as? NavBarCollectionViewCell {
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
