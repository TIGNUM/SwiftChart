//
//  FeatureExplainerViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class FeatureExplainerViewController: BaseViewController, ScreenZLevel1 {

    // MARK: - Properties
    var interactor: FeatureExplainerInteractorInterface!
    private lazy var router = FeatureExplainerRouter(viewController: self)
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    private var rightBarButtonItems = [UIBarButtonItem]()
    @IBOutlet private weak var checkButton: UIButton!

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        trackPage()
    }

    // MARK: Bottom Navigation
    override func bottomNavigationRightBarItems() -> [UIBarButtonItem]? {
        return rightBarButtonItems
    }

}

    // MARK: - Private
private extension FeatureExplainerViewController {

    func setupBottomNavigation(_ viewModel: FeatureExplainer.ViewModel) {
        let button = RoundedButton(title: "get Started", target: self, action: #selector(didTapGetStartedButton))
        ThemableButton.askPermissions.apply(button, title: "Get Started")
        rightBarButtonItems = [button.barButton]
        updateBottomNavigation([], rightBarButtonItems)
    }
}

    // MARK: - Actions
private extension FeatureExplainerViewController {

    @objc func didTapGetStartedButton() {
        trackUserEvent(.GET_STARTED, valueType: .GET_STARTED, action: .TAP)
        router.didTapGetStarted(interactor.getFeatureType)
    }

    @IBAction func buttonChecked(_ sender: Any) {
        checkButton.isSelected.toggle()
        checkButton.backgroundColor = checkButton.isSelected ? .accent : .clear
        UserDefault.sprintExplanation.setBoolValue(value: checkButton.isSelected ? true : false)
    }
}

    // MARK: - FeatureExplainerViewControllerInterface
extension FeatureExplainerViewController: FeatureExplainerViewControllerInterface {

    func setupView(_ viewModel: FeatureExplainer.ViewModel) {
        ThemeText.featureTitle.apply(viewModel.title, to: titleLabel)
        ThemeText.featureExplanation.apply(viewModel.description, to: bodyLabel)
        checkButton.corner(radius: 2, borderColor: .accent)
        checkButton.setImage(R.image.registration_checkmark(), for: .selected)
        setupBottomNavigation(viewModel)
    }
}
