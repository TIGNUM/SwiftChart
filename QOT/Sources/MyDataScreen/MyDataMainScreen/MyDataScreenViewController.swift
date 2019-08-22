//
//  MyDataScreenViewController.swift
//  
//
//  Created by Simu Voicu-Mircea on 19/08/2019.
//  Copyright (c) 2019 TIGNUM GmbH. All rights reserved.
//

import UIKit

enum MyDataRowType: Int, CaseIterable {
    case dailyImpactInfo = 0
    case dailyImpactChart
    case dailyImpactChartLegend
    case dailyImpactAddButton
    case heatMapInfo
    case heatMapButtons
    case heatMap
}

final class MyDataScreenViewController: UIViewController {

    // MARK: - Properties
    var interactor: MyDataScreenInteractorInterface?
    var router: MyDataScreenRouterInterface?
    @IBOutlet private weak var tableView: UITableView!
    private var myDataScreenModel: MyDataScreenModel?
    // MARK: - Init

    init(configure: Configurator<MyDataScreenViewController>) {
        super.init(nibName: nil, bundle: nil)
        configure(self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let configurator = MyDataScreenConfigurator.make()
        configurator(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        interactor?.viewDidLoad()
    }
}

// MARK: - Private
private extension MyDataScreenViewController {
    func setupTableView() {
        tableView.registerDequeueable(MyDataInfoTableViewCell.self)
        tableView.registerDequeueable(MyDataCharTableViewCell.self)
        tableView.registerDequeueable(MyDataChartLegendTableViewCell.self)
        tableView.registerDequeueable(MyDataAddButtonTableViewCell.self)
        tableView.registerDequeueable(MyDataHeatMapButtonsTableViewCell.self)
        tableView.registerDequeueable(MyDataHeatMapTableViewCell.self)
    }
}

// MARK: - Actions
private extension MyDataScreenViewController {

}

// MARK: - MyDataScreenViewControllerInterface
extension MyDataScreenViewController: MyDataScreenViewControllerInterface {
    func setupView() {
        setupTableView()
    }

    func setup(for myDataSection: MyDataScreenModel) {
        myDataScreenModel = myDataSection
    }
}

extension MyDataScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyDataRowType.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case MyDataRowType.dailyImpactInfo.rawValue:
            let dailyImpactInfoCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            dailyImpactInfoCell.selectedBackgroundView = backgroundView
            dailyImpactInfoCell.backgroundColor = .carbonNew
            dailyImpactInfoCell.configure(title: myDataScreenModel?.myDataItems[MyDataSection.dailyImpact.rawValue].title, subtitle: myDataScreenModel?.myDataItems[MyDataSection.dailyImpact.rawValue].subtitle)
            dailyImpactInfoCell.delegate = self

            return dailyImpactInfoCell
        case MyDataRowType.dailyImpactChart.rawValue:
            let dailyImpactCell: MyDataCharTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            dailyImpactCell.selectedBackgroundView = backgroundView
            dailyImpactCell.backgroundColor = .carbonNew

            return dailyImpactCell
        case MyDataRowType.dailyImpactChartLegend.rawValue:
            let chartLegendCell: MyDataChartLegendTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            chartLegendCell.selectedBackgroundView = backgroundView
            chartLegendCell.backgroundColor = .carbonNew
            chartLegendCell.configure(labelString: "(DRR) 5 Day Rolling Recovery\n(DRL) 5 Day Rolling load")

            return chartLegendCell
        case MyDataRowType.dailyImpactAddButton.rawValue:
            let addButtonCell: MyDataAddButtonTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            addButtonCell.selectedBackgroundView = backgroundView
            addButtonCell.backgroundColor = .carbonNew
            addButtonCell.delegate = self

            return addButtonCell
        case MyDataRowType.heatMapInfo.rawValue:
            let heatMapInfoCell: MyDataInfoTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            heatMapInfoCell.selectedBackgroundView = backgroundView
            heatMapInfoCell.backgroundColor = .carbonNew
            heatMapInfoCell.configure(title: myDataScreenModel?.myDataItems[MyDataSection.heatMap.rawValue].title, subtitle: myDataScreenModel?.myDataItems[MyDataSection.heatMap.rawValue].subtitle)
            heatMapInfoCell.delegate = self

            return heatMapInfoCell
        case MyDataRowType.heatMapButtons.rawValue:
            let heatMapButtonsCell: MyDataHeatMapButtonsTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            heatMapButtonsCell.selectedBackgroundView = backgroundView
            heatMapButtonsCell.backgroundColor = .carbonNew
            heatMapButtonsCell.delegate = self

            return heatMapButtonsCell
        case MyDataRowType.heatMap.rawValue:
            let heatMapCell: MyDataHeatMapTableViewCell = tableView.dequeueCell(for: indexPath)
            let backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.carbon
            heatMapCell.selectedBackgroundView = backgroundView
            heatMapCell.backgroundColor = .carbonNew

            return heatMapCell
        default:
            return UITableViewCell.init()
        }
    }
}

extension MyDataScreenViewController: MyDataInfoTableViewCellDelegate, MyDataAddButtonTableViewCellDelegate, MyDataHeatMapButtonsTableViewCellDelegate {
    func didTapAddButton() {
        router?.presentMyDataSelection()
    }

    func didChangeSelection(to: HeatMapMode) {
        //update heat map
    }

    func didTapInfoButton() {
        router?.presentMyDataExplanation()
    }
}
