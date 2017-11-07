//
//  LazySeq.swift
//  PerfectExample
//
//  Created by Oleksii Horishnii on 1/23/17.
//  Copyright © 2017 Oleksii Horishnii. All rights reserved.
//

import Foundation
import DividableRange

open class LazySeq<Type>: GeneratedSeq<Type> {
    public var storage: [Int: Type] = [:]
    public var shouldStoreCount: Bool = false
    private var storedCount: Int?
    
    override public func get(_ idx: Int, context: Any? = nil) -> Type? {
        if let obj = storage[idx] {
            return obj
        }
        let obj = super.get(idx, context: context)
        storage[idx] = obj
        return obj
    }
    
    public func resetStorage(_ idx: Int? = nil) {
        if let idx = idx {
            self.storage[idx] = nil
        } else {
            self.storage = [:]
            self.storedCount = nil
        }
    }
    
    public override var count: Int {
        get {
            if self.shouldStoreCount {
                if let count = self.storedCount {
                    return count
                }
                let count = super.count
                self.storedCount = count
                return count
            }
            return super.count
        }
    }
    
    public func applyChanges(deletions: [Int], insertions: [Int], updates: [Int], copyFn: ((_ fromIndex: Int, _ toIndex: Int, _ valueToCopy: Type) -> Type?) = { $2 }) {
        self.storedCount = nil
        let deletionChanges = deletions.map { (idx) -> DividableRange<Int>.Divider in
            return DividableRange<Int>.Divider(idx: idx, changeRightFn: { (indexDelta) -> Int in
                return indexDelta - 1
            })
        }
        let insertionChanges = insertions.map { (idx) -> DividableRange<Int>.Divider in
            return DividableRange<Int>.Divider(idx: idx, changeRightFn: { (indexDelta) -> Int in
                return indexDelta + 1
            })
        }
        let changes = deletionChanges + insertionChanges
        let ranges = DividableRange<Int>.rangesFor(baseValue: 0, changes: changes)
        
        var oldStorage: [Int: Type?] = self.storage
        for idx in updates {
            oldStorage[idx] = nil
        }
        for idx in deletions {
            oldStorage[idx] = nil
        }
        var newStorage: [Int: Type] = [:]
        for (idx, val) in oldStorage {
            if let val = val {
                let indexDelta = DividableRange<Int>.binarySearch(idx: idx, ranges: ranges)
                let toIndex = idx+indexDelta
                let result = copyFn(idx, toIndex, val)
                newStorage[toIndex] = result
            }
        }
        
        self.storage = newStorage
    }
}

