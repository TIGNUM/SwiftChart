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

class ClickableLabel: UILabel {

    // MARK: - Types

    typealias MarkdownLink = (range: NSRange, link: String, title: String)

    // MARK: - Properties

    weak var delegate: ClickableLabelDelegate?

    public fileprivate(set) var links: [MarkdownLink] = []

    override var attributedText: NSAttributedString? {
        get {
            return super.attributedText
        }
        set {
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
}

// MARK: - Private

private extension ClickableLabel {

    func setup() {

        self.isUserInteractionEnabled = true

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(linkTapped(_:)))
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
            mutableAttributedText.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: link.range)
        }
    }

    func replaceLinks(in mutableAttributedText: NSMutableAttributedString) {

        matches(for: "\\[.*?\\]\\(.*?(?=\\))\\)", in: mutableAttributedText.string).reversed().forEach { range in

            let linkSubstring = mutableAttributedText.mutableString.substring(with: range)
            let linkTitle = getString(for: "\\[.*\\]", in: linkSubstring).trimmingCharacters(in: ["[", "]"])
            let link = getString(for: "\\(.*\\)", in: linkSubstring).trimmingCharacters(in: ["(", ")"])

            let additionalCharactersCount = linkSubstring.characters.count - linkTitle.characters.count

            let newRange =  NSRange(location: range.location, length: linkTitle.characters.count)

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

    func matches(for regex: String, in text: String) -> [NSRange] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
            return results.map { $0.range }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }

    func getString(for regex: String, in text: String) -> String {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let nsString = text as NSString
            let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))

            return results.count > 0 ? nsString.substring(with: results[0].range) : ""
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return ""
        }
    }
}
