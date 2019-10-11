//
//  ArticleTopNavBar.swift
//  QOT
//
//  Created by Dominic Frazer Imregh on 24/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

protocol ArticleTopNavBarProtocol: class {
    func didTapBookmarkItem()
    func didTapDarkModeItem()
    func didTapTextScaleItem()
    func didTapShareItem()
}

final class ArticleTopNavBar: UIView {
    private weak var delegate: ArticleTopNavBarProtocol?

    private let bottomMargin: CGFloat = -10
    private let rightMargin: CGFloat = -10
    private var spacing: CGFloat = -30
    private let buttonSize: CGFloat = 40

    private var arrayViews: [Weak<UIView>] = []
    private var arrayViewsCount = 0

    private var labelTitle = UILabel()
    private var buttonMore: AnimatedButton = AnimatedButton(type: .custom)
    private var buttonBookmark: AnimatedButton = AnimatedButton(type: .custom)
    private var buttonNightMode: AnimatedButton = AnimatedButton(type: .custom)
    private var buttonTextScale: AnimatedButton = AnimatedButton(type: .custom)
    private var buttonShare: AnimatedButton = AnimatedButton(type: .custom)
    private let gradientShadow = CAGradientLayer()
    private var isShowingAll: Bool = false

    var title: String? {
        didSet {
            ThemeText.articleNavigationTitle.apply(title, to: labelTitle)
        }
    }
}

// MARK: - Private

private extension ArticleTopNavBar {
    func setupContainers() {
        weak var lastContainer: UIView?
        for _ in 0..<5 {
            let container = UIView(frame: .zero)

            arrayViews.append(Weak(value: container))
            container.translatesAutoresizingMaskIntoConstraints = false
            addSubview(container)

            container.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomMargin).isActive = true
            addConstraint(NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: buttonSize))
            addConstraint(NSLayoutConstraint(item: container, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: buttonSize))
            if let last = lastContainer {
                addConstraint(NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: last, attribute: .leading, multiplier: 1.0, constant: spacing))
            } else {
                addConstraint(NSLayoutConstraint(item: container, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: rightMargin))
            }
            lastContainer = container
        }
        setNeedsLayout()

        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(labelTitle)
        labelTitle.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        labelTitle.centerYAnchor.constraint(equalTo: lastContainer!.centerYAnchor).isActive = true
    }

    func setupButton(_ item: AnimatedButton, image: UIImage?) {
        item.setImage(image, for: .normal)
        item.tintColor = colorMode.tint
        item.heightAnchor.constraint(equalToConstant: 44).isActive = true
        item.widthAnchor.constraint(equalToConstant: 44).isActive = true
        item.translatesAutoresizingMaskIntoConstraints = false

        if let view = arrayViews[arrayViewsCount].value {
            view.addSubview(item)
            item.addConstraints(to: view)
        }
        arrayViewsCount += 1
    }

    func refresh() {
        guard arrayViewsCount > 1 else { return }
        let alpha: CGFloat = isShowingAll ? 1.0 : 0.0
        for i in 1..<arrayViewsCount {
            if let view = arrayViews[i].value {
                UIView.animate(withDuration: 0.25, delay: Double((i - 1)) * 0.05, options: .curveEaseOut, animations: {
                    view.alpha = alpha
                }, completion: nil)
            }
        }
        UIView.animate(withDuration: 0.25) {
            self.labelTitle.alpha = 1 - alpha
        }

        buttonMore.backgroundColor = isShowingAll ? .accent40 : .clear
    }
}

// MARK: - Public

extension ArticleTopNavBar {
    func configure(_ delegate: ArticleTopNavBarProtocol, isShareable: Bool, isBookMarkable: Bool) {
        self.delegate = delegate

        if arrayViewsCount > 0 { return }

        let expectedButtonCount: CGFloat = 3 + (isShareable ? 1 : 0) + (isBookMarkable ? 1 : 0)
        spacing = -(bounds.width - expectedButtonCount * buttonSize - rightMargin * 2) / expectedButtonCount

        setupContainers()

        setupButton(buttonMore, image: R.image.ic_more_unselected())
        buttonMore.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        buttonMore.corner(radius: buttonSize / 2)

        if isBookMarkable {
            setupButton(buttonBookmark, image: nil)
            buttonBookmark.addTarget(self, action: #selector(didTapBookmarkItem), for: .touchUpInside)
        }

        setupButton(buttonNightMode, image: R.image.ic_night_mode_unselected())
        buttonNightMode.addTarget(self, action: #selector(didTapDarkModeItem), for: .touchUpInside)

        setupButton(buttonTextScale, image: R.image.ic_text_scale())
        buttonTextScale.addTarget(self, action: #selector(didTapTextScaleItem), for: .touchUpInside)

        if isShareable {
            setupButton(buttonShare, image: R.image.ic_share_sand())
            buttonShare.addTarget(self, action: #selector(didTapShareItem), for: .touchUpInside)
        }

        allOff()
    }

    func updateBookmark(_ hasBookmark: Bool) {
        let image = hasBookmark ? R.image.ic_bookmark_fill() : R.image.ic_bookmark()
        buttonBookmark.setImage(image, for: .normal)
    }

    func refreshColor() {
        backgroundColor = .clear
        let tint = colorMode.tint
        buttonMore.tintColor = tint
        buttonBookmark.tintColor = tint
        buttonNightMode.tintColor = tint
        buttonTextScale.tintColor = tint
        buttonShare.tintColor = tint

        gradientShadow.removeFromSuperlayer()
        gradientShadow.frame = bounds
        gradientShadow.locations = [0, 0.8, 1.0]
        gradientShadow.colors = colorMode == .dark ? [UIColor.carbon.cgColor, UIColor.carbon.cgColor, UIColor.carbon05.cgColor] :
            [UIColor.sand.cgColor, UIColor.sand.cgColor, UIColor.sand08.cgColor]
        layer.insertSublayer(gradientShadow, at: 0)
    }

    func allOff() {
        isShowingAll = false
        refreshColor()
        refresh()
    }
}

// MARK: - Actions

private extension ArticleTopNavBar {
    @IBAction func didTapMoreButton() {
        isShowingAll.toggle()
        refresh()
    }

    @IBAction func didTapBookmarkItem() {
        delegate?.didTapBookmarkItem()
    }

    @IBAction func didTapDarkModeItem() {
        delegate?.didTapDarkModeItem()
    }

    @IBAction func didTapTextScaleItem() {
        delegate?.didTapTextScaleItem()
    }

    @IBAction func didTapShareItem() {
        delegate?.didTapShareItem()
    }
}

class Weak<T: AnyObject> {
    weak var value: T?
    init (value: T) {
        self.value = value
    }
}
