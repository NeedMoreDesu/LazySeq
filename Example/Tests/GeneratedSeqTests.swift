// https://github.com/Quick/Quick

import Quick
import Nimble
import LazySeq

class GeneratedSeqTests: QuickSpec {
    override func spec() {
        describe("GeneratedSeq") {
            context("0..5, reuse") {
                let seq = GeneratedSeq(count: { () -> Int in
                    return 5
                }, generate: { (idx, reuseFn) -> String in
                    if let reused = reuseFn?(nil) {
                        return reused + " is reused with \(idx)"
                    }
                    return "item\(idx)"
                })
                
                it("works") {
                    expect(seq[2]) == "item2"
                }
                
                it("reuses") {
                    let item = seq[0]
                    expect(seq.get(3, reusingFn: { (_) -> String? in
                        return item
                    })) == "item0 is reused with 3"
                }
            }
            context("infinite") {
                let seq = GeneratedSeq(count: nil, generate: { (idx, _) -> Int in
                    return idx
                })
                
                it("can be used to take first 5 results") {
                    expect(Array(seq[0..<5])) == [0, 1, 2, 3, 4]
                }
                
                it("can be used to take 12345678910th element") {
                    expect(seq[12345678910]) == 12345678910
                }
                
                it("can be lazily mapped") {
                    let newSeq = seq.map({ (idx) -> String in
                        return "item\(idx)"
                    })
                    expect(newSeq[999999]) == "item999999"
                }

                it("can be lazily mapped with optional") {
                    let newSeq = seq.map({ (idx) -> String? in
                        return nil
                    })
                    expect(newSeq.get(999999)).to(beNil())
                }
            }
        }
    }
}
