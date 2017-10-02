//
//  LazySeq.swift
//  PerfectExample
//
//  Created by Oleksii Horishnii on 1/23/17.
//  Copyright © 2017 Oleksii Horishnii. All rights reserved.
//

import Foundation

open class LazySeq<Type>: GeneratedSeq<Type> {
    private var storage: [Int: Type?] = [:]
    
    override public func get(_ idx: Int, reusingFn: ((Any?) -> Type?)? = nil) -> Type? {
        if let obj = storage[idx] {
            return obj
        }
        let obj = super.get(idx, reusingFn: reusingFn)
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
}
