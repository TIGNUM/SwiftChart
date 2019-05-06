//
//  DailyBriefViewController.swift
//  QOT
//
//  Created by karmic on 14.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import Anchorage

final class DailyBriefNavigationController: UINavigationController {
    static var storyboardID = NSStringFromClass(DailyBriefNavigationController.classForCoder())
}

final class DailyBriefViewController: HomeViewController {

    // MARK: - Properties

    var interactor: DailyBriefInteractorInterface?
    weak var delegate: CoachPageViewControllerDelegate?
    private lazy var levelTwoViewController: LevelTwoViewController = {
        return LevelTwoViewController(configure: LevelTwoConfigurator.make(delegate: delegate))
    }()

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private

private extension DailyBriefViewController {

}

// MARK: - Actions

private extension DailyBriefViewController {

}

// MARK: - DailyBriefViewControllerInterface

extension DailyBriefViewController: DailyBriefViewControllerInterface {
    func setupView() {
        view.backgroundColor = .blue
    }

    func presentLevelTwo() {
        present(levelTwoViewController, animated: true, completion: nil)
    }
}

//extension DailyBriefViewController {
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return interactor?.whatsHotArticles().count ?? 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell: ComponentCollectionViewCell = collectionView.dequeueCell(for: indexPath)
//        let whatsHotArticle = interactor?.whatsHotArticles()[indexPath.item]
//        cell.configure(title: whatsHotArticle?.title ?? "",
//                       image: whatsHotArticle?.image,
//                       author: whatsHotArticle?.author ?? "",
//                       publishDate: whatsHotArticle?.publishDate,
//                       timeToRead: whatsHotArticle?.timeToRead)
//        return cell
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cardHorizontalOffset: CGFloat = 20
//        let cardHeightByWidthRatio: CGFloat = 1.2
//        let width = collectionView.bounds.size.width - 2 * cardHorizontalOffset
//        let height: CGFloat = width * cardHeightByWidthRatio
//        return CGSize(width: width, height: height)
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        super.collectionView(collectionView, didSelectItemAt: indexPath)
//    }
//}
