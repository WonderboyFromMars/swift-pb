
import Foundation
public enum Units {
    case Default
    case Bytes
}

struct Constants {
    static let TICK_FORMAT = "\\|/-"
    static let NANO_PER_SEC = 1_000_000_000
} 

public struct ProgressBar {
    fileprivate var startTime : Date
    fileprivate let units : Units
    public let total : UInt
    var current : UInt
    fileprivate var barStart: String
    fileprivate var barCurrent: String
    fileprivate var barCurrentN: String
    fileprivate var barRemain: String
    fileprivate var barEnd: String
    fileprivate var tick: [String]
    fileprivate var tickState: UInt
    //fileprivate var width: Option<usize>
    fileprivate var message: String
    fileprivate var lastRefreshTime: Date
    fileprivate var maxRefreshRate: Date?
    public var isFinish: Bool
    public var showBar: Bool
    public var showSpeed: Bool
    public var showPercent: Bool
    public var showCounter: Bool
    public var showTimeLeft: Bool
    public var showTick: Bool
    public var showMessage: Bool

    public init(total: UInt) {
        self.total = total
        current = 0
        startTime = Date()
        units = Units.Default
        isFinish = false
        showBar = true
        showSpeed = true
        showPercent = true
        showCounter = true
        showTimeLeft = true
        showTick = false
        showMessage = true
        barStart = ""
        barCurrent = ""
        barCurrentN = ""
        barRemain = ""
        barEnd = ""
        tick = [String]()
        lastRefreshTime = Date()
        maxRefreshRate = nil
        message = ""
        tickState = 0
    }

    public mutating func format(_ fmt: String) {
        if fmt.count >= 5 {
            let barElements = fmt.components(separatedBy: "")
            barStart = barElements[0]
            barCurrent = barElements[1]
            barCurrentN = barElements[2]
            barRemain = barElements[3]
            barEnd = barElements[4]
        }
        
    }

    public mutating func message(_ message: String) {
        self.message = message.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\r", with: " ")
    }

    public mutating func tickFormat(_ tickFmt: String) {
        if tickFmt != Constants.TICK_FORMAT {
            showTick = true
        }

        tick = tickFmt.components(separatedBy: "")
    }

    func draw() {
        let now = Date()

        let elapsedNano = Calendar.current.dateComponents([.nanosecond], from: self.startTime, to: now).nanosecond
        let elapsedSec = Calendar.current.dateComponents([.second], from: self.startTime, to: now).second
        let speed = Double(self.current) / fracDur(nanoSec: elapsedNano!, sec: elapsedSec!)
    }
}

func fracDur(nanoSec: Int, sec: Int) -> Double {
    return Double(sec) + Double(nanoSec) / Double(Constants.NANO_PER_SEC)
}