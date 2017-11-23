//
//  WeeklyChoicesViewModel.swift
//  QOT
//
//  Created by karmic on 18.04.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import ReactiveKit
import RealmSwift

protocol WeeklyChoicesViewModelDelegate: class {

    func fetchWeeklyChoices()
}

final class WeeklyChoicesViewModel {

    struct WeeklyChoicePage {
        // TODO: should this be dynamic based on Layout.MeSection.maxWeeklyPage?
        var weekStart: Date
        var choice1: WeeklyChoice?
        var choice2: WeeklyChoice?
        var choice3: WeeklyChoice?
        var choice4: WeeklyChoice?
        var choice5: WeeklyChoice?

        init(weekStart: Date, choices: [WeeklyChoice]) {
            self.weekStart = weekStart
            self.choice1 = (choices.count >= 1) ? choices[0] : nil
            self.choice2 = (choices.count >= 2) ? choices[1] : nil
            self.choice3 = (choices.count >= 3) ? choices[2] : nil
            self.choice4 = (choices.count >= 4) ? choices[3] : nil
            self.choice5 = (choices.count >= 5) ? choices[4] : nil
        }
    }

    // MARK: - Properties

    private let services: Services
    private var userChoices: AnyRealmCollection<UserChoice>
    var items: [WeeklyChoicePage] = []
    let updates = PublishSubject<CollectionUpdate, NoError>()

    var itemCount: Int {
        return items.count * itemsPerWeek
    }

    var itemsPerWeek: Int {
        return Layout.MeSection.maxWeeklyPage
    }

    // MARK: - Init
    
    init(services: Services) {
        self.services = services
        self.userChoices = services.userService.userChoices()
        loadWeeklyChoices()
    }

    func pageDates(forIndex index: Index) -> String {
        guard index >= items.startIndex, index < items.endIndex else {
            return ""
        }
        let weekChoices = items[index]
        let weekEnd = weekChoices.weekStart + TimeInterval(6 * 24 * 3600)

        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMd")
        dateFormatter.locale = Locale.current
        
        return "\(dateFormatter.string(from: weekChoices.weekStart)) // \(dateFormatter.string(from: weekEnd))"
    }

    func choiceNumber(forIndex index: Index) -> String {
        let choiceNumber = index % itemsPerWeek + 1

        return ".0\(choiceNumber) \(R.string.localized.meSectorMyWhyWeeklyChoicesChoice())"
    }

    func item(at index: Index) -> WeeklyChoice? {
        let week = index / itemsPerWeek
        let choiceNumber = index % itemsPerWeek
        let weekChoices = items[week]

        switch choiceNumber {
        case 0: return weekChoices.choice1
        case 1: return weekChoices.choice2
        case 2: return weekChoices.choice3
        case 3: return weekChoices.choice4
        case 4: return weekChoices.choice5
        default: return nil
        }
    }
    
    func categoryName(weeklyChoice: WeeklyChoice) -> String {
        return services.contentService.contentCategory(id: weeklyChoice.categoryID)?.title ?? ""
    }
    
    // MARK: - private
    
    private func loadWeeklyChoices() {
        guard userChoices.count > 0 else {
            return
        }
        let sortedUserChoices = userChoices.sorted { $0.startDate > $1.startDate }
        var index = 0
        repeat {
            let date = sortedUserChoices[index].startDate
            let filteredUserChoices = Array(userChoices.filter { $0.startDate == date })
            let cappedChoices = (filteredUserChoices.count > itemsPerWeek) ? Array(filteredUserChoices[0...itemsPerWeek-1]) : filteredUserChoices
            let weeklyChoices = weeklyChoicesFromUserChoices(cappedChoices)
            let page = WeeklyChoicePage(weekStart: date, choices: weeklyChoices)
            items.append(page)
            index += filteredUserChoices.count
        } while index < userChoices.count
    }

    private func weeklyChoicesFromUserChoices(_ userChoices: [UserChoice]) -> [WeeklyChoice] {
        return userChoices.map { (userChoice: UserChoice) -> WeeklyChoice in
            var title: String?
            if let contentCollectionID = userChoice.contentCollectionID, let contentCollection = self.services.contentService.contentCollection(id: contentCollectionID) {
                title = contentCollection.title
            }
            return WeeklyChoice(
                localID: userChoice.localID,
                contentCollectionID: userChoice.contentCollectionID ?? 0,
                categoryID: userChoice.contentCategoryID ?? 0,
                title: title,
                startDate: userChoice.startDate,
                endDate: userChoice.endDate,
                selected: true
            )
        }
    }
}

// MARK: - WeeklyChoicesViewModelDelegate

extension WeeklyChoicesViewModel: WeeklyChoicesViewModelDelegate {

    func fetchWeeklyChoices() {        
        loadWeeklyChoices()
        updates.next(.reload)
    }
}
