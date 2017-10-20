//
//  LazySeq.swift
//  PerfectExample
//
//  Created by Oleksii Horishnii on 1/23/17.
//  Copyright © 2017 Oleksii Horishnii. All rights reserved.
//

import Foundation

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
}

extension LazySeq {
    func generatedSeq() -> GeneratedSeq<Type> {
        return GeneratedSeq(count: self.countFn, generate: self.generateFn)
    }
}
