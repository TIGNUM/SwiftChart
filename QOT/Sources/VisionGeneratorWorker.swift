//
//  VisionGeneratorWorker.swift
//  QOT
//
//  Created by karmic on 10.04.18.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift

final class VisionGeneratorWorker {

    private let services: Services
    private let questionService: QuestionsService
    private let networkManager: NetworkManager
    private let chatViewModel: ChatViewModel<VisionGeneratorChoice>
    private let syncManager: SyncManager
    private var currentQuestionType: VisionGeneratorChoice.QuestionType?
    private var visionModel: MyToBeVisionModel.Model?
    private var currentVisionModel: MyToBeVisionModel.Model?
    private var allChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]]
    private var didLoadLastQuestion = false
    private let createVisionPresentDelay = DispatchTimeInterval.seconds(1)
    private let readingVisionPresentDelay = DispatchTimeInterval.seconds(10)
    private let navigationItem: NavigationItem?
    private var visionSaved = false

    init(services: Services,
         networkManager: NetworkManager,
         chatViewModel: ChatViewModel<VisionGeneratorChoice>,
         visionModel: MyToBeVisionModel.Model?,
         syncManager: SyncManager,
         allChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]],
         navigationItem: NavigationItem?) {
        self.services = services
        self.questionService = services.questionsService
        self.networkManager = networkManager
        self.chatViewModel = chatViewModel
        self.visionModel = visionModel
        self.currentVisionModel = visionModel
        self.syncManager = syncManager
        self.allChatItems = allChatItems
        self.navigationItem = navigationItem
        updateViewModel(with: allChatItems[.intro] ?? [])
    }

    func contentItem(for contentItemID: Int) -> ContentItem? {
        return services.contentService.contentItem(id: contentItemID)
    }

    func visionSelectionCount(for questionType: VisionGeneratorChoice.QuestionType) -> Int {
        return chatViewModel.visionSelectionCount(for: questionType)
    }

    var questionType: VisionGeneratorChoice.QuestionType {
        return currentQuestionType ?? VisionGeneratorChoice.QuestionType.intro
    }

    var model: MyToBeVisionModel.Model? {
        return visionModel
    }

    var navItem: NavigationItem? {
        return navigationItem
    }

    var shouldShowAlertVisionNotSaved: Bool {
        return questionType.visionGenerated == true && visionSaved == false
    }

    var alertModel: VisionGeneratorAlertModel? {
        return services.contentService.visionGeneratorAlertModelNotSaved()
    }

    private var headline: String? {
		let currentHeadline = services.userService.myToBeVision()?.headline
		let initialHeadlinePlaceholder = services.contentService.toBeVisionHeadlinePlaceholder()
        if currentHeadline == nil || currentHeadline == initialHeadlinePlaceholder {
            return services.contentService.toBeVisionToolingHeadlinePlaceholder()?.uppercased()
        }
        return services.userService.myToBeVision()?.headline?.uppercased()
    }
}

extension VisionGeneratorWorker {

    func saveVision() {
        services.userService.saveVision(currentVisionModel)
        syncManager.syncMyToBeVision()
        visionSaved = true
    }

    func saveImage(_ image: UIImage) throws {
        do {
            let imageURL = try image.save(withName: UUID().uuidString)
            currentVisionModel?.imageURL = imageURL
            currentVisionModel?.lastUpdated = Date()
            visionModel?.imageURL = imageURL
        } catch {
            log("Error while saving TBV image: \(error.localizedDescription)")
        }
    }

    func bottomButtonTitle(_ choice: VisionGeneratorChoice) -> String {
        guard let type = currentQuestionType else { return "" }
        switch (type, visionSelectionCount(for: type)) {
        case (.work, 0..<4): return type.bottomButtonTitle(selectedItemCount: visionSelectionCount(for: .work))
        case (.work, 4): return "Continue"
        case (.home, 0..<4): return type.bottomButtonTitle(selectedItemCount: visionSelectionCount(for: .home))
        case (.home, 4): return "Create my To Be Vision"
        default: return ""
        }
    }

    func updateViewModel(with items: [ChatItem<VisionGeneratorChoice>]) {
        guard items.isEmpty == false, didLoadLastQuestion == false else { return }
        if currentQuestionType == .review {
            didLoadLastQuestion = true
        }
        chatViewModel.appendItems(items)
    }

