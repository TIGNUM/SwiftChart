//
//  CoachMarksViewController.swift
//  QOT
//
//  Created by karmic on 22.10.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class CoachMarksViewController: UIViewController {

    // MARK: - Properties
    var interactor: CoachMarksInteractorInterface?
    var router: CoachMarksRouterInterface?
    private var viewModel: CoachMark.ViewModel?
    private var currentIndexPath = IndexPath(item: 0, section: 0)
    @IBOutlet private weak var buttonBack: UIButton!
    @IBOutlet private weak var buttonContinue: UIButton!
    @IBOutlet private weak var collectionView: UICollectionView!

    private var getCurrentPage: Int {
        return viewModel?.page ?? 0
    }

    private var getMediaName: String {
        return viewModel?.mediaName ?? ""
    }

    private var getTitle: String {
        return viewModel?.title ?? ""
    }

    private var getSubtitle: String {
        return viewModel?.subtitle ?? ""
    }

    // MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Private
private extension CoachMarksViewController {
    func setupButtons(_ hideBackButton: Bool, _ rightButtonImage: UIImage?) {
        buttonBack.isHidden = hideBackButton
        buttonContinue.setImage(rightButtonImage, for: .normal)
    }
}

// MARK: - Actions
private extension CoachMarksViewController {
    @IBAction func didTapBack() {
        interactor?.loadPreviousStep(page: getCurrentPage)
    }

    @IBAction func didTapContinue() {
        interactor?.loadNextStep(page: getCurrentPage)
    }
}

// MARK: - CoachMarksViewControllerInterface
extension CoachMarksViewController: CoachMarksViewControllerInterface {
    func setupView() {
        collectionView.registerDequeueable(CoachMarkCollectionViewCell.self)
    }

    func updateView(_ viewModel: CoachMark.ViewModel) {
        self.viewModel = viewModel
        setupButtons(viewModel.hideBackButton, viewModel.rightButtonImage)
        let toIndexPath = IndexPath(item: getCurrentPage, section: 0)
        collectionView.scrollToItem(at: toIndexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadItems(at: [toIndexPath])
    }
}

extension CoachMarksViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CoachMark.Step.allCases.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        currentIndexPath = indexPath
        let cell: CoachMarkCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(mediaName: getMediaName, title: getTitle, subtitle: getSubtitle)
        return cell
    }
}
