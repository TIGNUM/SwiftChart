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
    @IBOutlet var readinessExploreButton: UIButton!
    @IBOutlet private weak var readinessDetailsView: UIView!
    @IBOutlet weak var tableView: UITableView!
    private var impactReadinessModel: ImpactReadinessCellViewModel?
    private var impactDataModel: ImpactReadinessCellViewModel.ImpactDataViewModel?
    private var impactDataArray: [ImpactReadinessCellViewModel.ImpactDataViewModel]?
    @IBOutlet private weak var howYouFeelToday: UILabel!
    @IBOutlet private weak var asteriskText: UILabel!
    @IBOutlet private weak var readinessIntro: UILabel!
    @IBOutlet private weak var topGradientView: UIView!
    private var referenceValues: [Int]?
    var score: Int = 0
    var delegate: DailyBriefViewControllerDelegate?
    private var impactDataModels: [ImpactReadinessCellViewModel.ImpactDataViewModel]? = []
    @IBAction func readinessExploreButton(_ sender: Any) {
        if score != 0 {
        readinessDetailsView.isHidden = false
        } else {
            delegate?.showDailyCheckIn()
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
    }

    //    placeholder will be different and readiness score heck datatype
    func configure( with viewModel: ImpactReadinessCellViewModel?) {
        dailyCheckImageView.kf.setImage(with: viewModel?.dailyCheckImageView, placeholder: R.image.tbvPlaceholder())
        readinessScoreLabel.text = String(viewModel?.readinessScore ?? 0)
        self.howYouFeelToday.text = viewModel?.howYouFeelToday
        self.asteriskText.text = viewModel?.asteriskText
        self.readinessIntro.text = viewModel?.readinessIntro
        self.impactDataModels = viewModel?.impactDataModels
        self.referenceValues = viewModel?.targetReferenceArray
        titleLabel.text = viewModel?.title
        self.score = viewModel?.readinessScore ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return impactDataModels?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ImpactDataTableViewCell = tableView.dequeueCell(for: indexPath)
        cell.configure(title: impactDataModels?[indexPath.row].title ?? "",
                      subTitle: impactDataModels?[indexPath.row].subTitle ?? "",
                      averageValue: String(impactDataModels?[indexPath.row].averageValues?[indexPath.row].rounded(.up) ?? 0),
                      targetRefValue: referenceValues?[indexPath.row] ?? 0)
        cell.delegate = self.delegate
        cell.backgroundColor = .carbon
        if indexPath.row != 0 {
            cell.setTargetRefLabelText("Ref")
        }
        return cell
    }
}
