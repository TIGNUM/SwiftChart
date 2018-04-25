//
//  ChatItemQueue.swift
//  QOT
//
//  Created by Sam Wyndham on 25.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation

final class ChatItemQueue<T: ChatChoice> {

    private var popHandler: ((ChatItem<T>) -> Void)?
    private var timer: Timer?
    private var items: [ChatItem<T>] = []

    init(popHandler: @escaping (ChatItem<T>) -> Void) {
        self.popHandler = popHandler
    }

    deinit {
        invalidate()
    }

    func push(_ item: ChatItem<T>, shouldPop: Bool) {
        items.append(item)

        if items.count == 1 {
            scheduleFirstItem(shouldPop: shouldPop)
        }
    }

    func invalidate() {
        timer?.invalidate()
        popHandler = nil
        items = []
    }

    // MARK: Private

    private func scheduleFirstItem(shouldPop: Bool = false) {
        guard let item = items.first else {
            return
        }

        if shouldPop == true {
            popFirst()
        } else {
            let timeInterval = item.timestamp.timeIntervalSince(Date())
            if timeInterval < 0 {
                popFirst()
            } else {
                timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [unowned self] (_) in
                    self.popFirst()
                }
            }
        }
    }

    private func popFirst() {
        if let item = items.first {
            items.remove(at: 0)
            popHandler?(item)
        }
        scheduleFirstItem()
    }
}
