//
//  LearnStrategyListLayout.swift
//  QOT
//
//  Created by Sam Wyndham on 17.06.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

final class LearnStrategyListLayout: UICollectionViewLayout {

    let cellCount = 100
    var topOffset: CGFloat = 0

    var cache: [UICollectionViewLayoutAttributes] = []

    // FIXME: These are largly guestimates but can be more accurately calculated if general layout is approved
    // `angleOffset` is calculated using a trig calculator. It should ensure that the 0th and 7th items have aprox same 
    // y value. We should have a function do this but I'm to stupid right now!
    private static let angleOffset: CGFloat = 10.893
    private static let initialYPosFactor: CGFloat = 0.6
    private static let layoutRadiusFactor: CGFloat = 0.165
    private static let visibleRadiusFactor: CGFloat = 0.92
    private static let sectionPadding: CGFloat = 80
    private(set) public var sectionOrigins: [CGPoint] = []

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

        let viewHeight = collectionView.bounds.height - topOffset
        let layoutRadius = viewHeight * LearnStrategyListLayout.layoutRadiusFactor

        var decorationCounter = 0

        var sectionMaxXs: [CGFloat] = []
        var cache: [UICollectionViewLayoutAttributes] = []
        for section in 0..<collectionView.numberOfSections {
            let sectionMinX = sectionMaxXs.last ?? 0
            let initialX = sectionMinX + LearnStrategyListLayout.sectionPadding
            let itemCount = collectionView.numberOfItems(inSection: section)
            let attrs = makeAttributes(section: section, itemCount: itemCount, viewHeight: viewHeight, initialX: initialX, layoutRadius: layoutRadius)
            let sectionMaxX = (attrs.last?.frame.maxX ?? initialX) + LearnStrategyListLayout.sectionPadding

            sectionMaxXs.append(sectionMaxX)
            cache.append(contentsOf: attrs)

            if attrs.first != nil {
                sectionOrigins.append(attrs.first!.frame.origin)
            }

            makeDecorationAttributes(for: collectionView, withSectionMinX: sectionMinX, andSectinoMaxX: sectionMaxX, inSection: section, counter: &decorationCounter)
        }

        let viewWidth = sectionMaxXs.last ?? 0
        contentSize = CGSize(width: viewWidth, height: viewHeight)
        self.cache = cache
    }

    private func makeDecorationAttributes(for collectionView: UICollectionView, withSectionMinX sectionMinX: CGFloat, andSectinoMaxX sectionMaxX: CGFloat, inSection section: Int, counter: inout Int) {
        let screenWidth = collectionView.bounds.width
        let totalWidth = collectionView.contentSize.width
        var item = 0
        var xPosition: CGFloat = 0

        if let attribute = backgroundImageAttributes.last {
            xPosition = attribute.frame.origin.x + attribute.frame.width
        }

        while xPosition < sectionMaxX {
            let decorationAttrs = LearnContentListBackgroundViewLayoutAttributes(forDecorationViewOfKind: LearnContentListBackgroundView.kind, with: IndexPath(item: item, section: section))
            decorationAttrs.frame = CGRect(origin: CGPoint(x: xPosition, y: 0), size: collectionView.bounds.size)
            decorationAttrs.zIndex = -1
            decorationAttrs.image = (counter % 2) == 0 ? R.image.learnBack1() : R.image.learnBack2()
            backgroundImageAttributes.append(decorationAttrs)

            print("xPos: \(xPosition) | screenWidth: \(screenWidth) | totalWidth: \(totalWidth) | sectionMaxX: \(sectionMaxX)")

            item += 1
            counter += 1
            xPosition += screenWidth
        }

    }

    private func makeAttributes(section: Int, itemCount: Int, viewHeight: CGFloat, initialX: CGFloat, layoutRadius: CGFloat) -> [UICollectionViewLayoutAttributes] {
        var attrs: [UICollectionViewLayoutAttributes] = []

        var current: CGPoint? = nil
        for index in 0..<itemCount {
            var center: CGPoint
            if let current = current {
                center = nextCenter(current: current, radius: layoutRadius, viewHeight: viewHeight)
            } else {
                // First item
                center = CGPoint(x: initialX + layoutRadius, y: viewHeight * LearnStrategyListLayout.initialYPosFactor + topOffset)
            }

            if index % 7 == 0 { // Ensure pattern doesn't drift down/up.
                center = center.rounded
            }

            current = center

            let indexPath = IndexPath(item: index, section: section)
            attrs.append(attributesForItem(center: center, layoutRadius: layoutRadius, indexPath: indexPath))
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

    private func attributesForItem(center: CGPoint, layoutRadius: CGFloat, indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let radius = LearnStrategyListLayout.visibleRadiusFactor * layoutRadius
        let maxRandom = (layoutRadius - radius) / 2
        let x = center.x + CGFloat.random(min: -maxRandom, max: maxRandom)
        let y = center.y + CGFloat.random(min: -maxRandom, max: maxRandom) + topOffset / 2

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

private extension CGFloat {

    static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max) * (max - min) + min
    }
}
