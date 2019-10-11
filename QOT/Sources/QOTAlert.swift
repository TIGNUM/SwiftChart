//
//  QOTAlert.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 27/08/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

// MARK: -
/// Object which represents parameters needed to display bottom buttons in `QOTAlert`. Provide either `target` and
/// `action` or just a handler. `target`/`action` pair have priority over `handler` closure (only one can be used).
struct QOTAlertAction {
    let title: String?
    let target: Any?
    let action: Selector?
    let handler: ((UIButton) -> Void)?

    init(title: String?, target: Any? = nil, action: Selector? = nil, handler: ((UIButton) -> Void)? = nil) {
        self.title = title
        self.target = target
        self.action = action
        self.handler = handler
    }
}

// MARK: - Public methods
class QOTAlert {

    static private let shared = QOTAlert()

    private var windows = [UIWindow?]()

    static func show(title: String?,
                     message: String?,
                     bottomItems: [QOTAlertAction]? = nil,
                     buttonAlignment: QOTAlertViewController.ButtonsAlignment = .right,
                     cancelHandler: (() -> Void)? = nil) {

        shared.show(title: title,
                    message: message,
                    bottomAlertItems: bottomItems,
                    buttonAlignment: buttonAlignment,
                    cancelHandler: cancelHandler)
    }

    static func show(title: String?,
                     message: String?,
                     bottomItems: [UIBarButtonItem]?,
                     buttonAlignment: QOTAlertViewController.ButtonsAlignment = .right,
                     cancelHandler: (() -> Void)? = nil) {

        shared.show(title: title,
                    message: message,
                    bottomBarItems: bottomItems,
                    buttonAlignment: buttonAlignment,
                    cancelHandler: cancelHandler)
    }

    static func dismiss() {
        shared.dismiss()
    }
}

// MARK: - Private methods
private extension QOTAlert {

    func show(title: String?,
              message: String?,
              bottomAlertItems: [QOTAlertAction]? = nil,
              bottomBarItems: [UIBarButtonItem]? = nil,
              buttonAlignment: QOTAlertViewController.ButtonsAlignment,
              cancelHandler: (() -> Void)? = nil) {
        let controller = R.storyboard.qotAlert.qotAlertViewController() ?? QOTAlertViewController()
        controller.delegate = self
        show(controller: controller)
        controller.bottomButtonsAlignment = buttonAlignment
        controller.cancelHander = cancelHandler
        if let bottomItems = bottomAlertItems {
            controller.set(title: title, message: message, bottomItems: bottomItems)
        } else {
            controller.set(title: title, message: message, bottomItems: bottomBarItems)
        }
    }

    func show(controller: QOTAlertViewController) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = controller
        window.windowLevel = UIWindowLevelAlert + 1
        window.makeKeyAndVisible()
        windows.append(window)

        controller.show()
    }
}

// MARK: - Dismiss - QOTAlertViewControllerDelegate
extension QOTAlert: QOTAlertViewControllerDelegate {

    func dismiss() {
        var currentWindow = windows.isEmpty == false ? windows.removeLast() : nil
        guard let controller = currentWindow?.rootViewController as? QOTAlertViewController else { return }
        controller.dismiss(completion: { (_) in
            currentWindow?.resignKey()
            currentWindow?.resignFirstResponder()
            currentWindow = nil
        })
    }
}

// MARK: -
// MARK: - QOTAlertViewController

protocol QOTAlertViewControllerDelegate: class {
    func dismiss()
}

class QOTAlertViewController: BaseViewController {

    enum ButtonsAlignment {
        case right
        case center
        case left
    }

    // MARK: - Constants
    private let toolbarDefaultHeight: CGFloat = 44
    private let appearDuration: Double = Animation.duration_02
    private let dismissDuration: Double = Animation.duration_03
    private lazy var hiddenContentPosition: CGFloat = { return -contentView.frame.size.height * 2 }()
    private lazy var displayedContentPosition: CGFloat = { return 24 }()

    // MARK: - IBOutlets
    @IBOutlet private weak var backgroundView: UIView! // Dark background view
    @IBOutlet private weak var contentView: UIView! // View containing labels
    @IBOutlet private weak var bottomView: UIView! // Extra view for background color when user drags up
    @IBOutlet private weak var dragIndicator: UIView! // Drag dash for touch point calculations
    @IBOutlet private weak var dragView: UIView! // View containing pan gesture recognizer
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var toolbar: UIToolbar!

    @IBOutlet private weak var bottomContentConstraint: NSLayoutConstraint! // To animate slide in/out
    @IBOutlet private weak var toolbarHeight: NSLayoutConstraint! // To hide toolbar when there are no buttons

    // MARK: - Variables
    private var initialPanLocation: CGFloat = 0
    private var lastPanLocation: CGFloat = 0

    var cancelHander: (() -> Void)?
    weak var delegate: QOTAlertViewControllerDelegate?
    var bottomButtonsAlignment: ButtonsAlignment = .right {
        didSet {
            let items = bottomItems
            bottomItems = items
        }
    }

    private var bottomItems: [UIBarButtonItem]? {
        didSet {
            toolbar.items = handleBottomItems(bottomItems)
            toolbarHeight.constant = bottomItems != nil ? toolbarDefaultHeight : 0
        }
    }

