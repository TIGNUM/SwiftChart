//
//  ChatTableViewCell.swift
//  QOT
//
//  Created by karmic on 23/03/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class ChatTableViewCell: UITableViewCell {

    fileprivate var message: String?
    fileprivate var delivered: Date?
    fileprivate var title: String?
    fileprivate var option: ChatMessageType.Option?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        print("style: \(style), reuseIdentifier: \(reuseIdentifier)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(message: String, delivered: Date) {
        textLabel?.text = message
    }

    func setup(title: String, option: ChatMessageType.Option) {
        self.title = title
        self.option = option
    }

    func setup(chatMessageType: ChatMessageType) {

    }
}
