//
//  LearnStrategyListLayout.swift
//  QOT
//
//  Created by Sam Wyndham on 17.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit
import GameKit

final class LearnStrategyListLayout: UICollectionViewLayout {

    private var cache: [UICollectionViewLayoutAttributes] = []
    private var sectionMinXs: [CGFloat] = []

    // FIXME: These are largly guestimates but can be more accurately calculated if general layout is approved
    // `angleOffset` is calculated using a trig calculator. It should ensure that the 0th and 7th items have aprox same 
    // y value. We should have a function do this but I'm to stupid right now!
    private static let angleOffset: CGFloat = 10.893
    private static let initialYPosFactor: CGFloat = 0.6
    private static let layoutRadiusFactor: CGFloat = 0.165
    private static let visibleRadiusFactor: CGFloat = 0.92
    private static let sectionPadding: CGFloat = 80

    private var contentSize = CGSize.zero

    private var backgroundImageAttributes: [LearnContentListBackgroundViewLayoutAttributes] = []

    override init() {
        super.init()

        register(LearnContentListBackgroundView.self, forDecorationViewOfKind: LearnContentListBackgroundView.kind)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepare() {
        guard let collectionView = collectionView else {
            contentSize = CGSize.zero
            self.cache = []
            self.backgroundImageAttributes = []
            return
        }

        let contentInset = collectionView.contentInset
        let contentHeight = collectionView.bounds.height - contentInset.top - contentInset.bottom
        let layoutRadius = contentHeight * LearnStrategyListLayout.layoutRadiusFactor
        var sectionMaxXs: [CGFloat] = []
        var cache: [UICollectionViewLayoutAttributes] = []
        var sectionMinXs: [CGFloat] = []
        for section in 0..<collectionView.numberOfSections {
            let sectionMinX = sectionMaxXs.last ?? 0
            let initialX = sectionMinX + LearnStrategyListLayout.sectionPadding
            let itemCount = collectionView.numberOfItems(inSection: section)
            let attrs = makeAttributes(section: section, itemCount: itemCount, viewHeight: contentHeight, initialX: initialX, layoutRadius: layoutRadius)
            let sectionMaxX = (attrs.last?.frame.maxX ?? initialX) + LearnStrategyListLayout.sectionPadding
            sectionMaxXs.append(sectionMaxX)
            cache.append(contentsOf: attrs)
            sectionMinXs.append(initialX)
        }

        let viewWidth = sectionMaxXs.last ?? 0
        contentSize = CGSize(width: viewWidth, height: contentHeight)
        self.cache = cache
        self.sectionMinXs = sectionMinXs
    }

    func minX(section: Index) -> CGFloat? {
        return section < sectionMinXs.count ? sectionMinXs[section] : nil
    }

    private func makeAttributes(section: Int, itemCount: Int, viewHeight: CGFloat, initialX: CGFloat, layoutRadius: CGFloat) -> [UICollectionViewLayoutAttributes] {
        let randomSource = GKLinearCongruentialRandomSource(seed: 0)
        let randomDistribution = GKRandomDistribution(randomSource: randomSource, lowestValue: 0, highestValue: 5)

        var attrs: [UICollectionViewLayoutAttributes] = []
        var current: CGPoint? = nil
        for index in 0..<itemCount {
            var center: CGPoint
            if let current = current {
                center = nextCenter(current: current, radius: layoutRadius, viewHeight: viewHeight)
            } else {
                // First item
                center = CGPoint(x: initialX + layoutRadius, y: viewHeight * LearnStrategyListLayout.initialYPosFactor)
            }

            if index % 7 == 0 { // Ensure pattern doesn't drift down/up.
                center = center.rounded
            }

            current = center

            let indexPath = IndexPath(item: index, section: section)
            attrs.append(attributesForItem(center: center, layoutRadius: layoutRadius, indexPath: indexPath, distribution: randomDistribution))
        }
        return attrs
    }

    private func nextCenter(current: CGPoint, radius: CGFloat, viewHeight: CGFloat) -> CGPoint {
        let upAngle: CGFloat = -90 - LearnStrategyListLayout.angleOffset
        let downAngle: CGFloat = 90 - LearnStrategyListLayout.angleOffset
        let upRightAngle: CGFloat = -30 - LearnStrategyListLayout.angleOffset
        let distance = 2 * radius

        var candidate = current.shifted(distance, with: downAngle)
        if candidate.y + radius <= viewHeight {
            return candidate
        }

        candidate = current.shifted(distance, with: upAngle).shifted(distance, with: upRightAngle)
        if candidate.y - radius >= 0 {
            return candidate
        }

        return current.shifted(distance, with: upRightAngle)
    }

    private func attributesForItem(center: CGPoint, layoutRadius: CGFloat, indexPath: IndexPath, distribution: GKRandomDistribution) -> UICollectionViewLayoutAttributes {
        let radius = LearnStrategyListLayout.visibleRadiusFactor * layoutRadius
        let maxRandom = (layoutRadius - radius) / 2
        let x = center.x + distribution.nextFloat(min: -maxRandom, max: maxRandom)
        let y = center.y + distribution.nextFloat(min: -maxRandom, max: maxRandom)

        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = CGRect(x: x - radius, y: y - radius, width: 2 * radius, height: 2 * radius)
        return attributes
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) } + backgroundImageAttributes.filter { $0.frame.intersects(rect) }
    }
}

private extension GKRandomDistribution {

    func nextFloat(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(nextUniform()) * (max - min) + min
    }
}
