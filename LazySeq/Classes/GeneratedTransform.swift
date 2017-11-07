//
//  GeneratedTransform.swift
//  Observed
//
//  Created by Oleksii Horishnii on 11/4/17.
//

import Foundation

public class GeneratedTransform<Type> {
    private var transform: (() -> Type)
    
    public func value() -> Type {
        return self.transform()
    }
    
    public static func ==<Type2>(lhs: GeneratedTransform<Type>, rhs: Type2) -> Bool where Type: Equatable {
        if let rhs = rhs as? Type {
            return lhs.value() == rhs
        } else {
            return false
        }
    }
    public static func ==<Type2>(lhs: Type2, rhs: GeneratedTransform<Type>) -> Bool where Type: Equatable {
        if let lhs = lhs as? Type {
            return rhs.value() == lhs
        } else {
            return false
        }
    }

    public init(_ transform: @escaping (() -> Type)) {
        self.transform = transform
    }
}