    func updateViewModel(for questionType: VisionGeneratorChoice.QuestionType) {
        currentQuestionType = questionType
        if currentQuestionType == .create {
            displayCreatedVision(for: questionType)
        } else {
            updateViewModel(with: allChatItems[questionType] ?? [])
        }
    }

    func restartGenerator() {
        currentQuestionType = .intro
        allChatItems = /*services.questionsService.visionChatItems*/ [:]
        chatViewModel.resetVisionSelections()
        chatViewModel.setItems([])
        updateViewModel(for: .intro)
    }

    func chatItems(for targetID: Int) -> [ChatItem<VisionGeneratorChoice>] {
//        if let question = questionService.visionQuestion(for: targetID) {
//            setCurrentQuestionType(question)
//        }
//        guard let type = currentQuestionType else { return [] }
//        return allChatItems[type] ?? []
        return []
    }

    func fetchMediaURL(contentItemID: Int) -> URL? {
        guard let urlString = services.contentService.contentItem(id: contentItemID)?.valueMediaURL else { return nil }
        return URL(string: urlString)
    }
}

// MARK: - Private Generate Chat Items
private extension VisionGeneratorWorker {

    func displayCreatedVision(for questionType: VisionGeneratorChoice.QuestionType) {
//        let createQuestion = questionService.questionFor(questionType)
//        updateViewModel(with: [questionService.messageChatItem(text: createQuestion?.title ?? "",
//                                                               date: Date(),
//                                                               includeFooter: false,
//                                                               isAutoscrollSnapable: true,
//                                                               questionType: questionType)])
//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + createVisionPresentDelay) {
//            self.updateViewModel(with: [self.questionService.messageChatItem(text: self.createVision(),
//                                                                             date: Date(),
//                                                                             includeFooter: false,
//                                                                             isAutoscrollSnapable: false,
//                                                                             questionType: questionType)])
//        }
//        if let nextQuestion = questionService.visionQuestion(for: questionType.nextType) {
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + readingVisionPresentDelay) {
//                self.updateViewModel(with: self.questionService.chatItems(for: nextQuestion))
//            }
//        }
    }

    func string(from visionChoices: [VisionGeneratorChoice]) -> String {
        var visionList = [String]()
        let targetIDs = visionChoices.compactMap { $0.targetID }
        for targetID in targetIDs {
            let contentItems = services.contentService.contentItems(contentCollectionID: targetID)
            let userGender = (services.userService.user()?.gender ?? "NEUTRAL").uppercased()
            let genderQueryNeutral = "GENDER_NEUTRAL"
            let genderQuery = String(format: "GENDER_%@", userGender)
            let filteredItems = Array(contentItems.filter { $0.searchTags.contains(genderQuery) || $0.searchTags.contains(genderQueryNeutral) })
            guard filteredItems.isEmpty == false else { continue }
            if let randomItemText = filteredItems[filteredItems.randomIndex].valueText {
                visionList.append(randomItemText)
            }
        }

        return visionList.joined(separator: " ")
    }

    func createVision() -> String {
        let selectionsForWork = chatViewModel.visionChoiceSelections.filter { $0.type == .work }
        let selectionsForHome = chatViewModel.visionChoiceSelections.filter { $0.type == .home }
        var visions: [String] = []
        visions.append(string(from: selectionsForWork))
        visions.append(string(from: selectionsForHome))
        let vision = visions.joined(separator: "\n\n")
        currentVisionModel?.headLine = headline
        currentVisionModel?.text = vision
        currentVisionModel?.lastUpdated = Date()
        currentVisionModel?.workTags = selectionsForWork.map { $0.title }
        currentVisionModel?.homeTags = selectionsForHome.map { $0.title }
        return vision
    }

    func setCurrentQuestionType(_ question: Question) {
        currentQuestionType = VisionGeneratorChoice.QuestionType(rawValue: question.key ?? "")
    }

    func choiceType(for question: Question?) -> VisionGeneratorChoice.QuestionType {
        if let question = question, let type = VisionGeneratorChoice.QuestionType(rawValue: question.key ?? "") {
            return type
        }
        return .intro
    }
}
