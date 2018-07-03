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
    private var partners = [Partners.Partner]()
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var landingViewContainer: UIView!
    @IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var headlineLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var addButton: UIButton!

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
        interactor?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.reload()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionView.frame.width * 0.8, height: collectionView.frame.height)
        }
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
                       profileImage: partner.imageURL,
                       shareStatus: nil,
                       partner: partner,
                       interactor: interactor)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return partners.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let partner = partners[indexPath.row]
        if partner.isValid {
            interactor?.editPartner(partner: partner)
        } else {
            interactor?.addPartner(partner: partner)
        }
    }
}

// MARK: - Private

private extension PartnersOverviewViewController {

    func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleShareViewDidDismiss(_:)),
                                               name: .didDismissView,
                                               object: nil)
    }

    @objc func handleShareViewDidDismiss(_ notification: Notification) {
        if notification.name == .didDismissView {
            setupLandingPageView()
            collectionView.reloadData()
        }
    }

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

    func setupLandingPageView() {
        landingViewContainer.isHidden = (partners.filter { $0.isValid == true }).isEmpty == false
        profileImageView.image = interactor?.landingPage?.defaultProfilePicture
        headlineLabel.attributedText = interactor?.landingPage?.titleAttributedString
        messageLabel.attributedText = interactor?.landingPage?.messageAttributedString
        addButton.corner(radius: Layout.CornerRadius.eight.rawValue)
        addButton.backgroundColor = .azure
        addButton.setAttributedTitle(interactor?.landingPage?.buttonTitleAttributedString, for: .normal)
        addButton.setAttributedTitle(interactor?.landingPage?.buttonTitleAttributedString, for: .selected)
    }

    func setupProfileImageView(image: UIImage?) {
        profileImageView.image = image
    }

    func setupLabels(title: NSAttributedString, message: NSAttributedString) {
        headlineLabel.attributedText = title
        messageLabel.attributedText = message
    }

    func setupAddButton(buttonTitle: NSAttributedString) {
        addButton.corner(radius: Layout.CornerRadius.eight.rawValue)
        addButton.backgroundColor = .azure
        addButton.setAttributedTitle(buttonTitle, for: .normal)
        addButton.setAttributedTitle(buttonTitle, for: .selected)
    }
}

// MARK: - Actions

private extension PartnersOverviewViewController {

    @objc func didTapClose() {
        interactor?.didTapClose()
    }

    @IBAction func didTapAddPartnerButton() {
        interactor?.addPartner(partner: partners[0]) // FIXME: remove constant
    }
}

// MARK: - PartnersOverviewViewControllerInterface

extension PartnersOverviewViewController: PartnersOverviewViewControllerInterface {

    func setup(partners: [Partners.Partner]) {
        self.partners = partners
        setupNotifications()
        setupCollectionView()
        setupNavigationItems()
        setupLandingPageView()
        collectionView.reloadData()
    }

    func reload(partner: Partners.Partner) {
        guard let index = partners.index(where: { $0.localID == partner.localID }) else {
            assertionFailure("Trying to reload a partner that doesn't exist.")
            return
        }
        setupLandingPageView()
        collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
    }
}
