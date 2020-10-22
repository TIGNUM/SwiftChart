//
//  TeamVisionTrackerDetailsViewController.swift
//  QOT
//
//  Created by Anais Plancoulaine on 28.09.20.
//  Copyright (c) 2020 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class TeamVisionTrackerDetailsViewController: BaseViewController, ScreenZLevel3 {

    // MARK: - Properties
    var interactor: TeamVisionTrackerDetailsInteractorInterface!
    private lazy var router: TeamVisionTrackerDetailsRouterInterface = TeamVisionTrackerDetailsRouter(viewController: self)
    @IBOutlet private weak var chartView: UIView!
    @IBOutlet private weak var ratingsView: UIView!
    @IBOutlet private weak var firstDateButton: UIButton!

    @IBOutlet private weak var secondDateButton: UIButton!
    @IBOutlet private weak var thirdDateButton: UIButton!
    @IBOutlet private weak var myRatingValue: UILabel!
    @IBOutlet private weak var averageRatingLabel: UILabel!
    @IBOutlet private weak var myRatingLabel: UILabel!
    @IBOutlet private weak var totalVotesLabel: UILabel!
    @IBOutlet private weak var totalVotesValue: UILabel!
    @IBOutlet private weak var averageRatingValue: UILabel!
    @IBOutlet private weak var sentenceLabel: UILabel!

    lazy var barChartView: BarChartView = {
        let barChartView = BarChartView()
        barChartView.frame = chartView.frame
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

    override func bottomNavigationLeftBarItems() -> [UIBarButtonItem]? {
        return [backNavigationItemLight()]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor.viewDidLoad()
        ThemeView.level2.apply(self.view)
    }

    @IBAction func firstDateTapped(_ sender: Any) {
        setButtons(button: firstDateButton)
        switchView(interactor.dataEntries1)
    }

    @IBAction func secondDateTapped(_ sender: Any) {
        setButtons(button: secondDateButton)
        switchView(interactor.dataEntries2)
    }

    @IBAction func thirdDateTapped(_ sender: Any) {
        setButtons(button: thirdDateButton)
        switchView(interactor.dataEntries3)
    }
}

// MARK: - TeamVisionTrackerDetailsViewControllerInterface
extension TeamVisionTrackerDetailsViewController: TeamVisionTrackerDetailsViewControllerInterface {
    func setupView() {
        barChartView.dataEntries = interactor.dataEntries3
        chartView.addSubview(barChartView)
        setValues(interactor.dataEntries3)

        ThemeText.totalVotes.apply(AppTextService.get(.my_x_team_vision_tracker_total_votes),
                                   to: totalVotesLabel)
        ThemeText.averageRating.apply(AppTextService.get(.my_x_team_vision_tracker_average_rating),
                                      to: averageRatingLabel)
        ThemeText.myRating.apply(AppTextService.get(.my_x_team_vision_tracker_my_rating),
                                 to: myRatingLabel)
    }

    func setupDates(firstDate: String?, secondDate: String?, thirdDate: String?) {
        firstDateButton.setTitle(firstDate, for: .normal)
        secondDateButton.setTitle(secondDate, for: .normal)
        thirdDateButton.setTitle(thirdDate, for: .normal)

        firstDateButton.isHidden = firstDate == nil
        secondDateButton.isHidden = secondDate == nil
        thirdDateButton.isHidden = thirdDate == nil
    }

    func setupSentence(_ sentence: String) {
        sentenceLabel.text = sentence
    }

    func switchView(_ data: [BarEntry]) {
        ratingsView.alpha = 0
        setValues(data)
        ratingsView.frame = CGRect(x: ratingsView.frame.origin.x, y: ratingsView.frame.origin.y + 25, width: ratingsView.frame.width, height: ratingsView.frame.height)
        UIView.animate(withDuration: 0.4, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.ratingsView.frame = CGRect(x: self.ratingsView.frame.origin.x,
                                            y: self.ratingsView.frame.origin.y - 25,
                                            width: self.ratingsView.frame.width,
                                            height: self.ratingsView.frame.height)
            self.ratingsView.alpha = 1
            self.barChartView.dataEntries = data
        }, completion: nil)
    }

    func setButtons(button: UIButton) {
        let buttons = [firstDateButton, secondDateButton, thirdDateButton]
        buttons.forEach { (button) in
            button?.corner(radius: 20, borderColor: .accent40)
            button?.backgroundColor = .carbon
        }
        button.layer.borderWidth = 0
        button.backgroundColor = .accent40
    }

    func calculateAverage(_ data: [BarEntry]) -> Float {
        var sum = 0
        data.forEach { (entry) in
            sum += entry.scoreIndex * entry.votes
        }
        let average = Float(sum)/Float(totalVotes(data))
        return average
    }

    func totalVotes(_ data: [BarEntry]) -> Int {
        var totalSum = 0
        data.forEach {(item) in
            totalSum += item.votes
        }
        return totalSum
    }

    func setValues( _ data: [BarEntry]) {
        myRatingValue.text = String(data.filter { $0.isMyVote == true }.first?.scoreIndex ?? 0)
        totalVotesValue.text = String(totalVotes(data))
        averageRatingValue.text = String(format: "%.1f", calculateAverage(data))
    }
}
