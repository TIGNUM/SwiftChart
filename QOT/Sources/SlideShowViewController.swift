//
//  SlideShowViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 12.12.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import Diff

final class SlideShowViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var doneButton: UIButton!
    private var pages: [SlideShow.Page] = []

    var interactor: SlideShowInteractorInterface!

    init(configure: Configurator<SlideShowViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()

        collectionView.registerDequeueable(SlideShowSlideCell.self)
        collectionView.registerDequeueable(SlideShowPromptCell.self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func didTapDoneButton() {
        interactor.didTapDone()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension SlideShowViewController: SlideShowViewControllerInterface {

    func setPages(_ pages: [SlideShow.Page]) {
        setPagesAndSyncControls(pages: pages)
        collectionView.reloadData()
    }

    func updatePages(_ pages: [SlideShow.Page]) {
        let oldPages = self.pages
        setPagesAndSyncControls(pages: pages)
        collectionView.animateItemChanges(oldData: oldPages, newData: pages)
    }
}

extension SlideShowViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let page = pages[indexPath.item]
        switch page {
        case .slide(let title, let subtitle, let imageName):
            let cell: SlideShowSlideCell = collectionView.dequeueCell(for: indexPath)
            cell.configure(title: title, subtitle: subtitle, imageName: imageName)
            return cell
        case .prompt(let title, let showMoreButton):
            let cell: SlideShowPromptCell = collectionView.dequeueCell(for: indexPath)
            let startHandler = { [unowned self] in
                self.didTapStartButton()
            }
            let moreHandler = { [unowned self] in
                self.didTapMoreButton()
            }
            cell.configure(title: title, startHandler: startHandler, moreHandler: showMoreButton ? moreHandler : nil)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        syncControlsForCurrentPage()
    }
}

private extension SlideShowViewController {

    func setPagesAndSyncControls(pages: [SlideShow.Page]) {
        self.pages = pages
        pageControl.numberOfPages = pages.count
        syncControlsForCurrentPage()
    }

    func didTapStartButton() {
        interactor.didTapDone()
    }

    func didTapMoreButton() {
        interactor.didTapLoadMore()
    }

    func syncControlsForCurrentPage() {
        let index = currentPageIndex()
        syncPageControl(page: index)
        syncDoneButton(page: index)
    }

    func syncPageControl(page: Int) {
        pageControl.currentPage = page
    }

    func syncDoneButton(page: Int) {
        let isLastPage = pageControl.numberOfPages == page + 1
        let title = isLastPage ? "Start" : "Skip"
        doneButton.setTitle(title, for: .normal)
    }

    func currentPageIndex() -> Int {
        guard pages.count > 0 else { return 0 }

        let pageWidth = collectionView.frame.size.width
        let centerOffsetX = collectionView.contentOffset.x + (pageWidth / 2)
        let page = Int(centerOffsetX / pageWidth)
        return page.constrainedTo(min: 0, max: pages.count - 1)
    }
}
