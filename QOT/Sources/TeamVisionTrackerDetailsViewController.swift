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
    @IBOutlet weak var chartView: UIView!

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
        barChartView.dataEntries =
            [
                BarEntry(scoreIndex: 1, votes: 0, isMyVote: false),
                BarEntry(scoreIndex: 2, votes: 0, isMyVote: false),
                BarEntry(scoreIndex: 3, votes: 6, isMyVote: false),
                BarEntry(scoreIndex: 4, votes: 2, isMyVote: true),
                BarEntry(scoreIndex: 5, votes: 9, isMyVote: false),
                BarEntry(scoreIndex: 6, votes: 200, isMyVote: false),
                BarEntry(scoreIndex: 7, votes: 3, isMyVote: false),
                BarEntry(scoreIndex: 8, votes: 10, isMyVote: false),
                BarEntry(scoreIndex: 9, votes: 20, isMyVote: false),
                BarEntry(scoreIndex: 10, votes: 39, isMyVote: false)
        ]
       chartView.addSubview(barChartView)
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
        // Do any additional setup after loading the view.
    }
}
