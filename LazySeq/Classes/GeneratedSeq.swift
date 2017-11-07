//
//  GeneratedSeq.swift
//  GeneratedSeq
//
//  Created by Oleksii Horishnii on 10/2/17.
//

import Foundation

open class GeneratedSeq<Type>: Collection {
    let generateFn: ((Int, Any?) -> Type?)
    let countFn: (() -> Int)?

    // MARK:- main functional
    public func get(_ idx: Int, context: Any? = nil) -> Type? {
        if countFn == nil || idx < countFn!() {
            return self.generateFn(idx, context)
        }
        return nil
    }
    
    public func map<ReturnType>(_ transform: @escaping (Type) throws -> ReturnType) rethrows -> GeneratedSeq<ReturnType> {
        let newGeneratedSeq = GeneratedSeq<ReturnType>(count: self.countFn, generate: { (idx, _) -> ReturnType? in
            if let item: Type = self.get(idx) {
                return try! transform(item)
            }
            return nil
        })
        
        return newGeneratedSeq
    }

    public func allObjects() -> [Type] {
        if let countFn = countFn {
            return Array(self.makeIterator().prefix(countFn()))
        }
        return Array(self.makeIterator())
    }

    // MARK:- collection stuff
    public func index(after i: Int) -> Int {
        return i+1
    }
    public var startIndex: Int {
        return 0
    }
    public var endIndex: Int {
        return count
    }
    
    // MARK:- sequence stuff
    public var count: Int {
        get {
            return countFn?() ?? Int.max
        }
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
        assert(countFn == nil || idx < countFn!(), "index out of range")
        return get(idx)!
    }
    
    public func first() -> Type? {
        return first(where: { _ in true})
    }
    
    // MARK:- equality stuff
    public static func ==<Coll>(lhs: GeneratedSeq<Type>, rhs: Coll) -> Bool where Coll: Collection, Coll.Element == Type, Type: Equatable {
        return equalContents1d(lhs: lhs, rhs: rhs)
    }
    public static func ==<Coll>(lhs: Coll, rhs: GeneratedSeq<Type>) -> Bool where Coll: Collection, Coll.Element == Type, Type: Equatable {
        return rhs == lhs
    }
    public func equal2d<Coll>(_ to: Coll) -> Bool where Coll: Collection, Coll.Element: Collection, Type: Collection, Coll.Element.Element == Type.Element, Type.Element: Equatable {
        return equalContents2d(lhs: self, rhs: to)
    }

    // MARK:- initializers
    public init(count: (() -> Int)?, generate: @escaping ((Int, Any?) -> Type?)) {
        self.countFn = count
        self.generateFn = generate
    }
    
    public init(_ array: Array<Type>) {
        self.countFn = { () -> Int in
            return array.count
        }
        self.generateFn = { (idx, _) -> Element? in
            return array[idx]
        }
    }
    
    public init() {
        self.countFn = { 0 }
        self.generateFn = { (_, _) in return nil }
    }
}

public extension GeneratedSeq {
    func lazySeq() -> LazySeq<Type> {
        return LazySeq(count: self.countFn, generate: self.generateFn)
    }
}

public extension GeneratedSeq {
    func generatedSeq() -> GeneratedSeq<Type> {
        return GeneratedSeq(count: self.countFn, generate: self.generateFn)
    }
}

public extension Array where Element: Any {
    func generatedSeq() -> GeneratedSeq<Element> {
        return GeneratedSeq(self)
    }
}

public extension Collection where Element: Any {
    func generatedSeq() -> GeneratedSeq<Element> {
        var indexArray: [Self.Index] = []
        for idx in self.indices {
            indexArray.append(idx)
        }
        return GeneratedSeq(count: { () -> Int in
            return indexArray.count
        }) { (idx, _) -> Element in
            return self[indexArray[idx]]
        }
    }
}

