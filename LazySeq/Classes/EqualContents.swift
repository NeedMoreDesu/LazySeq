//
//  EqualContents.swift
//  LazySeq
//
//  Created by Oleksii Horishnii on 11/7/17.
//

import Foundation

public func equalContents2d<Coll1, Coll2>(lhs: Coll1, rhs: Coll2) -> Bool where Coll1: Collection, Coll2: Collection, Coll1.Element: Collection, Coll2.Element: Collection,  Coll2.Element.Element: Equatable, Coll1.Element.Element == Coll2.Element.Element {
    var rightIndex = rhs.startIndex
    var leftIndex = lhs.startIndex
    while true {
        if leftIndex == lhs.endIndex && rightIndex == rhs.endIndex {
            return true
        }
        if leftIndex == lhs.endIndex {
            return false
        }
        if rightIndex == rhs.endIndex {
            return false
        }
        let leftItem = lhs[leftIndex]
        leftIndex = lhs.index(after: leftIndex)
        let rightItem = rhs[rightIndex]
        rightIndex = rhs.index(after: rightIndex)
        if (!equalContents1d(lhs: leftItem, rhs: rightItem)) {
            return false
        }
    }
}

public func equalContents1d<Coll1, Coll2>(lhs: Coll1, rhs: Coll2) -> Bool where Coll1: Collection, Coll2: Collection, Coll2.Element: Equatable, Coll1.Element == Coll2.Element {
    var rightIndex = rhs.startIndex
    var leftIndex = lhs.startIndex
    while true {
        if leftIndex == lhs.endIndex && rightIndex == rhs.endIndex {
            return true
        }
        if leftIndex == lhs.endIndex {
            return false
        }
        if rightIndex == rhs.endIndex {
            return false
        }
        let leftItem = lhs[leftIndex]
        leftIndex = lhs.index(after: leftIndex)
        let rightItem = rhs[rightIndex]
        rightIndex = rhs.index(after: rightIndex)
        if (leftItem != rightItem) {
            return false
        }
    }
}
