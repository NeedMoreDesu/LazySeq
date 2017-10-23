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
            }
            
            context("0..7, nil, 9") {
                var numberOfGenerations = 0
                let seq = LazySeq(count: { () -> Int in
                    return 10
                }) { (idx, _) -> String? in
                    if idx == 8 {
                        return nil
                    }
                    return "\(idx)"
                }
                
                it("getting all elements stops at nil") {
                    expect(seq.allObjects()) == ["0", "1", "2", "3", "4", "5", "6", "7"]
                }
            }
            
            context("0..4") {
                var numberOfGenerations = 0
                let seq = LazySeq(count: { () -> Int in
                    return 5
                }) { (idx, _) -> String? in
                    if idx == 8 {
                        return nil
                    }
                    return "\(idx)"
                }
                
                it("getting all elements stops at seq.count") {
                    expect(seq.allObjects()) == ["0", "1", "2", "3", "4"]
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
            
            context("apply changes") {
                var arr: [Int]!
                let seq = LazySeq(count: { () -> Int in
                    return arr.count
                }) { (idx, _) -> Int? in
                    return arr[idx]
                }
                
                it("works") {
                    seq.resetStorage()
                    arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
                    expect(seq[3]) == 3
                    expect(seq[7]) == 7
                }
                
                it("apply delete") {
                    seq.resetStorage()
                    arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    expect(seq.allObjects()) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    seq.applyChanges(deletions: [2, 4], insertions: [], updates: [])
                    let expectedArr = [1, 2, 4, 6, 7, 8, 9, 10]
                    for idx in 0..<8 {
                        expect(seq.storage[idx]!) == expectedArr[idx]
                    }
                }

                it("apply insertion") {
                    seq.resetStorage()
                    arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    expect(seq.allObjects()) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    arr = [1, 9001, 2, 3, 4, 5, 6, 9002, 7, 8, 9, 10]
                    seq.applyChanges(deletions: [], insertions: [1, 6], updates: [])
                    expect(seq.storage[2]!) == 2
                    expect(seq.storage[8]!) == 7
                    expect(seq.allObjects()) == [1, 9001, 2, 3, 4, 5, 6, 9002, 7, 8, 9, 10]
                }
                
                it("apply update") {
                    seq.resetStorage()
                    arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    expect(seq.allObjects()) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    arr = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                    seq.applyChanges(deletions: [], insertions: [], updates: [1, 4, 6])
                    expect(seq.allObjects()) == [1, 20, 3, 4, 50, 6, 70, 8, 9, 10]
                }
                
                it("apply alltogether") {
                    seq.resetStorage()
                    arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    expect(seq.allObjects()) == [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                    arr = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
                    seq.applyChanges(deletions: [3], insertions: [6], updates: [0, 1, 2])
                    expect(seq.allObjects()) == [10, 20, 30, 5, 6, 60, 7, 8, 9, 10]
                }
            }
        }
    }
}

