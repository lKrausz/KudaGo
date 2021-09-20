//
//  CenterCellCollectionViewFlowLayout.swift
//  KudaGo
//
//  Created by Виктория Козырева on 14.09.2021.
//

import UIKit

class CenterCellCollectionViewFlowLayout: UICollectionViewFlowLayout {

    var mostRecentOffset: CGPoint = CGPoint()

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {

        if velocity.x == 0 {
            return mostRecentOffset
        }

        if let collectionView = self.collectionView {

            let halfWidth = collectionView.bounds.size.width * 0.5
            if let attributesForVisibleCells = self.layoutAttributesForElements(in: collectionView.bounds) {

                var candidateAttributes: UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {

                    if attributes.representedElementCategory != UICollectionView.ElementCategory.cell {
                        continue
                    }

                    if (attributes.center.x == 0) ||
                        (attributes.center.x > (collectionView.contentOffset.x + halfWidth) &&
                        velocity.x < 0) {
                        continue
                    }
                    candidateAttributes = attributes
                }

                if proposedContentOffset.x == -(collectionView.contentInset.left) {
                    return proposedContentOffset
                }

                guard candidateAttributes != nil else {
                    return mostRecentOffset
                }
                mostRecentOffset = CGPoint(x: floor(candidateAttributes!.center.x - halfWidth),
                                           y: proposedContentOffset.y)
                return mostRecentOffset
            }
        }

        mostRecentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset)
        return mostRecentOffset
    }

}
