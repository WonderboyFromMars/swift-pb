# swift-pb

Swift-Pb is a port of the excellent rust pb crate! I started this as an experimental project to learn the swift programming language and use it outside of IOS or MacOS.

Example usage

```swift
var pb = ProgressBar(total: 100_000)
pb.showTick = true
pb.format("╢▌▌░╟")
pb.showTimeLeft = false
pb.showPercent = false
pb.showSpeed = true
pb.units = .Bytes

for _ in 0..<100_000 {
    usleep(100)
    let _ = pb.add(1)
}
```
