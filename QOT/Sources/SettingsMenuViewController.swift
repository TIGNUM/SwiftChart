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
import Anchorage

protocol SettingsMenuViewControllerDelegate: class {

    func didTapGeneral(in viewController: SettingsMenuViewController)

    func didTapNotifications(in viewController: SettingsMenuViewController)

    func didTapSecurity(in viewController: SettingsMenuViewController)

    func didTapLogout(in viewController: SettingsMenuViewController)

    func goToGeneralSettings(from viewController: SettingsMenuViewController, guideItem: Guide.Item?)
}

final class SettingsMenuViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var backgroundImage: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var imgeView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var positionLabel: UILabel!
    @IBOutlet private weak var generalButton: UIButton!
    @IBOutlet private weak var notificationsButton: UIButton!
    @IBOutlet private weak var securityButton: UIButton!
    @IBOutlet private weak var logoutButton: UIButton!
    private let disposeBag = DisposeBag()
    private let viewModel: SettingsMenuViewModel
    private var guideItem: Guide.Item?
    weak var delegate: SettingsMenuViewControllerDelegate?

    // MARK: - Init

    init(viewModel: SettingsMenuViewModel, guideItem: Guide.Item?) {
        self.viewModel = viewModel
        self.guideItem = guideItem

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = R.string.localized.settingsTitle().uppercased()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard guideItem != nil else { return }
        delegate?.goToGeneralSettings(from: self, guideItem: guideItem)
        guideItem = nil
    }
}

// MARK: - Private

private extension SettingsMenuViewController {

    func setupView() {
        setupCollectionView()
        setupImageView()
        setupLabels()
        setupBackgroundImage()
    }

    private func setupBackgroundImage() {
        let backgroundImage = UIImageView(image: R.image.sidebar())
        view.addSubview(backgroundImage)
        backgroundImage.verticalAnchors == view.verticalAnchors
        backgroundImage.horizontalAnchors == view.horizontalAnchors
        view.sendSubview(toBack: backgroundImage)
    }

    private func setupLabels() {
        titleLabel.attributedText = NSMutableAttributedString(
            string: viewModel.userName,
            letterSpacing: -2,
            font: Font.H2SecondaryTitle
        )
        positionLabel.attributedText = NSMutableAttributedString(
            string: viewModel.userJobTitle ?? "",
            letterSpacing: 2,
            font: Font.H7Tag,
            lineSpacing: 4,
            textColor: .white80
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
        logoutButton.setAttributedTitle(
            NSMutableAttributedString(
                string: R.string.localized.sidebarSettingsMenuLogoutButton().uppercased(),
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
        imgeView.layer.cornerRadius = 10
        imgeView.layer.masksToBounds = true
        var url: URL? = nil
        if let urlString = viewModel.userProfileImagePath {
            url = URL(string: urlString)
        }
        imgeView.kf.setImage(with: url, placeholder: R.image.placeholder_user(), options: nil, progressBlock: nil, completionHandler: nil)
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

    @IBAction func logoutAction(_ sender: Any) {
        delegate?.didTapLogout(in: self)
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
