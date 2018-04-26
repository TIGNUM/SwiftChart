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
    private var visionSelections = [VisionGeneratorChoice]()
    private var currentQuestionType: VisionGeneratorChoice.QuestionType?
    private var visionModel: MyToBeVisionModel.Model?
    private let allChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]]

    init(services: Services,
         networkManager: NetworkManager,
         chatViewModel: ChatViewModel<VisionGeneratorChoice>,
         syncManager: SyncManager,
         allChatItems: [VisionGeneratorChoice.QuestionType: [ChatItem<VisionGeneratorChoice>]]) {
        self.services = services
        self.questionService = services.questionsService
        self.networkManager = networkManager
        self.chatViewModel = chatViewModel
        self.syncManager = syncManager
        self.allChatItems = allChatItems
        updateViewModel(with: allChatItems[.intro] ?? [])
    }

    func visionSelectionCount(for questionType: VisionGeneratorChoice.QuestionType) -> Int {
        return visionSelections.filter { $0.type == questionType }.count
    }

    var questionType: VisionGeneratorChoice.QuestionType {
        return currentQuestionType ?? VisionGeneratorChoice.QuestionType.intro
    }

    var model: MyToBeVisionModel.Model? {
        return visionModel
    }
}

extension VisionGeneratorWorker {

    func saveVision(completion: (() -> Void)?) {
        guard
            let visionModel = self.visionModel,
            let old = services.userService.myToBeVision()  else { return }
        services.userService.updateMyToBeVision(old) {
            let headLine = $0.headline
            $0.headline = headLine
            $0.text = visionModel.text
            $0.date = Date()
            if let newImageURL = visionModel.imageURL,
                let resource = $0.profileImageResource,
                resource.url == URL.imageDirectory {
                $0.profileImageResource?.setLocalURL(newImageURL,
                                                       format: .jpg,
                                                       entity: .toBeVision,
                                                       entitiyLocalID: $0.localID)
            }
        }
        let manager = syncManager
        manager.upSync(MyToBeVision.self) { (_) in
            manager.downSync(MyToBeVision.self)
            completion?()
        }
    }

    func saveImage(_ image: UIImage) throws {
        do {
            let imageURL = try image.save(withName: UUID().uuidString)
            visionModel?.imageURL = imageURL
            visionModel?.lastUpdated = Date()
            saveVision(completion: nil)
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

    func updateVisionSelections(_ choice: VisionGeneratorChoice) {
        if (visionSelections.filter { $0.targetID == choice.targetID }).isEmpty == true {
            visionSelections.append(choice)
        } else {
            visionSelections = visionSelections.filter { $0.targetID != choice.targetID }
        }
    }

    func updateViewModel(with items: [ChatItem<VisionGeneratorChoice>]) {
        guard items.isEmpty == false else { return }
        chatViewModel.appendItems(items, shouldPop: currentQuestionType == .work || currentQuestionType == .home)
    }

    func updateViewModel(for questionType: VisionGeneratorChoice.QuestionType) {
        currentQuestionType = questionType
        if currentQuestionType == .create {
            displayCreatedVision(for: questionType)
        } else {
            updateViewModel(with: allChatItems[questionType] ?? [])
        }
    }

    func chatItems(for targetID: Int) -> [ChatItem<VisionGeneratorChoice>] {
        if let question = questionService.visionQuestion(for: targetID) {
            setCurrentQuestionType(question)
        }
        guard let type = currentQuestionType else { return [] }
        return allChatItems[type] ?? []
    }

    func fetchMediaURL(contentItemID: Int) -> URL? {
        guard let urlString = services.contentService.contentItem(id: contentItemID)?.valueMediaURL else { return nil }
        return URL(string: urlString)
    }
}

// MARK: - Private Generate Chat Items

private extension VisionGeneratorWorker {

    func displayCreatedVision(for questionType: VisionGeneratorChoice.QuestionType) {
        let createQuestion = questionService.questionFor(questionType)
        updateViewModel(with: [questionService.messageChatItem(text: createQuestion?.title ?? "",
                                                               date: Date(),
                                                               includeFooter: false,
                                                               isAutoscrollSnapable: true,
                                                               questionType: questionType)])
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            self.updateViewModel(with: [self.questionService.messageChatItem(text: self.createVision(),
                                                                             date: Date(),
                                                                             includeFooter: false,
                                                                             isAutoscrollSnapable: false,
                                                                             questionType: questionType)])
        }

        if let nextQuestion = questionService.visionQuestion(for: questionType.nextType) {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20) {
                self.updateViewModel(with: self.questionService.chatItems(for: nextQuestion))
            }
        }
    }

    func createVision() -> String {
        var visionList = [String]()
        let targetIDs = visionSelections.compactMap { $0.targetID }
        targetIDs.forEach { (targetID: Int) in
            let contentItems = services.contentService.contentItems(contentCollectionID: targetID)
            let userGender = (services.userService.user()?.gender ?? "NEUTRAL").uppercased()
            let genderQueryNeutral = "GENDER_NEUTRAL"
            let genderQuery = String(format: "GENDER_%@", userGender)
            let filteredItems = Array(contentItems.filter { $0.searchTags.contains(genderQuery) || $0.searchTags.contains(genderQueryNeutral) })
            if let randomItemText = filteredItems[filteredItems.randomIndex].valueText {
                visionList.append(randomItemText)
            }
        }
        let vision = visionList.joined(separator: " ")
        visionModel = MyToBeVisionModel.Model(headLine: nil, imageURL: nil, lastUpdated: Date(), text: vision)
        return vision
    }

    func setCurrentQuestionType(_ question: Question) {
        currentQuestionType = VisionGeneratorChoice.QuestionType(rawValue: question.key ?? "")
    }

    func choiceType(for question: Question?) -> VisionGeneratorChoice.QuestionType {
        if let question = question, let type = VisionGeneratorChoice.QuestionType(rawValue: question.key ?? "") {
            return type
        }
        return VisionGeneratorChoice.QuestionType.intro
    }
}
