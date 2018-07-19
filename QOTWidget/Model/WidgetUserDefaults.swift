//
//  UserDefaultValues.swift
//  QOTWidget
//
//  Created by Javier Sanz Rozalen on 09/07/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

enum SuiteName: String {
	case widget = "group.widget.com.tignum.qot.novartis"
}

enum WidgetUserDefaults: String {
	case toBeVisionHeadline = "qot.userdefault.key.toBeVisionHeadline"
	case toBeVisionText = "qot.userdefault.key.tobevisionText"
	case toBeVisionImageURL = "qot.userdefault.key.toBeVisionImageURL"
	case eventName = "qot.userdefault.key.upcomingEventName"
	case eventDate = "qot.userdefault.key.upcomingEventDate"
	case eventNumberOfTasks = "qot.userdefault.key.upcomingEventNumberOfTasks"
	case eventTasksCompleted = "qot.userdefault.key.upcomingEventTasksCompleted"
	case weeklyChoices = "qot.userdefault.key.weeklyChoices"
	case isUserSignedIn = "qot.userdefault.key.isUserSignedIn"
	
	func value() -> Any? {
		return UserDefaults(suiteName: SuiteName.widget.rawValue)?.object(forKey: rawValue)
	}
	
	func clearWidgetObject() {
		let userDefaults = UserDefaults(suiteName: SuiteName.widget.rawValue)
		userDefaults?.removeObject(forKey: self.rawValue)
		userDefaults?.synchronize()
	}
	
	static func widgetObjectsToClearOnLogout() -> [WidgetUserDefaults] {
		return [.toBeVisionHeadline,
				.toBeVisionText,
				.toBeVisionImageURL,
				.eventName,
				.eventDate,
				.eventNumberOfTasks,
				.eventTasksCompleted,
                .weeklyChoices,
				.isUserSignedIn]
	}
	
	static func setToBeVision(headline: String?, text: String?, url: URL?) {
		let userDefaults = UserDefaults(suiteName: SuiteName.widget.rawValue)
		userDefaults?.set(headline, forKey: toBeVisionHeadline.rawValue)
		userDefaults?.set(text, forKey: toBeVisionText.rawValue)
		userDefaults?.set(url, forKey: toBeVisionImageURL.rawValue)
		userDefaults?.synchronize()
	}
	
	static func setUpcomingEvent(name: String?, date: Date?, numberOfTasks: Int?, tasksCompleted: Int?) {
		let userDefaults = UserDefaults(suiteName: SuiteName.widget.rawValue)
		userDefaults?.set(name, forKey: eventName.rawValue)
		userDefaults?.set(date, forKey: eventDate.rawValue)
		userDefaults?.set(numberOfTasks, forKey: eventNumberOfTasks.rawValue)
		userDefaults?.set(tasksCompleted, forKey: eventTasksCompleted.rawValue)
		userDefaults?.synchronize()
	}
	
	static func setWeeklyChoices(weeklyChoices: [String]?) {
		let userDefaults = UserDefaults(suiteName: SuiteName.widget.rawValue)
		userDefaults?.set(weeklyChoices, forKey: self.weeklyChoices.rawValue)
		userDefaults?.synchronize()
	}
	
	static func setIsUserSignedIn(value: Bool) {
		UserDefaults(suiteName: SuiteName.widget.rawValue)?.set(value, forKey: isUserSignedIn.rawValue)
	}
	
	static func toBeVision() -> WidgetModel.ToBeVision? {
		guard let userDefaults = UserDefaults(suiteName: SuiteName.widget.rawValue) else { return nil }
		return WidgetModel.ToBeVision(headline: userDefaults.string(forKey: toBeVisionHeadline.rawValue),
									  text: userDefaults.string(forKey: toBeVisionText.rawValue),
									  imageURL: userDefaults.url(forKey: toBeVisionImageURL.rawValue))
	}
	
	static func upcomingEvent() -> WidgetModel.UpcomingEvent? {
		guard let userDefaults = UserDefaults(suiteName: SuiteName.widget.rawValue) else { return nil }
		return WidgetModel.UpcomingEvent(eventName: userDefaults.string(forKey: eventName.rawValue),
										 eventDate: userDefaults.object(forKey: eventDate.rawValue) as? Date,
										 numberOfTasks: userDefaults.integer(forKey: eventNumberOfTasks.rawValue),
										 tasksCompleted: userDefaults.integer(forKey: eventTasksCompleted.rawValue))
	}
	
	static func latestWeeklyChoices() -> WidgetModel.WeeklyChoices? {
		guard let userDefaults = UserDefaults(suiteName: SuiteName.widget.rawValue) else { return nil }
		return WidgetModel.WeeklyChoices(latestWeeklyChoices: userDefaults.stringArray(forKey: weeklyChoices.rawValue))
	}
}
