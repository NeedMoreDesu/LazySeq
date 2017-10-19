# LazySeq & GeneratedSeq

[![Version](https://img.shields.io/cocoapods/v/LazySeq.svg?style=flat)](http://cocoapods.org/pods/LazySeq)
[![License](https://img.shields.io/cocoapods/l/LazySeq.svg?style=flat)](http://cocoapods.org/pods/LazySeq)
[![Platform](https://img.shields.io/cocoapods/p/LazySeq.svg?style=flat)](http://cocoapods.org/pods/LazySeq)

Everybody heard about lazy sequences, that's not new. But what the hell is Generated Sequence?

GeneratedSeq is basically a nice wrapper around closures `countFn` and `generateFn`. It doesn't store any values it gets from this functions, just gives more human-like interface (you can treat it as Sequence or Collection). It will use `generateFn` on every call to get the items with those indexes.

LazySeq is subclass of GeneratedSeq that actually saves values to `storage` index->value dictionary (is available for lookup) once they are calculated. Next time lookup occurs, saved value is taken without re-evaluation. To force re-evaluation, you can use `resetStorage` method.

## Example

Lets have a try!

```swift
let seq = GeneratedSeq(count: { () -> Int in
                    return 5
                }, generate: { (idx, _) -> String? in
                    guard (idx < 5) else {
                        return nil
                    }
                    return "item\(idx)"
                })

seq // GeneratedSeq<String>
seq[2] // "item2"
seq[2..<5] // ["item2", "item3", "item4"]
seq[5] // crash, index out of range
seq.get(0) // Optional("item0")
seq.get(5) // nil
```

#### Q: Why generate returns optional, while non-optional seq is created?

A: Sometimes, you cannot create items beyond some index, but it doesn't mean sequence will be broken, because count function will limit us to non-nil results.

`.map` function, on the other side, doesn't return optional values on transformation, because you are guaranteed to have the item if the first place, and will never run off-bounds.

#### Q: What is going on in second parameter of generate closure?

A: When we get our value with `.get(idx: context:)` function, we can pass anything to the generate function.

```swift
let seq = GeneratedSeq(count: { () -> Int in
                    return 5
                }, generate: { (idx, context) -> String in
                    return "item\(idx) with context \(context)"
                })
seq[2] // "item2 with context nil"
seq.get(2, [3, 4]) // "item2 with context [3, 4]"
```

You can pass closures to the context too :)

### Special olympics

Fibonacci!

```swift
var seq: LazySeq<Int>! // so we can reference it inside
seq = LazySeq(count: nil, generate: { (idx, _) -> Int in
    if idx <= 1 {
        return 1
    }
    return seq[idx-1]+seq[idx-2]
})

seq.prefix(10) // [1, 1, 2, 3, 5, 8, 13, 21, 34, 55]
seq[10..<15] // [89, 144, 233, 377, 610]
```

## Installation

LazySeq is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LazySeq'
```

## Author

Oleksii Horishnii, oleksii.horishnii@gmail.com

## License

LazySeq is available under the MIT license. See the LICENSE file for more info.
