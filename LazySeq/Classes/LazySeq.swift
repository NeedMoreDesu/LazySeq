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
    public private(set) var storage: [Int: Type?] = [:]
    
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
        }
    }
    
    public func applyChanges(deletions: [Int], insertions: [Int], updates: [Int]) {
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
        var newStorage: [Int: Type?] = [:]
        for (idx, val) in oldStorage {
            let indexDelta = DividableRange<Int>.binarySearch(idx: idx, ranges: ranges)
            newStorage[idx+indexDelta] = val
        }
        
        self.storage = newStorage
    }
}

extension LazySeq {
    func generatedSeq() -> GeneratedSeq<Type> {
        return GeneratedSeq(count: self.countFn, generate: self.generateFn)
    }
}
