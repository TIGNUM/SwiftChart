//
//  TeamVisionTrackerDetailsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit

final class TeamVisionTrackerDetailsViewController: UIViewController {

    // MARK: - Properties
    var interactor: TeamVisionTrackerDetailsInteractorInterface!
    private lazy var router: TeamVisionTrackerDetailsRouterInterface = TeamVisionTrackerDetailsRouter(viewController: self)
    @IBOutlet private weak var chartView: UIView!
    @IBOutlet private weak var ratingsView: UIView!
    @IBOutlet weak var firstDateButton: UIButton!
    @IBOutlet weak var secondDateButton: UIButton!
    @IBOutlet weak var thirdDateButton: UIButton!

    lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.frame =  chartView.frame
        return barChartView
    }()

    // MARK: - Init
    init(configure: Configurator<TeamVisionTrackerDetailsViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        ThemeView.level2.apply(self.view)
    }
}

// MARK: - Private
private extension TeamVisionTrackerDetailsViewController {

}

// MARK: - Actions
private extension TeamVisionTrackerDetailsViewController {

}

// MARK: - TeamVisionTrackerDetailsViewControllerInterface
extension TeamVisionTrackerDetailsViewController: TeamVisionTrackerDetailsViewControllerInterface {
    func setupView() {
        firstDateButton.corner(radius: 20, borderColor: .accent40)
        secondDateButton.corner(radius: 20, borderColor: .accent40)
        thirdDateButton.corner(radius: 20, borderColor: .accent40)
        barChartView.dataEntries = interactor.dataEntries1
        chartView.addSubview(barChartView)
    }
}
