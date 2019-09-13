//
//  ChatViewLayout.swift
//  QOT
//
//  Created by Sam Wyndham on 20.09.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import UIKit

protocol ChatViewLayoutDelegate: class {

    func chatViewLayout(_ layout: ChatViewLayout, alignmentForSectionAt section: Int) -> ChatViewAlignment
    func chatViewLayout(_ layout: ChatViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func chatViewLayout(_ layout: ChatViewLayout, horizontalInteritemSpacingForSectionAt section: Int) -> CGFloat
    func chatViewLayout(_ layout: ChatViewLayout, verticalInteritemSpacingForSectionAt section: Int) -> CGFloat
    func chatViewLayout(_ layout: ChatViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    func chatViewLayout(_ layout: ChatViewLayout, sizeForHeaderAt section: Int) -> CGSize?
    func chatViewLayout(_ layout: ChatViewLayout, sizeForFooterAt section: Int) -> CGSize?
    func chatViewLayout(_ layout: ChatViewLayout, showAvatarInSection section: Int) -> Bool
    func chatViewLayout(_ layout: ChatViewLayout,
                         animatorForLayoutAttributes: UICollectionViewLayoutAttributes) -> ChatViewAnimator?
    func chatViewLayout(_ layout: ChatViewLayout, snapToTopOffsetInSection section: Int) -> CGFloat?
    func chatViewLayout(_ layout: ChatViewLayout, updateContentSize: CGSize)
}

enum ChatViewAlignment {
    case left
    case right
}

final class ChatViewLayout: UICollectionViewLayout {

    private var cache: [Section] = []
    private var contentSize: CGSize = .zero
    private var sectionInsertionTimes: [Int: Date] = [:]
    private var insertedSections: [Int] = []
    weak var delegate: ChatViewLayoutDelegate?

    override class var layoutAttributesClass: AnyClass {
        return ChatViewLayoutAttibutes.self
    }

    override func prepare() {
        guard let collectionView = collectionView, let delegate = delegate else {
            cache = []
            contentSize = .zero
            return
        }

        var sections: [Section] = []
        let originX: CGFloat = 0
        var originY: CGFloat = 0
        for sectionIndex in 0..<collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: sectionIndex)
            let horizontalSpacing = delegate.chatViewLayout(self, horizontalInteritemSpacingForSectionAt: sectionIndex)
            let verticalSpacing = delegate.chatViewLayout(self, verticalInteritemSpacingForSectionAt: sectionIndex)
            let inset = delegate.chatViewLayout(self, insetForSectionAt: sectionIndex)
            let alignment = delegate.chatViewLayout(self, alignmentForSectionAt: sectionIndex)
            let origin = CGPoint(x: originX, y: originY)
            let width = collectionView.bounds.width - collectionView.contentInset.horizontal
            let itemSizes = Array(0..<itemCount).map { (itemIndex) -> CGSize in
                let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                return delegate.chatViewLayout(self, sizeForItemAt: indexPath)
            }
            let headerSize = delegate.chatViewLayout(self, sizeForHeaderAt: sectionIndex)
            let footerSize = delegate.chatViewLayout(self, sizeForFooterAt: sectionIndex)
            let showAvatar = delegate.chatViewLayout(self, showAvatarInSection: sectionIndex)
            let snapOffset = delegate.chatViewLayout(self, snapToTopOffsetInSection: sectionIndex)

            let section = Section(section: sectionIndex,
                                  itemSizes: itemSizes,
                                  headerSize: headerSize,
                                  footerSize: footerSize,
                                  showAvatar: showAvatar,
                                  horizontalSpacing: horizontalSpacing,
                                  verticalSpacing: verticalSpacing,
                                  inset: inset,
                                  alignment: alignment,
                                  origin: origin,
                                  width: width,
                                  snapPosY: snapOffset.map({ $0 + origin.y }))
            originY = section.frame.maxY
            sections.append(section)
        }
        cache = sections

        let width = collectionView.bounds.width - collectionView.contentInset.horizontal
        let height: CGFloat = max(originY, finalSnapOffset().y + collectionView.bounds.height - collectionView.contentInset.top - collectionView.contentInset.bottom)

        contentSize = CGSize(width: width, height: height)
        delegate.chatViewLayout(self, updateContentSize: contentSize)
        for section in cache {
            if insertedSections.contains(section.sectionNumber) {
                section.prepareAnimations(using: self)
            }
        }
    }

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        for item in updateItems {
            switch item.updateAction {
            case .insert:
                if let indexPath = item.indexPathAfterUpdate, indexPath.item == NSNotFound { // Section Inserted
                    insertedSections.append(indexPath.section)
                }
            default:
                break
            }
        }
        invalidateLayout()
    }

    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()

        insertedSections.removeAll()
    }

    override func invalidateLayout() {
        super.invalidateLayout()

    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let kind = ChatViewSupplementaryViewKind(rawValue: elementKind) else {
            return nil
        }
        return cache[indexPath.section].layoutAttributesForSupplementaryView(ofKind: kind)
    }

    override func initialLayoutAttributesForAppearingItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    override func initialLayoutAttributesForAppearingSupplementaryElement(ofKind kind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return nil
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.section].layoutAttributesForItem(at: indexPath.item)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.flatMap { $0.layoutAttributesForElements(in: rect) }
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return collectionView?.bounds.size != newBounds.size
    }

    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    func finalSnapOffset() -> CGPoint {
        return CGPoint(x: 0, y: cache.filter { $0.snapPosY != nil }.last?.snapPosY ?? 0)
    }

    private func section(_ indexPath: IndexPath) -> Section {
        return cache[indexPath.section]
    }
}

