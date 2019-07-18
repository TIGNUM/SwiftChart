//
//  LeaderWisdomCellViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 02.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct LeaderWisdomCellViewModel {
    private(set) var attributedTitle: NSAttributedString?
    private(set) var attributedSubTitle: NSAttributedString?
    private(set) var attributedDescription: NSAttributedString?
    let audio: Audio?
    let video: Video?
    private var title: String {
        willSet {
            attributedTitle = formatted(title: newValue)
        }
    }
    private var subTitle: String {
        willSet {
            attributedSubTitle = formatted(subtitle: newValue)
        }
    }
    private var description: String {
        willSet {
            attributedDescription = formatted(description: newValue)
        }
    }

    struct Audio {
        let duration: String
        let link: URL?
    }
    struct Video {
        let title: String
        let duration: String
        let thumbnail: URL?
    }

    var finalDescription: String {
        return "\t\t" + description
    }
}

private extension LeaderWisdomCellViewModel {
    func formatted(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title.uppercased(),
                                  letterSpacing: 0.2,
                                  font: .sfProtextLight(ofSize: 20),
                                  lineSpacing: 5,
                                  textColor: .sand)
    }

    func formatted(subtitle: String) -> NSAttributedString? {
        return NSAttributedString(string: subtitle,
                                  letterSpacing: 0.2,
                                  font: .sfProtextRegular(ofSize: 16),
                                  lineSpacing: 5,
                                  textColor: .sand60,
                                  lineBreakMode: .byTruncatingTail)
    }

    func formatted(description: String) -> NSAttributedString? {
        return NSAttributedString(string: description,
                                  letterSpacing: 0.2,
                                  font: .sfProtextRegular(ofSize: 16),
                                  lineSpacing: 5,
                                  textColor: .sand,
                                  lineBreakMode: .byTruncatingTail)
    }
}
