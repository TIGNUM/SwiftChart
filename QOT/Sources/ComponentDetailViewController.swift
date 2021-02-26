//
//  ComponentDetailViewController.swift
//  QOT
//
//  Created by karmic on 25.03.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import UIKit

class ComponentDetailViewController: BaseViewController, ScreenZLevel3 {

    @IBOutlet weak var componentBottomToRootBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var componentContentView: ComponentContentView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var scrollView: UIScrollView!
    var draggingDownToDismiss = false
    var interactiveStartingPoint: CGPoint?
    var dismissalAnimator: UIViewPropertyAnimator?
    final class DismissalPanGesture: UIPanGestureRecognizer {}
    final class DismissalScreenEdgePanGesture: UIScreenEdgePanGestureRecognizer {}

    private lazy var dismissalPanGesture: DismissalPanGesture = {
        let pan = DismissalPanGesture()
        pan.maximumNumberOfTouches = 1
        return pan
    }()

    private lazy var dismissalScreenEdgePanGesture: DismissalScreenEdgePanGesture = {
        let pan = DismissalScreenEdgePanGesture()
        pan.edges = .left
        return pan
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - UIScrollViewDelegate

extension ComponentDetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if draggingDownToDismiss || scrollView.isTracking && scrollView.contentOffset.y < .zero {
            draggingDownToDismiss = true
            scrollView.contentOffset = .zero
        }
        scrollView.showsVerticalScrollIndicator = !draggingDownToDismiss
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y > .zero && scrollView.contentOffset.y <= .zero {
            scrollView.contentOffset = .zero
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension ComponentDetailViewController {
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                                    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

// MARK: - Private

private extension ComponentDetailViewController {
    func setupView() {
        scrollView.delegate = self
        scrollView.contentInsetAdjustmentBehavior = .never
        dismissalPanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalPanGesture.delegate = self
        dismissalScreenEdgePanGesture.addTarget(self, action: #selector(handleDismissalPan(gesture:)))
        dismissalScreenEdgePanGesture.delegate = self

        // Make drag down/scroll pan gesture waits til screen edge pan to fail first to begin
        dismissalPanGesture.require(toFail: dismissalScreenEdgePanGesture)
        scrollView.panGestureRecognizer.require(toFail: dismissalScreenEdgePanGesture)
        loadViewIfNeeded()
        view.addGestureRecognizer(dismissalPanGesture)
        view.addGestureRecognizer(dismissalScreenEdgePanGesture)
    }

    func didSuccessfullyDragDownToDismiss() {
//        cardViewModel = unhighlightedCardViewModel
        dismiss(animated: true)
    }

    func didCancelDismissalTransition() {
        // Clean up
        interactiveStartingPoint = nil
        dismissalAnimator = nil
        draggingDownToDismiss = false
    }

    // This handles both screen edge and dragdown pan. As screen edge pan is a subclass of pan gesture, this input param works.
    @objc func handleDismissalPan(gesture: UIPanGestureRecognizer) {
        let isScreenEdgePan = gesture.isKind(of: DismissalScreenEdgePanGesture.self)
        let canStartDragDownToDismissPan = !isScreenEdgePan && !draggingDownToDismiss

        // Don't do anything when it's not in the drag down mode
        guard canStartDragDownToDismissPan == false else { return }

        let targetAnimatedView = gesture.view!
        let startingPoint: CGPoint

        if let p = interactiveStartingPoint {
            startingPoint = p
        } else {
            // Initial location
            startingPoint = gesture.location(in: nil)
            interactiveStartingPoint = startingPoint
        }

        let currentLocation = gesture.location(in: nil)
        let progress = isScreenEdgePan ? (gesture.translation(in: targetAnimatedView).x / 100) : (currentLocation.y - startingPoint.y) / 100
        let targetShrinkScale: CGFloat = 0.86
        let targetCornerRadius: CGFloat = 16

        func createInteractiveDismissalAnimatorIfNeeded() -> UIViewPropertyAnimator {
            if let animator = dismissalAnimator {
                return animator
            } else {
                let animator = UIViewPropertyAnimator(duration:.zero, curve: .linear, animations: {
                    targetAnimatedView.transform = .init(scaleX: targetShrinkScale, y: targetShrinkScale)
                    targetAnimatedView.layer.cornerRadius = targetCornerRadius
                })
                animator.isReversed = false
                animator.pauseAnimation()
                animator.fractionComplete = progress
                return animator
            }
        }

        switch gesture.state {
        case .began:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
        case .changed:
            dismissalAnimator = createInteractiveDismissalAnimatorIfNeeded()
            let actualProgress = progress
            let isDismissalSuccess = actualProgress >= 1.0
            dismissalAnimator?.fractionComplete = actualProgress
            if isDismissalSuccess {
                dismissalAnimator?.stopAnimation(false)
                dismissalAnimator?.addCompletion { [unowned self] (pos) in
                    switch pos {
                    case .end:
                        self.didSuccessfullyDragDownToDismiss()
                    default:
                        fatalError("Must finish dismissal at end!")
                    }
                }
                dismissalAnimator?.finishAnimation(at: .end)
            }
        case .ended, .cancelled:
            if dismissalAnimator == nil {
                // Gesture's too quick that it doesn't have dismissalAnimator!
                print("Too quick there's no animator!")
                didCancelDismissalTransition()
                return
            }
            // NOTE:
            // If user lift fingers -> ended
            // If gesture.isEnabled -> cancelled

            // Ended, Animate back to start
            dismissalAnimator?.pauseAnimation()
            dismissalAnimator?.isReversed = true

            // Disable gesture until reverse closing animation finishes.
            gesture.isEnabled = false
            dismissalAnimator?.addCompletion { [unowned self] (_) in
                self.didCancelDismissalTransition()
                gesture.isEnabled = true
            }
            dismissalAnimator?.startAnimation()
        default:
            fatalError("Impossible gesture state? \(gesture.state.rawValue)")
        }
    }
}