    private lazy var flexibleSpace: UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }()

    private lazy var fixedSpace: UIBarButtonItem = {
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 24
        return fixedSpace
    }()

    // MARK: - Initialization

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // UI
        ThemeView.qotAlert.apply(backgroundView)
        ThemeView.qotAlert.apply(bottomView)
        dragIndicator.layer.cornerRadius = dragIndicator.frame.size.height * 0.5
        toolbar.isTranslucent = true
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.any, barMetrics: UIBarMetrics.default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.any)

        // Preparations for appear effects
        initialPanLocation = view.convert(dragView.frame.center, to: backgroundView).y - dragView.center.y
        backgroundView.alpha = 0
        bottomContentConstraint.constant = hiddenContentPosition
        view.layoutIfNeeded()

        // Gestures
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissOnBackgroundTap)))
        dragView.gestureRecognizers = [UIPanGestureRecognizer(target: self, action: #selector(detectedPan(_:)))]
    }
}

// MARK: - Public methods
extension QOTAlertViewController {
    func set(title: String?, message: String?, bottomItems: [QOTAlertAction]?) {

        var items: [UIBarButtonItem]? = nil
        if let bottomItems = bottomItems {
            items = bottomItems.map { barButton(from: $0) }
        }
        set(title: title, message: message, bottomItems: items)
    }

    func set(title: String?, message: String?, bottomItems: [UIBarButtonItem]?) {
        // Title
        if let title = title {
            ThemeText.qotAlertTitle.apply(title, to: titleLabel)
        } else {
            titleLabel.attributedText = nil
        }
        // Message
        if let message = message {
            ThemeText.qotAlertMessage.apply(message, to: messageLabel)
        } else {
            messageLabel.attributedText = nil
        }
        // Bottom buttons
        self.bottomItems = bottomItems
    }

    func show() {
        bottomContentConstraint.constant = displayedContentPosition
        UIView.animate(withDuration: appearDuration) { [weak self] in
            self?.backgroundView.alpha = 1
            self?.view.layoutIfNeeded()
        }
    }

    func dismiss(completion: ((Bool) -> Void)?) {
        bottomContentConstraint.constant = hiddenContentPosition
        UIView.animate(withDuration: dismissDuration, animations: { [weak self] in
            self?.backgroundView.alpha = 0
            self?.toolbar.alpha = 0
            self?.view.layoutIfNeeded()
        }, completion: completion)
    }
}

// MARK: - Private methods
private extension QOTAlertViewController {
    @objc func didTapItem(_ sender: Any) {
        guard let button = sender as? RoundedButton else { return }
        button.handler?(button)
    }

    @objc func dismissOnBackgroundTap() {
        cancelHander?()
        didTapDismiss()
    }

    @objc func didTapDismiss() {
        delegate?.dismiss()
    }

    func handleBottomItems(_ items: [UIBarButtonItem]?) -> [UIBarButtonItem]? {
        guard let items = items else { return nil }
        var tempItems = [UIBarButtonItem]()

        for (index, item) in items.enumerated() {
            // Large space before first item
            if index == 0 {
                if bottomButtonsAlignment != .left {
                    tempItems.append(flexibleSpace)
                }
            } else if bottomButtonsAlignment == .center {
                // Flexible space between other items
                tempItems.append(flexibleSpace)
            } else {
                // Fixed space between items
                tempItems.append(fixedSpace)
            }
            // Item
            if let button = findButton(in: item.customView) {
                button.addTarget(self, action: #selector(didTapDismiss), for: .touchUpInside)
            }
            tempItems.append(item)
        }
        // Large space after last item
        if bottomButtonsAlignment != .right {
            tempItems.append(flexibleSpace)
        }
        return tempItems
    }

    func barButton(from item: QOTAlertAction) -> UIBarButtonItem {
        let pair: (Any, Selector)
        if let target = item.target, let action = item.action {
            pair = (target, action)
        } else {
            pair = (self, #selector(didTapItem(_:)))
        }
        let button = RoundedButton(title: item.title ?? "  ", target: pair.0, action: pair.1)
        button.handler = item.handler
        return button.barButton
    }

    func findButton(in view: UIView?) -> UIButton? {
        guard let view = view else { return nil }
        if let button = view as? UIButton {
            return button
        }
        for tempView in view.subviews {
            if let button = findButton(in: tempView) {
                return button
            }
        }
        return nil
    }
}

// MARK: - Dragging
private extension QOTAlertViewController {

    @objc func detectedPan(_ recognizer: UIPanGestureRecognizer) {
        var offset  = recognizer.translation(in: backgroundView).y - initialPanLocation
        if offset < 0 {
            offset = offset * 0.5
        }

        // Handle gesture end
        if recognizer.state == .ended {
            handlePanEnd(offset: offset)
            return
        }

        // Handle drag down
        backgroundView.alpha = 1.0 - 0.6 * (offset / contentView.frame.size.height) // Min. alpha during swiping is 60 %
        toolbar.alpha = backgroundView.alpha
        contentView.transform = CGAffineTransform.init(translationX: 0, y: offset)
        bottomView.transform = CGAffineTransform.init(translationX: 0, y: offset)
        if offset > 0 {
            toolbar.transform = CGAffineTransform.init(translationX: 0, y: offset)
        } else {
            toolbar.transform = .identity
        }
    }

    private func handlePanEnd(offset: CGFloat) {
        if offset > 0, fabs(offset) > 0.25 * contentView.frame.size.height {
            cancelHander?()
            didTapDismiss()
            return
        }

        UIView.animate(withDuration: dismissDuration) { [weak self] in
            self?.contentView.transform = .identity
            self?.bottomView.transform = .identity
            self?.toolbar.transform = .identity
            self?.backgroundView.alpha = 1
        }
    }
}
