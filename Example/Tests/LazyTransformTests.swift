//
//  LazyTransformTests.swift
//  LazySeq_Tests
//
//  Created by Oleksii Horishnii on 11/6/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import LazySeq

class LazyTransformTests: QuickSpec {
    override func spec() {
        describe("count") {
            var a: [Int] = []
            let transform = LazyTransform({ () -> Int in
                return a.count
            })
            func cleanupState() {
                a = [1, 2, 3]
                transform.reset()
            }
            it("expected result") {
                cleanupState()
                expect(transform.value()) == 3
            }
            it("saves value & resets value") {
                cleanupState()
                expect(transform.value()) == 3
                a = [1, 2, 3, 4]
                expect(transform.value()) == 3
                transform.reset()
                expect(transform.value()) == 4
            }
        }
    }
}
