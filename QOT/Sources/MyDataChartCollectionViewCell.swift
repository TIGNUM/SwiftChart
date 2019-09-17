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
    @IBOutlet private var alignmentViewsCollection: [UIView]!
    @IBOutlet private weak var upperValueLabel: UILabel!
    @IBOutlet private weak var lowerValueLabel: UILabel!
    @IBOutlet private weak var chartViewBottomConstraint: NSLayoutConstraint!
    private var addedViews: [UIView] = []
    private let largePointSize: CGFloat = 10.0
    private let normalPointSize: CGFloat = 5.0
    private let largeGraphWidth: CGFloat = 4.0
    private let defaultAverage: Double = 70.0
    // MARK: Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        setupChart()
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
        chartView.showYGridDashed = false
        chartView.showXGridDashed = true
        chartView.showXLabelsAndGrid = true
        chartView.showYLabelsAndGrid = true
        chartView.isUserInteractionEnabled = false
        chartView.yLabels = [33, 67]
    }

    // MARK: Public

    func configure(withModels: [Date: MyDataDailyCheckInModel], selectionModel: MyDataSelectionModel) {
        //initial reset after reuse
        chartView.removeAllSeries()
        for view in addedViews {
            view.removeFromSuperview()
        }

        var averageData: [(x: Double, y: Double)] = []
        guard let firstModelDate = withModels.first?.key else {
            for index in 0...6 {
                averageData.append((x: Double(index), y: defaultAverage))
            }
            let averageSeries = ChartSeries(data: averageData)
            averageSeries.color = .sand40
            averageSeries.dashed = true
            chartView.add(averageSeries)
            let irAverageLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
            addSubview(irAverageLabel)
            addedViews.append(irAverageLabel)
            setup(irAverageLabel: irAverageLabel, forValue: defaultAverage)
            return
        }

        let average = withModels.first?.value.averageUsersImpactReadiness ?? defaultAverage
        let futureLoad = withModels.first?.value.tenDaysFutureLoad
        chartView.yLabels = [33, 67]
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
                    alignmentViewsCollection[index - 1].alpha = 1.0
                }
            }
            averageData.append((x: Double(index), y: average))
        }

        let sql = ChartSeries(data: sqlData)
        sql.color = .sleepQuality
        let sqn = ChartSeries(data: sqnData)
        sqn.color = .sleepQuantity
        let tenDL = ChartSeries(data: tenDLdata)
        tenDL.color = .tenDayLoad
        let fiveDRR = ChartSeries(data: fiveDRRdata)
        fiveDRR.color = .fiveDayRecovery
        let fiveDRL = ChartSeries(data: fiveDRLdata)
        fiveDRL.color = .fiveDayLoad
        let fiveDIR = ChartSeries(data: fiveDIRdata)
        fiveDIR.color = .fiveDayImpactReadiness
        let ir = ChartSeries(data: irData)
        ir.color = .sand
        ir.width = largeGraphWidth
        let averageSeries = ChartSeries(data: averageData)
        averageSeries.color = .sand40
        averageSeries.dashed = true

        var selectedParameters: [MyDataParameter] = []

        //selected chart display logic
        for selection in selectionModel.myDataSelectionItems where selection.selected {
            selectedParameters.append(selection.myDataExplanationSection)
            switch selection.myDataExplanationSection {
            case .fiveDIR:
                chartView.add(fiveDIR)
            case .fiveDRL:
                chartView.add(fiveDRL)
            case .fiveDRR:
                chartView.add(fiveDRR)
            case .tenDL:
                chartView.add(tenDL)
                if let tenDayFutureLoad = futureLoad,
                   tenDLdata.count < 7 && tenDLdata.count > 0,
                   let lastValue = tenDLdata.last {
                   let futureData: [(x: Double, y: Double)] = [(x: lastValue.x, y: lastValue.y), (x: Double(6), y: Double(tenDayFutureLoad))]
                   let futureSeries = ChartSeries(data: futureData)
                    futureSeries.color = .tenDayLoad
                    futureSeries.dashed = true
                    chartView.add(futureSeries)
                }
            case .SQN:
                chartView.add(sqn)
            case .SQL:
                chartView.add(sql)
            default:
                break
            }
        }

        //HERE handle single points drawing (i.e. first use case)
        drawRectangles(forDataPoints: getDataParameters(inModels: withModels, with: selectedParameters))

        chartView.add(ir)
        chartView.add(averageSeries)
        let irAverageLabel = UILabel.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20))

        addSubview(irAverageLabel)
        addedViews.append(irAverageLabel)
        setup(irAverageLabel: irAverageLabel, forValue: average)

    }

    func setup(irAverageLabel: UILabel, forValue: Double) {
        ThemeText.myDataChartIRAverageLabel.apply(ScreenTitleService.main.myDataGraphIrAverageTitle(), to: irAverageLabel)
        for view in alignmentViewsCollection where view.tag == 1 {
            createPositionConstraints(forView: irAverageLabel,
                                      and: view,
                                      with: calculateBottomConstraintDifference(for: forValue) - 10.0,
                                      toLeadingOfView: true,
                                      centeredCompensation: false)
        }
    }

    func datesOfTheWeek(thatContains date: Date) -> [Date] {
        var dates: [Date] = []
        let firstDay = date.firstDayOfWeek()
        for dayIndex in 0...6 {
            dates.append(firstDay.dateAfterDays(dayIndex))
        }
        return dates
    }

    func getDataParameters(inModels: [Date: MyDataDailyCheckInModel], with selectedParameters: [MyDataParameter]) -> [MyDataParameter: [(x: Double, y: Double)]] {
        var resultsDictionary: [MyDataParameter: [(x: Double, y: Double)]] = [:]
        var selectedResults: [MyDataParameter] = [.IR]
        selectedResults.append(contentsOf: selectedParameters)
        for dictModel in inModels {
            let model = dictModel.value
            let datesOfCurrentWeek = datesOfTheWeek(thatContains: model.date)
            for parameter in selectedResults {
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
                    pointsArray.append((x: Double(datesOfCurrentWeek.index(of: model.date) ?? model.date.dayOfWeek - 1), y: value))
                }
                if resultsDictionary[parameter] == nil {
                    resultsDictionary[parameter] = pointsArray
                } else {
                    resultsDictionary[parameter]?.append(contentsOf: pointsArray)
                }
            }
        }
        return resultsDictionary
    }

    func drawRectangles(forDataPoints: [MyDataParameter: [(x: Double, y: Double)]]) {
        for parameter in MyDataParameter.allCases {
            if let existingPoints = forDataPoints[parameter] {
                for point in existingPoints {
                    let pointView = UIView.init(frame: .zero)
                    pointView.backgroundColor = MyDataExplanationModel.color(for: parameter)
                    addSubview(pointView)
                    bringSubview(toFront: pointView)
                    addedViews.append(pointView)
                    var alignmentView: UIView = UIView()
                    for view in alignmentViewsCollection where view.tag == Int(point.x) {
                        alignmentView = view
                    }
                    let width: CGFloat = parameter == .IR ? largePointSize: normalPointSize
                    pointView.frame = CGRect(x: 0, y: 0, width: width, height: width)
                    pointView.circle()
                    createPositionConstraints(for: pointView,
                                              andPointViewWidth: width,
                                              and: alignmentView,
                                              toLeadingOfView: true,
                                              with: calculateBottomConstraintDifference(for: point.y))
                }
            }
        }
    }

    func createPositionConstraints(for pointView: UIView,
                                   andPointViewWidth width: CGFloat,
                                   and alignmentView: UIView,
                                   toLeadingOfView: Bool,
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
        pointView.addConstraints([heightConstraint, widthConstraint])
        createPositionConstraints(forView: pointView,
                                  and: alignmentView,
                                  with: bottomConstant,
                                  toLeadingOfView: toLeadingOfView,
                                  centeredCompensation: true)
    }

    func createPositionConstraints(forView: UIView,
                                   and alignmentView: UIView,
                                   with bottomConstant: CGFloat,
                                   toLeadingOfView: Bool,
                                   centeredCompensation: Bool) {
        forView.translatesAutoresizingMaskIntoConstraints = false
        let leadingConstraint = NSLayoutConstraint.init(item: forView,
                                                        attribute: .leading,
                                                        relatedBy: .equal,
                                                        toItem: alignmentView,
                                                        attribute: toLeadingOfView ? .leading : .trailing,
                                                        multiplier: 1,
                                                        constant: centeredCompensation ? -(forView.frame.size.width / 2) : 0)
        let bottomConstraint = NSLayoutConstraint.init(item: forView,
                                                       attribute: .bottom,
                                                       relatedBy: .equal,
                                                       toItem: self,
                                                       attribute: .bottom,
                                                       multiplier: 1,
                                                       constant: centeredCompensation ? bottomConstant + (forView.frame.size.height / 2) : bottomConstant)
        self.addConstraints([leadingConstraint, bottomConstraint])
    }

    func calculateBottomConstraintDifference(for yPoint: Double) -> CGFloat {
        return chartViewBottomConstraint.constant - CGFloat(yPoint) * self.chartView.frame.height / 100
    }
}
