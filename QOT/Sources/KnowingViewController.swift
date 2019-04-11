//
//  KnowingViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class KnowingViewController: HomeViewController {

    // MARK: - Properties

    var interactor: KnowingInteractorInterface?
    weak var delegate: CoachPageViewControllerDelegate?
    private let headerViewID = "ComponentHeaderView"

    // MARK: - Init

    init(configure: Configurator<KnowingViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension KnowingViewController {

}

// MARK: - Actions

private extension KnowingViewController {

}

// MARK: - KnowingViewControllerInterface

extension KnowingViewController: KnowingViewControllerInterface {
    func setupView() {
        view.addFadeView(at: .bottom, height: 120, primaryColor: .carbonDark)
        view.backgroundColor = .carbonDark
        collectionView.backgroundColor = .carbonDark
        collectionView.registerDequeueable(WhatsHotCollectionViewCell.self)
        collectionView.registerDequeueable(StrategyCategoryCollectionViewCell.self)
        collectionView.registerDequeueable(StrategyFoundationCollectionViewCell.self)
        collectionView.register(R.nib.componentHeaderView(),
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: headerViewID)
    }
}

extension KnowingViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Knowing.Section.allCases.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == Knowing.Section.strategies.rawValue {
            return interactor?.strategies().count ?? 0
        }
        return interactor?.whatsHotArticles().count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == Knowing.Section.strategies.rawValue {
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
        }
        let cell: WhatsHotCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        let whatsHotArticle = interactor?.whatsHotArticles()[indexPath.item]
        cell.configure(title: whatsHotArticle?.title,
                       publishDate: whatsHotArticle?.publishDate,
                       author: whatsHotArticle?.author,
                       timeToRead: whatsHotArticle?.timeToRead,
                       imageURL: whatsHotArticle?.image,
                       isNew: whatsHotArticle?.isNew ?? false)
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == Knowing.Section.strategies.rawValue {
            if indexPath.item == 0 {
                return CGSize(width: view.frame.width, height: 80)
            }
            return CGSize(width: view.frame.width * 0.5, height: 96)
        }
        return CGSize(width: view.frame.width, height: 214)
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize(width: view.frame.width, height: 155)
        }
        return CGSize(width: view.frame.width, height: 125)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: headerViewID,
                                                                             for: indexPath as IndexPath) as? ComponentHeaderView
            if indexPath.section == Knowing.Section.strategies.rawValue {
                let header = interactor?.header(for: Knowing.Section.strategies)
                headerView?.configure(title: header?.title, subtitle: header?.subtitle)
                headerView?.backgroundColor = .clear
            } else {
                let header = interactor?.header(for: Knowing.Section.whatsHot)
                headerView?.configure(title: header?.title, subtitle: header?.subtitle)
                headerView?.backgroundColor = .carbon
            }
            return headerView ?? UICollectionReusableView()
        default:
            assert(false, "Unexpected element kind")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Knowing.Section.strategies.rawValue {

        } else {
            let whatsHotArticle = interactor?.whatsHotArticles()[indexPath.item]
            AppDelegate.current.appCoordinator.presentWhatsHotArticle(with: whatsHotArticle?.remoteID ?? 0)
        }
    }
}
