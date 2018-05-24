//
//  PartnersOverviewViewController.swift
//  QOT
//
//  Created by karmic on 15.05.18.
//  Copyright (c) 2018 Tignum. All rights reserved.
//

import UIKit

class PartnersAnimationViewController: UIViewController {}

final class PartnersOverviewViewController: PartnersAnimationViewController {

    // MARK: - Properties

    var interactor: PartnersOverviewInteractorInterface?
    private var partners = [Partner]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Init

    init(configure: Configurator<PartnersOverviewViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupNavigationItems()
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.reload()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PartnersOverviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let partner = partners[indexPath.row]
        let cell: PartnersOverviewCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.configure(name: partner.name,
                       surname: partner.surname,
                       relationship: partner.relationship,
                       profileImage: partner.profileImageResource?.url,
                       shareStatus: nil,
                       partner: partner,
                       interactor: interactor)
        return cell
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let partner = partners[indexPath.row]
        interactor?.editPartner(partner: partner)
    }
}

// MARK: - Private

private extension PartnersOverviewViewController {

    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.registerDequeueable(PartnersOverviewCollectionViewCell.self)
    }

    func setupNavigationItems() {
        let leftButton = UIBarButtonItem(withImage: R.image.ic_minimize())
        leftButton.target = self
        leftButton.action = #selector(didTapClose)
        navigationItem.leftBarButtonItem = leftButton
    }
}

// MARK: - Actions

private extension PartnersOverviewViewController {

    @objc func didTapClose() {
        interactor?.didTapClose()
    }
}

// MARK: - PartnersOverviewViewControllerInterface

extension PartnersOverviewViewController: PartnersOverviewViewControllerInterface {

    func setup(partners: [Partner]) {
        self.partners = partners
        collectionView.reloadData()
    }

    func reload(partner: Partner) {
        guard let index = partners.index(where: { $0.localID == partner.localID }) else {
            assertionFailure("Trying to reload a partner that doesn't exist.")
            return
        }
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}
