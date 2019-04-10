//
//  SubsriptionReminderViewController.swift
//  QOT
//
//  Created by karmic on 28.03.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class SubsriptionReminderViewController: UIViewController {

    // MARK: - Properties

    @IBOutlet private weak var navigationBar: UINavigationBar!
    @IBOutlet private weak var minimiseButton: UIBarButtonItem!
    @IBOutlet private weak var switchAccountButton: UIButton!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var benfitTitleLabelFirst: UILabel!
    @IBOutlet private weak var benfitSubtitleLabelFirst: UILabel!
    @IBOutlet private weak var benfitTitleLabelSecond: UILabel!
    @IBOutlet private weak var benfitSubtitleLabelSecond: UILabel!
    @IBOutlet private weak var benfitTitleLabelThird: UILabel!
    @IBOutlet private weak var benfitSubtitleLabelThird: UILabel!
    @IBOutlet private weak var benfitTitleLabelFourth: UILabel!
    @IBOutlet private weak var benfitSubtitleLabelFourth: UILabel!
    @IBOutlet private weak var benefitsContentView: UIView!
    var interactor: SubsriptionReminderInteractorInterface?

    // MARK: - Init

    init(configure: Configurator<SubsriptionReminderViewController>) {
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

private extension SubsriptionReminderViewController {
    func setupLabels() {
        titleLabel.attributedText = interactor?.title
        subtitleLabel.attributedText = interactor?.subTitle
        benfitTitleLabelFirst.attributedText = interactor?.benefitsTitleFirst
        benfitSubtitleLabelFirst.attributedText = interactor?.benefitsSubtitleFirst
        benfitTitleLabelSecond.attributedText = interactor?.benefitsTitleSecond
        benfitSubtitleLabelSecond.attributedText = interactor?.benefitsSubtitleSecond
        benfitTitleLabelThird.attributedText = interactor?.benefitsTitleThird
        benfitSubtitleLabelThird.attributedText = interactor?.benefitsSubtitleThird
        benfitTitleLabelFourth.attributedText = interactor?.benefitsTitleFourth
        benfitSubtitleLabelFourth.attributedText = interactor?.benefitsSubtitleFourth
    }

    func setupSubViews() {
        benefitsContentView.backgroundColor = .guideCardToDoBackground70
        navigationBar.applyDefaultStyle()
        benefitsContentView.corner(radius: Layout.CornerRadius.eight.rawValue   )
        view.bringSubview(toFront: navigationBar)
    }

    func setupButtons() {
        if interactor?.showCloseButton == false {
            navigationBar.items?.removeAll()
        }
        switchAccountButton.isHidden = interactor?.showSwitchAccountButton == false
    }
}

// MARK: - Actions

private extension SubsriptionReminderViewController {
    @IBAction func close() {
        interactor?.didTapMinimiseButton()
    }

    @IBAction func switchAccount() {
        interactor?.didTapSwitchAccounts()
    }
}

// MARK: - SubsriptionReminderViewControllerInterface

extension SubsriptionReminderViewController: SubsriptionReminderViewControllerInterface {
    func setupView() {
        setupSubViews()
        setupButtons()
        setupLabels()
    }
}
