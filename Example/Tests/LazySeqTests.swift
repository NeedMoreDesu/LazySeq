//
//  LazySeqTests.swift
//  LazySeq_Tests
//
//  Created by Oleksii Horishnii on 10/2/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

// https://github.com/Quick/Quick

import Quick
import Nimble
import LazySeq

class LazySeqTests: QuickSpec {
    override func spec() {
        describe("LazySeq") {
            context("0..9") {
                var numberOfGenerations = 0
                let seq = LazySeq(count: { () -> Int in
                    return 10
                }) { (idx, _) -> String in
                    numberOfGenerations += 1
                    return "\(idx)"
                }
                
                
                it("gets item by idx") {
                    expect(seq[5]) == "5"
                }
                
                it("gets item via .get") {
                    expect(seq.get(5)) == "5"
                }
                
                it("stores and reuses generated objects") {
                    seq.resetStorage()
                    numberOfGenerations = 0
                    for _ in 1..<10 {
                        let _ = seq[3]
                    }
                    expect(numberOfGenerations) == 1
                }
                
                it("can remove generated object") {
                    seq.resetStorage()
                    numberOfGenerations = 0
                    for _ in 0..<10 {
                        for idx in 1...3 {
                            let _ = seq[idx]
                        }
                        seq.resetStorage(2)
                    }
                    expect(numberOfGenerations) == 3+9
                    let _ = seq[2]
                    expect(numberOfGenerations) == 3+9+1
                }
                
                it("gets all elements") {
                    seq.resetStorage()
                    numberOfGenerations = 0
                    expect(seq.allObjects()) == ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
                    expect(numberOfGenerations) == 10
                }
                
                it("getting all elements stops at nil") {
                    let newseq = seq.map({ (str) -> String? in
                        if str == "6" {
                            return nil
                        }
                        return str
                    })
                    expect(newseq.allObjects()) == ["0", "1", "2", "3", "4", "5"]
                }
            }
            
            context("infinite generator") {
                var seq: LazySeq<Int>!
                var numberOfGenerations = 0
                seq = LazySeq(count: nil, generate: { (idx, _) -> Int in
                    numberOfGenerations += 1
                    if idx <= 1 {
                        return 1
                    }
                    return seq[idx-1]+seq[idx-2]
                })
                
                it("generates fibbonaci") {
                    seq.resetStorage()
                    numberOfGenerations = 0
                    expect(Array(seq.prefix(10))) == [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
                    expect(numberOfGenerations) == 10
                }
                it("use ranges") {
                    seq.resetStorage()
                    numberOfGenerations = 0
                    let newSeq = seq[10..<15].generatedSeq()
                    expect(newSeq[2]) == 233
                    expect(numberOfGenerations) == 13
                    expect(newSeq.allObjects()) == [89, 144, 233, 377, 610]
                    expect(numberOfGenerations) == 15
                }
            }
        }
    }
}

