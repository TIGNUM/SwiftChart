//
//  AddSensorViewController.swift
//  QOT
//
//  Created by Aamir Suhial Mir on 17.05.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import Anchorage
import ReactiveKit
import Bond

protocol AddSensorViewControllerDelegate: class {

    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController)
}

final class AddSensorViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: AddSensorViewModel
    private let fadeContainerView = FadeContainerView()
    let updates = PublishSubject<CollectionUpdate, NoError>()
    weak var delegate: AddSensorViewControllerDelegate?

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: 36, bottom: 10, right: 59)

        return UICollectionView(layout: layout,
                                delegate: self,
                                dataSource: self,
                                dequeables: SensorCollectionViewCell.self,
                                RequestDeviceSensorCollectionViewCell.self)
    }()

    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.delegate = self
        view.addSubview(contentView)

        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(headerLabel)
        view.addSubview(textLabel)

        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.addCharactersSpacing(spacing: 2, text: R.string.localized.sidebarSensorsMenuSensors(), uppercased: true)
        label.textColor = .white
        label.font = Font.H3Subtitle

        return label
    }()

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = Font.H3Subtitle
        label.addCharactersSpacing(spacing: 2, text: viewModel.headLine ?? "", uppercased: true)
        label.numberOfLines = 0

        return label
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.setAttrText(text: viewModel.content ?? "", font: Font.DPText, alignment: .left, lineSpacing: 13)
        label.numberOfLines = 0

        return label
    }()

    // MARK: - Init

    init(viewModel: AddSensorViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpHierarchy()
        setUpLayout()
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationItem.title = R.string.localized.sidebarSensorsMenuSensors().uppercased()
    }

    func reloadCollectionView() {
        collectionView.reloadData()
    }
}

extension AddSensorViewController: AddSensorViewControllerDelegate {

    func didTapSensor(_ sensor: AddSensorViewModel.Sensor, in viewController: UIViewController) {
        switch sensor {
        case .fitbit:
            if (viewModel.fitbitState == .connected || viewModel.fitbitState == .pending),
                let url = URL(string: "https://www.fitbit.com/user/profile/apps") {
                presentSafariViewController(url: url, viewController: viewController)
            } else {
                presentFitBitWebView(in: viewController)
            }
        case .requestDevice:
            presentAddSensorAlert(in: viewController, sendAction: { text in
                self.viewModel.recordFeedback(message: text)
                self.presentFeedbackCompletionAlert(in: viewController)
            })
        default:
            log("sensor not yet implemented")
        }
    }

    func presentAddSensorAlert(in viewController: UIViewController, sendAction: ((String) -> Void)?) {
        let alertController = UIAlertController(title: R.string.localized.addSensorViewAlertTitle(), message: R.string.localized.addSensorViewAlertMessage(), preferredStyle: .alert)
        let sendAction = UIAlertAction(title: R.string.localized.addSensorViewAlertSend(), style: .default) { [unowned alertController] _ in
            guard let text = alertController.textFields?.first?.text, text.count > 0 else {
                return
            }
            sendAction?(text)
        }

        let cancelAction = UIAlertAction(title: R.string.localized.addSensorViewAlertCancel(), style: .cancel)
        alertController.addTextField { textField in
            textField.placeholder = R.string.localized.addSensorViewAlertPlaceholder()
        }

        alertController.addAction(sendAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    func presentFeedbackCompletionAlert(in viewController: UIViewController) {
        let alertController = UIAlertController(title: R.string.localized.addSensorViewAlertFeedbackTitle(), message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: R.string.localized.addSensorViewAlertFeedbackSuccessOK(), style: .default)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - private

private extension AddSensorViewController {

    func presentFitBitWebView(in viewController: UIViewController) {
        guard
            let settingValue = viewModel.settingValue,
            case .text(let urlString) = settingValue,
            let url = URL(string: urlString) else { return }
        presentSafariViewController(url: url, viewController: viewController)
    }

    func presentSafariViewController(url: URL, viewController: UIViewController) {
        do {
            let webViewController = try WebViewController(url)
            viewController.present(webViewController, animated: true)
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(reloadAddSensorViewController),
                                                   name: .syncAllDidFinishNotification,
                                                   object: nil)

        } catch {
            log("Failed to open url. Error: \(error)", level: .error)
            viewController.showAlert(type: .message(error.localizedDescription))
        }
    }

    @objc func reloadAddSensorViewController() {
        reloadCollectionView()
        NotificationCenter.default.removeObserver(self, name: .syncAllDidFinishNotification, object: nil)
    }
}

// MARK: - Collection View DataSource and Delegate

extension AddSensorViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.itemCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = viewModel.item(at: indexPath.row)

        switch item {
        case .fitbit, .apple:
            let cell: SensorCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(image: item.image, sensorName: item.title, fitbitState: viewModel.fitbitState)

            return cell
        case .requestDevice:
            let cell: RequestDeviceSensorCollectionViewCell = collectionView.dequeueCell(for: indexPath)
            cell.setup(title: item.title)

            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164, height: 207)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapSensor(viewModel.item(at: indexPath.row), in: self)
    }
}

private extension AddSensorViewController {

    func setUpHierarchy() {
        let backgroundImageView = UIImageView(frame: view.frame)
        backgroundImageView.image = R.image.backgroundSidebar()
        view.addSubview(backgroundImageView)
        view.addSubview(fadeContainerView)
    }

    func setUpLayout() {
        navigationItem.title = R.string.localized.sidebarTitleSensor()
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = .never
        }

        view.addSubview(fadeContainerView)
        fadeContainerView.verticalAnchors == view.verticalAnchors
        fadeContainerView.horizontalAnchors == view.horizontalAnchors

        fadeContainerView.addSubview(scrollView)
        scrollView.verticalAnchors == fadeContainerView.verticalAnchors
        scrollView.horizontalAnchors == fadeContainerView.horizontalAnchors

        contentView.leftAnchor == scrollView.leftAnchor
        contentView.rightAnchor == scrollView.rightAnchor
        contentView.topAnchor == scrollView.topAnchor
        contentView.bottomAnchor == scrollView.bottomAnchor
        contentView.widthAnchor == scrollView.widthAnchor

        titleLabel.topAnchor == contentView.safeTopAnchor + 46
        titleLabel.leftAnchor == contentView.leftAnchor + 36
        titleLabel.rightAnchor == contentView.rightAnchor - 59
        titleLabel.heightAnchor == 36

        collectionView.topAnchor == titleLabel.bottomAnchor + 14
        collectionView.horizontalAnchors == contentView.horizontalAnchors
        collectionView.heightAnchor == 220

        headerLabel.topAnchor == collectionView.bottomAnchor + 52
        headerLabel.horizontalAnchors == titleLabel.horizontalAnchors

        textLabel.topAnchor == headerLabel.bottomAnchor + 17
        textLabel.horizontalAnchors == titleLabel.horizontalAnchors
        textLabel.bottomAnchor == contentView.bottomAnchor - 12

        if let navigationBarHeight = navigationController?.navigationBar.bounds.height {
            fadeContainerView.setFade(top: navigationBarHeight + 32, bottom: 0)
        }

        view.layoutIfNeeded()
    }
}
