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
    @IBOutlet weak var myRatingValue: UILabel!

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

    @IBAction func firstDateTapped(_ sender: Any) {
        chartView.removeSubViews()
        barChartView.dataEntries = interactor.dataEntries1
        chartView.addSubview(barChartView)

    }
    @IBAction func secondDateTapped(_ sender: Any) {
        chartView.removeSubViews()
        barChartView.dataEntries = interactor.dataEntries2
        chartView.addSubview(barChartView)

    }
    @IBAction func thirdDateTapped(_ sender: Any) {
        myRatingValue.text = "8"
        ratingsView.alpha = 0
        barChartView.dataEntries = self.interactor.dataEntries3
        ratingsView.frame = CGRect(x: self.ratingsView.frame.origin.x, y: self.ratingsView.frame.origin.y + 25, width: self.ratingsView.frame.width, height: self.ratingsView.frame.height)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.ratingsView.frame = CGRect(x: self.ratingsView.frame.origin.x, y: self.ratingsView.frame.origin.y - 25, width: self.ratingsView.frame.width, height: self.ratingsView.frame.height)
            self.ratingsView.alpha = 1
        }, completion: nil)
    }
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
