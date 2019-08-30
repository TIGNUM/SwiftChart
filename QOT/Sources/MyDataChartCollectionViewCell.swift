//
//  MyDataHeatMapDateCell.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 22/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit
import SwiftChart
import qot_dal

final class MyDataChartCollectionViewCell: UICollectionViewCell, Dequeueable {
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var chartView: Chart!
    @IBOutlet private var noDataViewsCollection: [UIImageView]!
    @IBOutlet weak var upperValueLabel: UILabel!
    @IBOutlet weak var lowerValueLabel: UILabel!
    @IBOutlet weak var noDataLabel: UILabel!

    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupChart()
        setupView()
    }

    // MARK: Private

    private func setupChart() {
        chartView.axesColor = .sand20
        chartView.gridColor = .sand20
        chartView.labelColor = .clear
        chartView.bottomInset = 0
        chartView.bottomInset = 0
        chartView.minY = 0
        let maxString = upperValueLabel.text ?? "100"
        let minString = lowerValueLabel.text ?? "0"
        chartView.maxY = Double(maxString)
        chartView.minX = Double(minString)
        chartView.maxX = 6
        chartView.showXLabelsAndGrid = false
        chartView.showYLabelsAndGrid = true
    }

    private func setupView() {
        ThemeText.sectionHeader.apply(ScreenTitleService.main.myDataGraphNoDataTitle(), to: noDataLabel)
    }

    private func datesOfTheWeek(thatContains date: Date) -> [Date] {
        var dates: [Date] = []
        let firstDay = date.firstDayOfWeek()
        for dayIndex in 0...6 {
            dates.append(firstDay.dateAfterDays(dayIndex))
        }
        return dates
    }

    // MARK: Public

    func configure(withModels: [Date: MyDataDailyCheckInModel], selectionModel: MyDataSelectionModel, average: Double = 70) {

        //initial reset after reuse
        chartView.removeAllSeries()
        let hasData: Bool = withModels.count > 0
        for noDataView in noDataViewsCollection {
            noDataView.alpha = hasData ? 0.0 : 1.0
        }
        noDataLabel.isHidden = hasData
        guard let firstModelDate = withModels.first?.key else {
            return
        }
        chartView.yLabels = [0, average/2, average, 100]

        //chartSeries creation

        var SQLdata: [(x: Double, y: Double)] = []
        var SQNdata: [(x: Double, y: Double)] = []
        var tenDLdata: [(x: Double, y: Double)] = []
        var fiveDRRdata: [(x: Double, y: Double)] = []
        var fiveDRLdata: [(x: Double, y: Double)] = []
        var fiveDIRdata: [(x: Double, y: Double)] = []
        var IRdata: [(x: Double, y: Double)] = []

        let datesOfCurrentWeek = datesOfTheWeek(thatContains: firstModelDate)
        for (index, day) in datesOfCurrentWeek.enumerated() {
            if let model = withModels[day] {
                SQLdata.append((x: Double(index), y: model.sleepQuality ?? 0))
                SQNdata.append((x: Double(index), y: model.sleepQuantity ?? 0))
                tenDLdata.append((x: Double(index), y: model.tenDayLoad ?? 0))
                fiveDRRdata.append((x: Double(index), y: model.fiveDayRecovery ?? 0))
                fiveDRLdata.append((x: Double(index), y: model.fiveDayLoad ?? 0))
                fiveDIRdata.append((x: Double(index), y: model.fiveDayImpactReadiness ?? 0))
                IRdata.append((x: Double(index), y: model.impactReadiness ?? 0))

                //look if there is data for the previous day. If not mark the previous space with no data
                if index > 0 && withModels[datesOfCurrentWeek[index - 1]] == nil {
                    noDataViewsCollection[index - 1].alpha = 1.0
                }
            } else {
                for noDataView in noDataViewsCollection where noDataView.tag == index {
                    noDataView.alpha = 1.0
                }
                IRdata.append((x: Double(index), y: average))
            }
        }

        let SQL = ChartSeries(data: SQLdata)
        SQL.color = .sleepQuality
        let SQN = ChartSeries(data: SQNdata)
        SQN.color = .sleepQuantity
        let tenDL = ChartSeries(data: tenDLdata)
        tenDL.color = .tenDayLoad
        let fiveDRR = ChartSeries(data: fiveDRRdata)
        fiveDRR.color = .fiveDayRecovery
        let fiveDRL = ChartSeries(data: fiveDRLdata)
        fiveDRL.color = .fiveDayLoad
        let fiveDIR = ChartSeries(data: fiveDIRdata)
        fiveDIR.color = .fiveDayImpactReadiness
        let IR = ChartSeries(data: IRdata)
        IR.color = .sand
        IR.width = 4.0

        //HERE handle single points drawing (i.e. first use case)

        //selected chart display logic
        for selection in selectionModel.myDataSelectionItems where selection.selected {
            switch selection.myDataExplanationSection {
            case .fiveDIR:
                chartView.add(fiveDIR)
            case .fiveDRL:
                chartView.add(fiveDRL)
            case .fiveDRR:
                chartView.add(fiveDRR)
            case .tenDL:
                chartView.add(tenDL)
            case .SQN:
                chartView.add(SQN)
            case .SQL:
                chartView.add(SQL)
            default:
                break
            }
        }
        chartView.add(IR)
    }
}
