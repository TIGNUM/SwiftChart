//
//  SkeletonManager.swift
//  QOT
//
//  Created by Simu Voicu-Mircea on 18/09/2019.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import SkeletonView

class SkeletonManager {
    /*
     In order to use this manager to apply skeleton loading feature to different views all you have to do is call the addTitle, addSubtitle or addOtherView methods.
     This will automatically setup the skeleton according to the type of view and start animating it

     When the data has been loaded, in order to stop the skeleton hide() must be called
     CAUTION - hide() method needs to be called BEFORE setting the text values for labels, textViews or doing any other setup for displaying views in order to display their content correctly
 */
    private var skeletonableTitles: [UIView] = []
    private var skeletonableSubtitles: [UIView] = []
    private var skeletonableOtherViews: [UIView] = []
    private static let animation = SkeletonAnimationBuilder().makeSlidingAnimation(withDirection: .leftRight)
    private static let titleGradient = SkeletonGradient(baseColor: .sand70, secondaryColor: .sand40)
    private static let subtitleGradient = SkeletonGradient(baseColor: .sand40, secondaryColor: .sand20)
    private static let otherViewGradient = SkeletonGradient(baseColor: .sand20, secondaryColor: .carbon40)

    func addTitle(_ view: UIView) {
        skeletonableTitles.append(view)
        view.showAnimatedGradientSkeleton(usingGradient: SkeletonManager.titleGradient, animation: SkeletonManager.animation, transition: .crossDissolve(0.25))
        view.isSkeletonable = true
    }

    func addSubtitle(_ view: UIView) {
        skeletonableSubtitles.append(view)
        view.showAnimatedGradientSkeleton(usingGradient: SkeletonManager.subtitleGradient, animation: SkeletonManager.animation, transition: .crossDissolve(0.25))
        view.isSkeletonable = true
    }

    func addOtherView(_ view: UIView) {
        skeletonableOtherViews.append(view)
        view.showAnimatedGradientSkeleton(usingGradient: SkeletonManager.otherViewGradient, animation: SkeletonManager.animation, transition: .crossDissolve(0.25))
        view.isSkeletonable = true
    }

    func hide() {
        for titleLabel in self.skeletonableTitles {
            titleLabel.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
        for view in self.skeletonableSubtitles {
            view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }

        for view in self.skeletonableOtherViews {
            view.hideSkeleton(reloadDataAfter: true, transition: .crossDissolve(0.25))
        }
        self.skeletonableTitles.removeAll()
        self.skeletonableSubtitles.removeAll()
        self.skeletonableOtherViews.removeAll()
    }

    deinit {
        hide()
    }
}
