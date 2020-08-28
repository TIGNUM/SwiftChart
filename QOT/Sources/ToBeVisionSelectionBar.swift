//
//  TeamVisionSelectionBar.swift
//  QOT
//
//  Created by Anais Plancoulaine on 13.08.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import UIKit

protocol ToBeVisionSelectionBarProtocol: class {
    func didTapEditItem()
    func didTapCameraItem()
    func didTapShareItem()
    func isShareBlocked(_ completion: @escaping (Bool) -> Void)
}

final class ToBeVisionSelectionBar: UIView {
    private weak var delegate: ToBeVisionSelectionBarProtocol?
    private let bottomMargin: CGFloat = -10
    private let rightMargin: CGFloat = -10
    private let leftMargin: CGFloat = 24
    private let titleMargin: CGFloat = -50
    private var spacing: CGFloat = -15
    private let buttonSize: CGFloat = 40
    private var arrayViews: [Weak<UIView>] = []
    private var arrayViewsCount = 0
    private var labelTitle = UILabel()
    private var buttonMore: AnimatedButton = AnimatedButton(type: .custom)
    private var buttonEdit: AnimatedButton = AnimatedButton(type: .custom)
    private var buttonCamera: AnimatedButton = AnimatedButton(type: .custom)
    private var buttonShare: AnimatedButton = AnimatedButton(type: .custom)
    private let gradientShadow = CAGradientLayer()
    private var isShowingAll: Bool = false

    var title: String? {
        didSet {
            ThemeText.articleNavigationTitle.apply(title, to: labelTitle)
            labelTitle.adjustsFontSizeToFitWidth = false
            labelTitle.lineBreakMode = .byTruncatingTail
        }
    }
}

// MARK: - Private

private extension ToBeVisionSelectionBar {
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
        addConstraint(NSLayoutConstraint(item: labelTitle, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: titleMargin))
        addConstraint(NSLayoutConstraint(item: labelTitle, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: leftMargin))
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

extension ToBeVisionSelectionBar {
    func configure(isOwner: Bool?, _ delegate: ToBeVisionSelectionBarProtocol) {
        self.delegate = delegate

        if arrayViewsCount > 0 { return }

        let expectedButtonCount: CGFloat = 4
        spacing = -(bounds.width - expectedButtonCount * buttonSize - rightMargin * 2) / expectedButtonCount

        setupContainers()

        setupButton(buttonMore, image: R.image.ic_more_unselected())
        buttonMore.addTarget(self, action: #selector(didTapMoreButton), for: .touchUpInside)
        buttonMore.corner(radius: buttonSize / 2)
        if isOwner == true {
            setupButton(buttonEdit, image: R.image.ic_edit())
            buttonEdit.addTarget(self, action: #selector(didTapEditItem), for: .touchUpInside)

            setupButton(buttonCamera, image: R.image.photo())
            buttonCamera.addTarget(self, action: #selector(didTapCameraItem), for: .touchUpInside)
        }
        setupButton(buttonShare, image: R.image.ic_share_sand())
        buttonShare.addTarget(self, action: #selector(didTapShareItem), for: .touchUpInside)
        delegate.isShareBlocked { [weak self] (hideShare) in
            guard let buttonShare = self?.buttonShare else { return }
            buttonShare.isHidden = hideShare
        }
        allOff()
    }

    func allOff() {
        isShowingAll = false
        refresh()
    }
}

// MARK: - Actions

private extension ToBeVisionSelectionBar {
    @IBAction func didTapMoreButton() {
        isShowingAll.toggle()
        refresh()
    }

    @IBAction func didTapEditItem() {
        delegate?.didTapEditItem()
    }

    @IBAction func didTapCameraItem() {
        delegate?.didTapCameraItem()
    }

    @IBAction func didTapShareItem() {
        delegate?.didTapShareItem()
    }
}
