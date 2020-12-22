//
//  FeatureExplainerViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 26.05.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class FeatureExplainerViewController: BaseViewController, ScreenZLevel1 {

    // MARK: - Properties
    var interactor: FeatureExplainerInteractorInterface!
    private lazy var router = FeatureExplainerRouter(viewController: self)
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyLabel: UILabel!
    private var rightBarButtonItems = [UIBarButtonItem]()
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var checkboxLabel: UILabel!

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
        let title = AppTextService.get(.generic_feature_explainer_button)
        let button = RoundedButton(title: title, target: self, action: #selector(didTapGetStartedButton))
        ThemableButton.darkButton.apply(button, title: title)
        rightBarButtonItems = [button.barButton]
        updateBottomNavigation([], rightBarButtonItems)
    }
}

// MARK: - Actions
private extension FeatureExplainerViewController {

    @objc func didTapGetStartedButton() {
        trackUserEvent(.GET_STARTED, stringValue: interactor.getFeatureType.rawValue, valueType: .FEATURE_EXPLAINER, action: .TAP)
        router.didTapGetStarted(interactor.getFeatureType)
    }

    @IBAction func buttonChecked(_ sender: Any) {
        checkButton.isSelected.toggle()
        trackUserEvent(.CHECK_DONT_SHOW_EXPLAINER, stringValue: interactor.getFeatureType.rawValue, valueType: .FEATURE_EXPLAINER, action: .TAP)
        checkButton.backgroundColor = checkButton.isSelected ? .accent : .clear
        switch interactor.getFeatureType {
        case .sprint:
            UserDefault.sprintExplanation.setBoolValue(value: checkButton.isSelected)
        case .tools:
             UserDefault.toolsExplanation.setBoolValue(value: checkButton.isSelected)
        case .prepare:
             UserDefault.prepareExplanation.setBoolValue(value: checkButton.isSelected)
        case .mindsetShifter:
             UserDefault.mindsetExplanation.setBoolValue(value: checkButton.isSelected)
        case .recovery:
             UserDefault.recoveryExplanation.setBoolValue(value: checkButton.isSelected)
        case .solve:
             UserDefault.solveExplanation.setBoolValue(value: checkButton.isSelected)
        }
    }
}

// MARK: - FeatureExplainerViewControllerInterface
extension FeatureExplainerViewController: FeatureExplainerViewControllerInterface {

    func setupView(_ viewModel: FeatureExplainer.ViewModel) {
        ThemeText.featureTitle.apply(viewModel.title?.uppercased(), to: titleLabel)
        ThemeText.featureExplanation.apply(viewModel.description, to: bodyLabel)
        ThemeText.featureLabel.apply(AppTextService.get(.generic_feature_explainer_label), to: checkboxLabel)
        checkButton.corner(radius: 2, borderColor: .accent)
        checkButton.setImage(R.image.registration_checkmark(), for: .selected)
        setupBottomNavigation(viewModel)
    }
}