private class Section {
    typealias SupplementaryViewKind = ChatViewSupplementaryViewKind

    private let attributes: [ChatViewLayoutAttibutes]
    private let supplementaryViewAttributes: [SupplementaryViewKind: ChatViewLayoutAttibutes]
    let sectionNumber: Int
    let frame: CGRect
    let snapPosY: CGFloat?

    init(section: Int,
         itemSizes: [CGSize],
         headerSize: CGSize?,
         footerSize: CGSize?,
         showAvatar: Bool,
         horizontalSpacing: CGFloat,
         verticalSpacing: CGFloat,
         inset: UIEdgeInsets,
         alignment: ChatViewAlignment,
         origin: CGPoint,
         width: CGFloat,
         snapPosY: CGFloat?) {

        let (cellFrames, supplementaryViewFrames, height) = Section.attributes(section: section,
                                                                               itemSizes: itemSizes,
                                                                               headerSize: headerSize,
                                                                               footerSize: footerSize,
                                                                               showAvatar: showAvatar,
                                                                               horizontalSpacing: horizontalSpacing,
                                                                               verticalSpacing: verticalSpacing,
                                                                               inset: inset,
                                                                               alignment: alignment,
                                                                               width: width)
        self.sectionNumber = section
        self.frame = CGRect(x: origin.x, y: origin.y, width: width, height: height)
        self.attributes = cellFrames.enumerated().map { (index, frame) -> ChatViewLayoutAttibutes in
            let indexPath = IndexPath(item: index, section: section)
            let attrs = ChatViewLayoutAttibutes(forCellWith: indexPath)
            attrs.frame = frame.offsetBy(dx: origin.x, dy: origin.y)
            return attrs
        }
        var supplementaryViewAttributes: [SupplementaryViewKind: ChatViewLayoutAttibutes] = [:]
        for (key, frame) in supplementaryViewFrames {
            let indexPath = IndexPath(item: 0, section: sectionNumber)
            let attrs = ChatViewLayoutAttibutes(forSupplementaryViewOfKind: key.rawValue, with: indexPath)
            attrs.frame = frame.offsetBy(dx: origin.x, dy: origin.y)
            attrs.zIndex =  key == .avatar ? 1 : 0
            supplementaryViewAttributes[key] = attrs
        }
        self.supplementaryViewAttributes = supplementaryViewAttributes
        self.snapPosY = snapPosY
    }

