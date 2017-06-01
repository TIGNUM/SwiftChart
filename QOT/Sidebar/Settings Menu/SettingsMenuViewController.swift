//
//  SettingsMenuViewController.swift
//  QOT
//
//  Created by Sam Wyndham on 13/04/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond
import Kingfisher

protocol SettingsMenuViewControllerDelegate: class {

    func didTapGeneral(in viewController: SettingsMenuViewController)

    func didTapNotifications(in viewController: SettingsMenuViewController)

    func didTapSecurity(in viewController: SettingsMenuViewController)
}

final class SettingsMenuViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var imgeView: UIImageView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var positionLabel: UILabel!
    @IBOutlet fileprivate weak var generalButton: UIButton!
    @IBOutlet fileprivate weak var notificationsButton: UIButton!
    @IBOutlet fileprivate weak var securityButton: UIButton!
    fileprivate let disposeBag = DisposeBag()
    fileprivate let viewModel: SettingsMenuViewModel
    weak var delegate: SettingsMenuViewControllerDelegate?

    // MARK: - Init

    init(viewModel: SettingsMenuViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
}

// MARK: - Private

private extension SettingsMenuViewController {

    func setupView() {
        view.backgroundColor = .clear
        setupCollectionView()
        setupImageView()
        setupLabels()
    }

    private func setupLabels() {
        titleLabel.attributedText = NSMutableAttributedString(
            string: viewModel.profile.name.uppercased(),
            letterSpacing: -2,
            font: Font.H2SecondaryTitle
        )
        positionLabel.attributedText = NSMutableAttributedString(
            string: viewModel.profile.position.uppercased(),
            letterSpacing: 2,
            font: Font.H7Tag,
            lineSpacing: 4
        )
        generalButton.setAttributedTitle(
            NSMutableAttributedString(
                string: R.string.localized.sidebarSettingsMenuGeneralButton().uppercased(),
                letterSpacing: -0.8,
                font: Font.H4Headline
            ), for: .normal
        )
        notificationsButton.setAttributedTitle(
            NSMutableAttributedString(
                string: R.string.localized.sidebarSettingsMenuNotificationsButton().uppercased(),
                letterSpacing: -0.8,
                font: Font.H4Headline,
                lineSpacing: 0
            ), for: .normal
        )

        securityButton.setAttributedTitle(
            NSMutableAttributedString(
                string: R.string.localized.sidebarSettingsMenuSecurityButton().uppercased(),
                letterSpacing: -0.8,
                font: Font.H4Headline
            ), for: .normal
        )
    }

    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.registerDequeueable(SettingsMenuCollectionViewCell.self)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 29, bottom: 0, right: 29)
    }

    private func setupImageView() {
        imgeView.kf.setImage(with: viewModel.profile.photoURL)
        imgeView.layer.cornerRadius = 10
    }
}

// MARK: - Actions

private extension SettingsMenuViewController {

    @IBAction func generalAction(_ sender: Any) {
        delegate?.didTapGeneral(in: self)
    }

    @IBAction func notyficationAction(_ sender: Any) {
        delegate?.didTapNotifications(in: self)
    }

    @IBAction func securityAction(_ sender: Any) {
        delegate?.didTapSecurity(in: self)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SettingsMenuViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tileCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SettingsMenuViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.tileCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.tile(at: indexPath.row)
        let cell: SettingsMenuCollectionViewCell = collectionView.dequeueCell(for: indexPath)
        cell.setup(with: item.title, subTitle: item.subtitle)

        return cell
    }
}
