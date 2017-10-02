//
//  LazySeq.swift
//  PerfectExample
//
//  Created by Oleksii Horishnii on 1/23/17.
//  Copyright © 2017 Oleksii Horishnii. All rights reserved.
//

import Foundation

open class LazySeq<Type>: Sequence {
    private let generate: ((Int, ((Any) -> Type?)?) -> Type?)
    private let countFn: (() -> Int)?
    
    public var count: Int {
        get {
            return countFn?() ?? 0
        }
    }
    
    public func get(_ idx: Int, reusingFn: ((Any) -> Type?)? = nil) -> Type? {
        if countFn == nil || idx < countFn!() {
            if let obj = self.generate(idx, reusingFn) {
                return obj
            }
        }
        return nil
    }

    public func makeIterator() -> AnyIterator<Type> {
        var idx = 0
        return AnyIterator<Type> {
            let item = self.get(idx)
            idx = idx + 1
            return item
        }
    }
    
    public subscript(idx: Int) -> Type {
        return get(idx)!
    }
    
    public func map<ReturnType>(_ transform: @escaping (Type) throws -> ReturnType?) rethrows -> LazySeq<ReturnType> {
        let newLazySeq = LazySeq<ReturnType>(count: self.countFn, generate: { (idx, _) -> ReturnType? in
            if let item: Type = self.get(idx) {
                return try! transform(item)
            }
            return nil
        })
        
        return newLazySeq
    }
    
    public func map<ReturnType>(_ transform: @escaping (Type) throws -> ReturnType) rethrows -> LazySeq<ReturnType> {
        let tr: ((Type) throws -> ReturnType?) = transform
        return try! self.map(tr)
    }
    
    public func allObjects() -> [Type] {
        var arr: [Type] = []
        for idx in 0..<count {
            arr.append(self[idx])
        }
        return arr
    }
    
    public init(count: (() -> Int)?, generate: @escaping ((Int, ((Any) -> Type?)?) -> Type?)) {
        self.countFn = count
        self.generate = generate
    }

    public func first() -> Type? {
        return first(where: { _ in true})
    }
    
    public init() {
        self.countFn = { 0 }
        self.generate = { (_, _) in return nil }
    }
}

public extension Array where Element: Any {
    func lazySeq() -> LazySeq<Element> {
        return LazySeq(count: { () -> Int in
            self.count
        }, generate: { (idx, _) -> Element? in
            self[idx]
        })
    }
}
