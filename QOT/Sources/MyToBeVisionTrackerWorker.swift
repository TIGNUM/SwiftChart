//
//  MyToBeVisionTrackerWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 04.07.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class MyToBeVisionTrackerWorker {

    enum ControllerType: String {
        case tracker
        case data
    }

    private let userService: qot_dal.UserService
    private let contentService: qot_dal.ContentService
    var dataModel: MYTBVDataViewModel?
    private let dispatchGroup = DispatchGroup()
    private var report: QDMToBeVisionRatingReport?
    private var graphHeading: String = ""
    private var subTitle: String = ""
    private var title: String = ""
    var controllerType: ControllerType = .tracker

    init(userService: qot_dal.UserService,
         contentService: qot_dal.ContentService,
         controllerType: ControllerType) {
        self.userService = userService
        self.contentService = contentService
        self.controllerType = controllerType
    }

    func getData(_ completion: @escaping (MYTBVDataViewModel?) -> Void) {
        getRatingReport()
        getSubTitle()
        getGraphHeading()
        getTitle()

        dispatchGroup.notify(queue: .main) {[weak self] in
            guard let report = self?.report else {
                completion(nil)
                return
            }
            let graphAverages = report.averages.compactMap({ args -> TBVGraph.Rating? in
                return TBVGraph.Rating(isSelected: false, rating: CGFloat(args.value), ratingTime: args.key)
            }).sorted(by: { (firstRating, secondRating) -> Bool in
                return firstRating.ratingTime?.compare(secondRating.ratingTime ?? Date()) == .orderedAscending
            })

            let answers = report.sentences.compactMap({ sentence -> MYTBVDataAnswer in
                let ratings = sentence.ratings.compactMap({ args -> MYTBVDataRating in
                    return MYTBVDataRating(value: args.value, date: args.key, isSelected: false)
                }).sorted(by: { (firstRating, secondRating) -> Bool in
                    return firstRating.date?.compare(secondRating.date ?? Date()) == .orderedAscending
                })
                return MYTBVDataAnswer(answer: sentence.text, ratings: ratings)
            })
            let model = self?.getData(for: graphAverages, and: answers)
            self?.dataModel = model
            self?.dataModel?.selectedDate = graphAverages.last?.ratingTime
            let finalModel = self?.setSelection(for: self?.dataModel?.selectedDate)
            completion(finalModel)
        }
    }

    private func getRatingReport() {
        dispatchGroup.enter()
        userService.getToBeVisionTrackingReport(last: 3) {[weak self] (report) in
            self?.report = report
            self?.dispatchGroup.leave()
        }
    }

    func setSelection(for date: Date?) -> MYTBVDataViewModel? {
        answers(for: date)
        setSelected(for: date)
        return dataModel
    }

    private func setSelected(for date: Date?) {
        let ratings = dataModel?.graph?.ratings?.compactMap({ (rating) -> TBVGraph.Rating in
            var newRating = rating
            newRating.isSelected = rating.ratingTime == date
            return newRating
        })
        dataModel?.graph?.ratings = ratings

        let answers = dataModel?.selectedAnswers?.compactMap({ (answer) -> MYTBVDataAnswer in
            var newAnswer = answer
            for i in 0...newAnswer.ratings.count - 1 {
                var rating = newAnswer.ratings[i]
                rating.isSelected = rating.date == date
                newAnswer.ratings[i] = rating
            }
            return newAnswer
        })
        dataModel?.selectedAnswers = answers
    }

    private func answers(for date: Date?) {
        guard let answers = dataModel?.answers else { return }
        var finalAnswers: [MYTBVDataAnswer] = []
        for answer in answers {
            if answer.ratings.filter({ $0.value != nil && $0.date == date }).count > 0 {
                finalAnswers.append(answer)
            }
        }
        dataModel?.selectedAnswers = finalAnswers
    }

    private func getData(for ratings: [TBVGraph.Rating], and answers: [MYTBVDataAnswer]) -> MYTBVDataViewModel? {
        let graph = MYTBVDataGraph(heading: graphHeading, ratings: ratings)
        let subHeading = MYTBVDataSubHeading(title: subTitle, isSelected: false)
        return MYTBVDataViewModel(title: title ,
                                  subHeading: subHeading,
                                  graph: graph,
                                  answers: answers,
                                  selectedDate: nil,
                                  selectedAnswers: nil)
    }

    func getSubTitle() {
        dispatchGroup.enter()
        var predicate: NSPredicate = ContentService.TBVTracker.subtitle.predicate
        if controllerType == .data {
            predicate = ContentService.TBVData.subtitle.predicate
        }
        contentService.getContentItemByPredicate(predicate) {[weak self] (contentItem) in
            self?.subTitle = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func getTitle() {
        dispatchGroup.enter()
        var predicate: NSPredicate = ContentService.TBVTracker.title.predicate
        if controllerType == .data {
            predicate = ContentService.TBVData.title.predicate
        }
        contentService.getContentItemByPredicate(predicate) {[weak self] (contentItem) in
            self?.title = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }

    func getGraphHeading() {
        dispatchGroup.enter()
        var predicate: NSPredicate = ContentService.TBVTracker.graphTitle.predicate
        if controllerType == .data {
            predicate = ContentService.TBVData.graphTitle.predicate
        }
        contentService.getContentItemByPredicate(predicate) {[weak self] (contentItem) in
            self?.graphHeading = contentItem?.valueText ?? ""
            self?.dispatchGroup.leave()
        }
    }
}
