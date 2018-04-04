//
//  WhatsHotObserver.swift
//  QOT
//
//  Created by Sam Wyndham on 03/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation
import RealmSwift
import ReactiveKit

final class WhatsHotBadgeState {

    enum State {
        case hidden
        case visible
    }

    private let userDefaultsObserver = NotificationHandler(name: UserDefaults.didChangeNotification)
    private let articles: Results<ContentCollection>
    private let tokenBin = TokenBin()
    private let _state = Property(State.hidden)

    init(realm: Realm) {
        dispatchPrecondition(condition: .onQueue(.main))
        self.articles = realm.whatsHotArticlesSortedLastModifiedAscending()

        update()
        userDefaultsObserver.handler = { [unowned self] (_) in
            DispatchQueue.main.async {
                self.update()
            }
        }
        articles.addNotificationBlock { [unowned self] (_) in
            self.update()
        }.addTo(tokenBin)
    }

    var state: State {
        return _state.value
    }

    /// Saves the date the most recently updated whats hot article was modified in user defaults.
    func updateVisited() {
        UserDefault.whatsHotListLastViewed.setObject(articles.lastModified)
    }

    func onChange(_ closure: @escaping (State) -> Void) -> TokenProtocol {
        let disposable = _state.observeNext(with: closure)
        return BlockToken {
            disposable.dispose()
        }
    }

    private func update() {
        let newState = calculateState()
        if state != newState {
            _state.value = newState
        }
    }

    private func calculateState() -> WhatsHotBadgeState.State {
        guard let lastUpdated = articles.lastModified else { return .hidden }

        if let lastVisited = UserDefault.whatsHotListLastViewed.object as? Date {
            return lastUpdated > lastVisited ? .visible : .hidden
        } else {
            return .visible
        }
    }
}

private func calculateState(articles: Results<ContentCollection>) -> WhatsHotBadgeState.State {
    guard let lastUpdated = articles.lastModified else { return .hidden }

    if let lastVisited = UserDefault.whatsHotListLastViewed.object as? Date {
        return lastUpdated > lastVisited ? .visible : .hidden
    } else {
        return .visible
    }
}

private extension Realm {

    func whatsHotArticlesSortedLastModifiedAscending() -> Results<ContentCollection> {
        return objects(ContentCollection.self)
            .filter(.section(.learnWhatsHot))
            .sorted(byKeyPath: "modifiedAt", ascending: false)
    }
}

private extension Results where T: ContentCollection {

    var lastModified: Date? {
        return first?.modifiedAt
    }
}
