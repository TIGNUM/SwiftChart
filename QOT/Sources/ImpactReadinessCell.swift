//
//  ImpactReadinessCell.swift
//  QOT
//
//  Created by Srikanth Roopa on 15.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

final class ImpactReadinessCell: UITableViewCell, UITableViewDelegate, Dequeueable, UITableViewDataSource {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dailyCheckImageView: UIImageView!
    @IBOutlet private weak var readinessScoreLabel: UILabel!
    @IBOutlet private weak var readinessDiagonalView: UIView!
    @IBOutlet private weak var readinessExploreButton: UIButton!
    @IBOutlet private weak var readinessDetailsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var impactReadinessModel: ImpactReadinessCellViewModel?
    private var impactDataModel: ImpactReadinessCellViewModel.ImpactDataViewModel?
    private var impactDataArray: [ImpactReadinessCellViewModel.ImpactDataViewModel]?
    @IBOutlet private weak var howYouFeelToday: UILabel!
    @IBOutlet private weak var asteriskText: UILabel!
    @IBOutlet private weak var readinessIntro: UILabel!
    @IBOutlet private weak var topGradientView: UIView!
    var score: Int = 0
    var checkinDelegate: DailyCheckinStartViewControllerDelegate?
    var delegate: DailyBriefViewControllerDelegate?
    private var impactDataModels: [ImpactReadinessCellViewModel.ImpactDataViewModel]? = []
    @IBAction func readinessExploreButton(_ sender: Any) {
        if score != 0 {
        readinessDetailsView.isHidden = false
        } else {
//             go to daily checkin page
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .carbon
        tableView.registerDequeueable(ImpactDataTableViewCell.self)
        setUp()
    }

    func setUp() {
        //tableView.tableFooterView = UIView(frame: .zero)
        readinessDetailsView.isHidden = true
        //TODO fade in top and bottom are not working
        dailyCheckImageView.addFadeView(at: .top,
                                       height: 70,
                                       primaryColor: .carbon,
                                       fadeColor: colorMode.fade)
        dailyCheckImageView.addFadeView(at: .bottom,
                                        height: 70,
                                        primaryColor: .carbon,
                                        fadeColor: colorMode.fade)
        topGradientView.setFadeMask(at: .topAndBottom, primaryColor: UIColor.green.cgColor)
        dailyCheckImageView.setFadeMask(at: .top, primaryColor: UIColor.green.cgColor)
        tableView?.delegate = self
        tableView?.dataSource = self
        readinessExploreButton.corner(radius: Layout.cornerRadius20, borderColor: .accent)
        if score == 0 {
            readinessExploreButton.setTitle("Start your Daily check-in", for: .normal)
        } else {  readinessExploreButton.setTitle("Explore your score", for: .normal)
        }
    }

    //    placeholder will be different and readiness score heck datatype
    func configure( with viewModel: ImpactReadinessCellViewModel?) {
        dailyCheckImageView.kf.setImage(with: viewModel?.dailyCheckImageView, placeholder: R.image.tbvPlaceholder())
        readinessScoreLabel.text = String(viewModel?.readinessScore ?? 0)
        self.howYouFeelToday.text = viewModel?.howYouFeelToday
        self.asteriskText.text = viewModel?.asteriskText
        self.readinessIntro.text = viewModel?.readinessIntro
        self.impactDataModels = viewModel?.impactDataModels
        titleLabel.text = viewModel?.title
        self.score = viewModel?.readinessScore ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    //TODO Setup cell: ImpactDataTableViewCell as soon as we got the data.LeaderWisdomCellViewModel.swift
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImpactDataTableViewCell = tableView.dequeueCell(for: indexPath)
//        delegate?.getReadinessTitles(completion: {(titles) in
//            self.delegate?.getReadinessSubtitles(completion: {(subtitles) in
////                self.delegate?.getReferenceValues(completion: {(references) in
//                    if subtitles != nil  && titles != nil {
//        cell.configure(title: impactDataModels?[indexPath.row].title ?? "",
//                      subTitle: impactDataModels?[indexPath.row].subTitle ?? "",
//                      averageValue: String(impactDataModels?[indexPath.row].averageValue ?? 0),
//                      targetRefValue: impactDataModels?[indexPath.row].targetRefValue ?? "")

        cell.delegate = self.delegate
        cell.backgroundColor = .carbon
        if indexPath.row != 0 {
            cell.setTargetRefLabelText("Ref")
        }
        return cell
    }
}
