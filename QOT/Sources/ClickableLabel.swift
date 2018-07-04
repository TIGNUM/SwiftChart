//
//  ClickableLabel.swift
//  QOT
//
//  Created by Moucheg Mouradian on 03/08/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol ClickableLabelDelegate: class {
    func openLink(withURL url: URL)
}

// Links with the following format: "Some random text with a link...[I'm a link](https://www.google.com)"
// will be changed to "Some random text with link...I'm a link" with the "I'm a link" part being clickable.

final class ClickableLabel: UILabel, UIGestureRecognizerDelegate {

    // MARK: - Types

    typealias MarkdownLink = (range: NSRange, link: String, title: String)

    // MARK: - Properties

    weak var delegate: ClickableLabelDelegate?
    public private(set) var links: [MarkdownLink] = []

    override var attributedText: NSAttributedString? {
        get {
            return super.attributedText
        } set {
            guard let text = newValue else {
                super.attributedText = newValue
                return
            }
            links.removeAll()
            let mutableAttributedText = NSMutableAttributedString(attributedString: text)
            replaceLinks(in: mutableAttributedText)
            changeLinkAspect(in: mutableAttributedText)
            super.attributedText = mutableAttributedText
        }
    }

    // MARK: - Lifecycle

    init() {
        super.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: UIGestureRecognizerDelegate

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return links.count > 0
    }
}

// MARK: - Private

private extension ClickableLabel {

    func setup() {
        self.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(linkTapped(_:)))
        gestureRecognizer.delegate = self
        addGestureRecognizer(gestureRecognizer)
    }

    @objc func linkTapped(_ gesture: UITapGestureRecognizer) {
        if let link = gesture.didTapAttributedTextInLabel(label: self),
            let url = URL(string: link) {
            self.delegate?.openLink(withURL: url)
        }
    }

    func changeLinkAspect(in mutableAttributedText: NSMutableAttributedString) {
        links.forEach { link in
            mutableAttributedText.addAttribute(NSAttributedStringKey.underlineStyle,
                                               value: NSUnderlineStyle.styleSingle.rawValue,
                                               range: link.range)
        }
    }

    func replaceLinks(in mutableAttributedText: NSMutableAttributedString) {
        String.matches(for: "\\[.*?\\]\\(.*?(?=\\))\\)", in: mutableAttributedText.string).reversed().forEach { range in
            let linkSubstring = mutableAttributedText.mutableString.substring(with: range)
            let linkTitle = String.getString(for: "\\[.*\\]", in: linkSubstring).trimmingCharacters(in: ["[", "]"])
            let link = String.getString(for: "\\(.*\\)", in: linkSubstring).trimmingCharacters(in: ["(", ")"])
            let additionalCharactersCount = linkSubstring.count - linkTitle.count
            let newRange =  NSRange(location: range.location, length: linkTitle.count)
            let mdLink = MarkdownLink(range: newRange, link: link, title: linkTitle)
            self.updateLinksLocations(with: additionalCharactersCount)
            self.links.append(mdLink)
            mutableAttributedText.mutableString.replaceCharacters(in: range, with: linkTitle)
        }
    }
    
    func updateLinksLocations(with additionalCharactersCount: Int) {
        for i in 0..<links.count {
            let link = links[i]
            let newRange = NSRange(location: link.range.location - additionalCharactersCount, length: link.range.length)
            links[i] = MarkdownLink(range: newRange, link: link.link, title: link.title)
        }
    }
}
