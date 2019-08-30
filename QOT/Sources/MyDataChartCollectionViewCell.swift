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
    @IBOutlet private weak var chartView: Chart!
    @IBOutlet private var noDataViewsCollection: [UIImageView]!
    @IBOutlet private weak var upperValueLabel: UILabel!
    @IBOutlet private weak var lowerValueLabel: UILabel!
    @IBOutlet private weak var noDataLabel: UILabel!
    @IBOutlet private weak var chartViewBottomConstraint: NSLayoutConstraint!
    private var pointViews: [UIView] = []

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
        chartView.topInset = 0
        chartView.bottomInset = 0

        let maxString = upperValueLabel.text ?? "100"
        let minString = lowerValueLabel.text ?? "0"
        chartView.minY = Double(minString)
        chartView.maxY = Double(maxString)
        chartView.minX = 0
        chartView.maxX = 6

        chartView.showXLabelsAndGrid = false
        chartView.showYLabelsAndGrid = true
    }

    private func setupView() {
        ThemeText.sectionHeader.apply(ScreenTitleService.main.myDataGraphNoDataTitle(), to: noDataLabel)
    }

    // MARK: Public

    func configure(withModels: [Date: MyDataDailyCheckInModel], selectionModel: MyDataSelectionModel, average: Double = 70) {
        //initial reset after reuse
        chartView.removeAllSeries()
        for view in pointViews {
            view.removeFromSuperview()
        }
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
        var sqlData: [(x: Double, y: Double)] = []
        var sqnData: [(x: Double, y: Double)] = []
        var tenDLdata: [(x: Double, y: Double)] = []
        var fiveDRRdata: [(x: Double, y: Double)] = []
        var fiveDRLdata: [(x: Double, y: Double)] = []
        var fiveDIRdata: [(x: Double, y: Double)] = []
        var irData: [(x: Double, y: Double)] = []
        let datesOfCurrentWeek = datesOfTheWeek(thatContains: firstModelDate)
        for (index, day) in datesOfCurrentWeek.enumerated() {
            if let model = withModels[day] {
                if let sqlValue = model.sleepQuality { sqlData.append((x: Double(index), y: sqlValue)) }
                if let sqnValue = model.sleepQuantity { sqnData.append((x: Double(index), y: sqnValue)) }
                if let tdlValue = model.tenDayLoad { tenDLdata.append((x: Double(index), y: tdlValue)) }
                if let fdrValue = model.fiveDayRecovery { fiveDRRdata.append((x: Double(index), y: fdrValue)) }
                if let fdlValue = model.fiveDayLoad { fiveDRLdata.append((x: Double(index), y: fdlValue)) }
                if let fdirValue = model.fiveDayImpactReadiness { fiveDIRdata.append((x: Double(index), y: fdirValue)) }
                if let irValue = model.impactReadiness { irData.append((x: Double(index), y: irValue)) }
                //look if there is data for the previous day. If not mark the previous space with no data
                if index > 0 && withModels[datesOfCurrentWeek[index - 1]] == nil {
                    noDataViewsCollection[index - 1].alpha = 1.0
                }
            } else {
                for noDataView in noDataViewsCollection where noDataView.tag == index {
                    noDataView.alpha = 1.0
                }
                irData.append((x: Double(index), y: average))
            }
        }
        let SQL = ChartSeries(data: sqlData)
        SQL.color = .sleepQuality
        let SQN = ChartSeries(data: sqnData)
        SQN.color = .sleepQuantity
        let tenDL = ChartSeries(data: tenDLdata)
        tenDL.color = .tenDayLoad
        let fiveDRR = ChartSeries(data: fiveDRRdata)
        fiveDRR.color = .fiveDayRecovery
        let fiveDRL = ChartSeries(data: fiveDRLdata)
        fiveDRL.color = .fiveDayLoad
        let fiveDIR = ChartSeries(data: fiveDIRdata)
        fiveDIR.color = .fiveDayImpactReadiness
        let IR = ChartSeries(data: irData)
        IR.color = .sand
        IR.width = 4.0
        //HERE handle single points drawing (i.e. first use case)
        drawRectangles(forIsolatedPoints: findIsolatedValues(inModels: withModels))
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

    func datesOfTheWeek(thatContains date: Date) -> [Date] {
        var dates: [Date] = []
        let firstDay = date.firstDayOfWeek()
        for dayIndex in 0...6 {
            dates.append(firstDay.dateAfterDays(dayIndex))
        }
        return dates
    }

    func findIsolatedValues(inModels: [Date: MyDataDailyCheckInModel]) -> [MyDataParameter: [(x: Double, y: Double)]] {
        var resultsDictionary: [MyDataParameter: [(x: Double, y: Double)]] = [:]
        for dictModel in inModels {
            let model = dictModel.value
            if inModels[model.date.dateAfterDays(1)] == nil && inModels[model.date.dateAfterDays(-1)] == nil {
                for parameter in MyDataParameter.allCases {
                    var pointsArray: [(x: Double, y: Double)] = []
                    var parameterValue: Double?
                    switch parameter {
                    case .IR:
                        parameterValue = model.impactReadiness
                    case .fiveDIR:
                        parameterValue = model.fiveDayImpactReadiness
                    case .fiveDRR:
                        parameterValue = model.fiveDayRecovery
                    case .fiveDRL:
                        parameterValue = model.fiveDayLoad
                    case .tenDL:
                        parameterValue = model.tenDayLoad
                    case .SQL:
                        parameterValue = model.sleepQuality
                    case .SQN:
                        parameterValue = model.sleepQuantity
                    }
                    if let value = parameterValue {
                        pointsArray.append((x: Double(model.date.dayOfWeek - 1), y: value))
                    }
                    resultsDictionary[parameter] = pointsArray
                }
            }
        }
        return resultsDictionary
    }

    func drawRectangles(forIsolatedPoints: [MyDataParameter: [(x: Double, y: Double)]]) {
        for parameter in MyDataParameter.allCases {
            if let existingPoints = forIsolatedPoints[parameter] {
                for point in existingPoints {
                    let pointView = UIView.init(frame: .zero)
                    pointView.backgroundColor = MyDataExplanationModel.color(for: parameter)
                    addSubview(pointView)
                    bringSubview(toFront: pointView)
                    pointViews.append(pointView)
                    var alignmentView: UIImageView = UIImageView()
                    for view in noDataViewsCollection where view.tag == Int(point.x) {
                        alignmentView = view
                    }
                    let width: CGFloat = parameter == .IR ? 10.0 : 5.0
                    createPositionConstraints(for: pointView,
                                              andPointViewWidth: width,
                                              and: alignmentView,
                                              with: calculateBottomConstraintDifference(for: point.y))
                }
            }
        }
    }

    func createPositionConstraints(for pointView: UIView,
                                   andPointViewWidth width: CGFloat,
                                   and alignmentView: UIView,
                                   with bottomConstant: CGFloat) {
        pointView.translatesAutoresizingMaskIntoConstraints = false
        let heightConstraint = NSLayoutConstraint.init(item: pointView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .notAnAttribute,
                                                       multiplier: 1,
                                                       constant: width)
        let widthConstraint = NSLayoutConstraint.init(item: pointView,
                                                      attribute: .width,
                                                      relatedBy: .equal,
                                                      toItem: nil,
                                                      attribute: .notAnAttribute,
                                                      multiplier: 1,
                                                      constant: width)
        let leadingConstraint = NSLayoutConstraint.init(item: pointView,
                                                        attribute: .leading,
                                                        relatedBy: .equal,
                                                        toItem: alignmentView,
                                                        attribute: .leading,
                                                        multiplier: 1,
                                                        constant: -(width / 2))
        let bottomConstraint = NSLayoutConstraint.init(item: pointView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .bottom,
                                                       multiplier: 1,
                                                       constant: bottomConstant + (width / 2))
        pointView.addConstraints([heightConstraint, widthConstraint])
        self.addConstraints([leadingConstraint, bottomConstraint])
    }

    func calculateBottomConstraintDifference(for yPoint: Double) -> CGFloat {
        return chartViewBottomConstraint.constant - CGFloat(yPoint) * self.chartView.frame.height / 100
    }
}
