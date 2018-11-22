//
//  TutorialViewController.swift
//  QOT
//
//  Created by karmic on 16.11.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

final class TutorialViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var endButton: UIButton!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var controlView: UIView!
    var interactor: TutorialInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<TutorialViewController>) {
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

private extension TutorialViewController {

    func setupView() {
        view.backgroundColor = .navy
        controlView.backgroundColor = .navy
    }

    func setupNavigationBar() {
        title = R.string.localized.topTabBarItemTitleTutorial()
        navigationController?.navigationBar.applyClearStyle()
    }

    func setupCollectionView() {
        collectionView.backgroundColor = .navy
        collectionView.registerDequeueable(TutorialCollectionViewCell.self)
        collectionView.reloadData()
    }

    func setupPageControl() {
        pageControl.numberOfPages = interactor?.numberOfSlides ?? 0
    }

    func setupEndButton(at index: Index) {
        endButton.setAttributedTitle(interactor?.attributedbuttonTitle(at: index), for: .normal)
    }

    func syncControlsForCurrentPage() {
        let index = currentPageIndex()
        pageControl.currentPage = index
        setupEndButton(at: index)
    }

    func currentPageIndex() -> Int {
        guard let pages = interactor?.numberOfSlides, pages > 0 else { return 0 }
        let pageWidth = collectionView.frame.size.width
        let centerOffsetX = collectionView.contentOffset.x + (pageWidth / 2)
        let page = Int(centerOffsetX / pageWidth)
        return page.constrainedTo(min: 0, max: pages - 1)
    }
}

// MARK: - Actions

private extension TutorialViewController {

    @IBAction func didTabEndButton() {
        interactor?.dismiss()
    }
}

// MARK: - TutorialViewControllerInterface

extension TutorialViewController: TutorialViewControllerInterface {

    func setup() {
        setupNavigationBar()
        setupView()
        setupCollectionView()
        setupPageControl()
        syncControlsForCurrentPage()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interactor?.numberOfSlides ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TutorialCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(title: interactor?.title(at: indexPath.item),
                       subtitle: interactor?.subtitle(at: indexPath.item),
                       body: interactor?.body(at: indexPath.item),
                       imageURL: interactor?.imageURL(at: indexPath.item))
        return cell
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        syncControlsForCurrentPage()
    }
}
