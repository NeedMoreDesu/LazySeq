//
//  GeneratedSeq.swift
//  GeneratedSeq
//
//  Created by Oleksii Horishnii on 10/2/17.
//

import Foundation

open class GeneratedSeq<Type>: Sequence {
    private let generate: ((Int, ((Any?) -> Type?)?) -> Type?)
    private let countFn: (() -> Int)?
    
    public var count: Int {
        get {
            return countFn?() ?? 0
        }
    }
    
    public func get(_ idx: Int, reusingFn: ((Any?) -> Type?)? = nil) -> Type? {
        if countFn == nil || idx < countFn!() {
            return self.generate(idx, reusingFn)
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
    
    public func map<ReturnType>(_ transform: @escaping (Type) throws -> ReturnType?) rethrows -> GeneratedSeq<ReturnType> {
        let newGeneratedSeq = GeneratedSeq<ReturnType>(count: self.countFn, generate: { (idx, _) -> ReturnType? in
            if let item: Type = self.get(idx) {
                return try! transform(item)
            }
            return nil
        })
        
        return newGeneratedSeq
    }
    
    public func map<ReturnType>(_ transform: @escaping (Type) throws -> ReturnType) rethrows -> GeneratedSeq<ReturnType> {
        let tr: ((Type) throws -> ReturnType?) = transform
        return try! self.map(tr)
    }
    
    public func allObjects() -> [Type] {
        return Array(self)
    }
    
    public init(count: (() -> Int)?, generate: @escaping ((Int, ((Any?) -> Type?)?) -> Type?)) {
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
    func generatedSeq() -> GeneratedSeq<Element> {
        return GeneratedSeq(count: { () -> Int in
            self.count
        }, generate: { (idx, _) -> Element? in
            self[idx]
        })
    }
}

