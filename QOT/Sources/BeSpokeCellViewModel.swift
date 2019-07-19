//
//  BeSpokeCellViewModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 05.07.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct BeSpokeCellViewModel {
    private(set) var attributedTitle: NSAttributedString?
    private(set) var attributedHeading: NSAttributedString?
    private(set) var attributedDescription: NSAttributedString?
    private var heading: String {
        willSet {
            attributedHeading = formatted(heading: newValue)
        }
    }
    private var title: String {
        willSet {
            attributedTitle = formatted(title: newValue)
        }
    }
    private var description: String {
        willSet {
            attributedDescription = formatted(description: newValue)
        }
    }
    let images: [URL?]
}

private extension BeSpokeCellViewModel {
    func formatted(title: String) -> NSAttributedString? {
        return NSAttributedString(string: title.uppercased(),
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 18) ,
                                  lineSpacing: 3,
                                  textColor: .sand)
    }

    func formatted(description: String) -> NSAttributedString? {
        return NSAttributedString(string: description,
                                  letterSpacing: 0.2,
                                  font: .sfProtextRegular(ofSize: 16) ,
                                  lineSpacing: 3,
                                  textColor: .sand70,
                                  lineBreakMode: .byTruncatingTail)
    }

    func formatted(heading: String) -> NSAttributedString? {
        return NSAttributedString(string: heading.uppercased(),
                                  letterSpacing: 0.5,
                                  font: .sfProtextRegular(ofSize: 20) ,
                                  lineSpacing: 3,
                                  textColor: .sand,
                                  lineBreakMode: .byTruncatingTail)
    }
}