    static func attributes(section: Int,
                           itemSizes: [CGSize],
                           headerSize: CGSize?,
                           footerSize: CGSize?,
                           showAvatar: Bool,
                           horizontalSpacing: CGFloat,
                           verticalSpacing: CGFloat,
                           inset: UIEdgeInsets,
                           alignment: ChatViewAlignment,
                           width: CGFloat) -> (
        cellFrames: [CGRect],
        supplementaryViewFrames: [SupplementaryViewKind: CGRect],
        sectionHeight: CGFloat) {

            var lines: [[CGRect]] = [[]]
            var supplementaryViewFrames: [SupplementaryViewKind: CGRect] = [:]
            let minX = inset.left
            let maxX = width - inset.right
            var x = minX
            var y = inset.top

            func addFramesForSupplementaryView(ofKind kind: SupplementaryViewKind, size: CGSize?) {
                guard let size = size else { return }

                let xPos = alignment == .left ? minX : maxX - size.width
                let frame = CGRect(x: xPos, y: y, width: size.width, height: size.height)
                y += size.height
                supplementaryViewFrames[kind] = frame
            }

            // Header
            addFramesForSupplementaryView(ofKind: .header, size: headerSize)

            // Avatar
            if showAvatar {
                let size = CGSize(width: 28, height: 28)
                let origin = CGPoint(x: x - (size.width / 2), y: y - (size.height / 2))
                supplementaryViewFrames[.avatar] = CGRect(origin: origin, size: size)
            }

            // Main Attributes
            var lineHeight: CGFloat = 0
            for size in itemSizes {
                if x + size.width > maxX && x != minX {
                    // Start new line
                    x = minX
                    y += lineHeight + verticalSpacing
                    lineHeight = 0
                    lines.append([])
                }

                let frame = CGRect(x: x, y: y, width: size.width, height: size.height)
                x += size.width + horizontalSpacing
                lineHeight = max(lineHeight, size.height)
                lines[lines.count - 1].append(frame)
            }
            y += lineHeight

            // Footer
            addFramesForSupplementaryView(ofKind: .footer, size: footerSize)

            // Make attributes right aligned
            if alignment == .right {
                var rightAlignedLines: [[CGRect]] = []
                for line in lines {
                    var rightAlignedLine: [CGRect] = []
                    if let lastFrame = line.last {
                        let offest = maxX - lastFrame.maxX

                        for var frame in line {
                            frame.origin.x += offest
                            rightAlignedLine.append(frame)
                        }
                    }
                    rightAlignedLines.append(rightAlignedLine)
                }
                lines = rightAlignedLines
            }

            return (cellFrames: lines.flatMap { $0 },
                    supplementaryViewFrames: supplementaryViewFrames,
                    sectionHeight: y + inset.bottom)
    }

    func layoutAttributesForElements(in rect: CGRect) -> [ChatViewLayoutAttibutes] {
        guard frame.intersects(rect) else {
            return []
        }

        var allAttrs = Array(supplementaryViewAttributes.values)
        allAttrs.append(contentsOf: attributes)
        return allAttrs.filter { $0.frame.intersects(rect) }
    }

    func layoutAttributesForSupplementaryView(ofKind kind: ChatViewSupplementaryViewKind)
        -> ChatViewLayoutAttibutes? {
            return supplementaryViewAttributes[kind]
    }

    func layoutAttributesForItem(at index: Index) -> ChatViewLayoutAttibutes? {
        return attributes[index]
    }

    func prepareAnimations(using layout: ChatViewLayout) {
        guard let delegate = layout.delegate else {
            return
        }
        let now = Date()
        let allAttrs = [attributes, Array(supplementaryViewAttributes.values)].flatMap { $0 }
        allAttrs.forEach { (attrs) in
            attrs.insertedAt = now
            attrs.animator = delegate.chatViewLayout(layout, animatorForLayoutAttributes: attrs)
        }
    }
}

enum ChatViewSupplementaryViewKind: String {
    case header
    case footer
    case avatar
}
