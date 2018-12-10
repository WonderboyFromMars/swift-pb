
import Foundation
public enum Units {
    case Default
    case Bytes
}

fileprivate func kbFmt(_ val: Double) -> String {
    let kb = 1024.0
    if val >= pow(kb, 4) {
        return String(format: "%.2f TB", val / pow(kb, 4))
    } else if val >= pow(kb, 3) {
        return String(format: "%.2f GB", val / pow(kb, 3))
    } else if val >= pow(kb, 2) {
        return String(format: "%.2f MB", val / pow(kb, 2))
    } else if val >= kb {
        return String(format: "%.2f KB", val / kb)
    }
    return String(format: "%.2f B", val)
}
struct Constants {
    static let TICK_FORMAT = "\\|/-"
    static let NANO_PER_SEC = 1_000_000_000
} 

/**
 The progressbar!
 It can be incremented and the bar will update itself and print a nice terminal based
 progress bar.
 */
public struct ProgressBar {
    /// The start time of the bar. This is the reference time for calculations
    fileprivate var startTime : Date
    
    /// The units to display, if *showSpeed* is active
    public var units : Units
    
    /// The total number of iterations of the bar
    public let total : UInt
    
    /// The current iteration
    fileprivate var current : UInt
    
    fileprivate var barStart: String
    fileprivate var barCurrent: String
    fileprivate var barCurrentN: String
    fileprivate var barRemain: String
    fileprivate var barEnd: String
    fileprivate var tick: Array<Character>
    fileprivate var tickState: Int
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
    public var width : Int

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
        tick = Array(Constants.TICK_FORMAT)
        lastRefreshTime = Date()
        maxRefreshRate = nil
        message = ""
        tickState = 0
        width = 0
    }
    
    /**
     Sets the format of the bar, e.g. ╢▌▌░╟ will create a bar of the type
     ```
     ╢▌▌▌▌▌░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░╟
     ```
     - Parameter fmt: The format string to use
        - first char is the start of the bar
        - second char is the character for the current position
        - third char is the character for the next position
        - fourth char is the fill character
        - last char is the end of the bar
    */
    public mutating func format(_ fmt: String) {
        if fmt.count >= 5 {
            let barElements = Array(fmt)
            barStart = String(barElements[0])
            barCurrent = String(barElements[1])
            barCurrentN = String(barElements[2])
            barRemain = String(barElements[3])
            barEnd = String(barElements[4])
        }
        
    }

    public mutating func message(_ message: String) {
        self.message = message.replacingOccurrences(of: "\n", with: " ").replacingOccurrences(of: "\r", with: " ")
    }

    public mutating func tickFormat(_ tickFmt: String) {
        if tickFmt != Constants.TICK_FORMAT {
            showTick = true
        }

        tick = Array(String(tickFmt))
    }

    mutating func ticker() {
        tickState = (tickState + 1) % tick.count
        if current <= total {
            draw()
        }
    }
    /**
     Increment the progress bar by one. This is the same as invoking
     ```
        let i = pb.add(1)
     ```
     - Returns: current count of the progressbar
     
    */
    public mutating func inc() -> UInt {
        return add(1)
    }
    
    /**
     Increment the progress bar by a number.
     
     - Parameter i: how much the progressbar should be incremented
     - Returns: the current state of the counter
    */
    public mutating func add(_ i: Int) -> UInt {
        current += 1
        ticker()
        return current
    }
    mutating func draw() {
        let elapsedSec = Date().timeIntervalSince(startTime)
        let speed = Double(self.current) / elapsedSec
        if width == 0 {
            width = Int(terminalSize().1)
        }
        var base = ""
        var suffix = ""
        var prefix = ""
        var out = ""
        
        if self.showPercent {
            let percent = Double(current) / (Double(total) / 100.0)
            suffix = suffix + String(format: "%.01f %", percent.isNaN ? 0.0 : percent)
        }
        
        if showSpeed {
            switch self.units {
            case .Default:
                suffix += String(format: "%f/s", speed)
            case .Bytes:
                suffix += kbFmt(speed)
            }
            
        }
        
        if showTimeLeft && current > 0 {
            if total > current {
                let left = 1.0 / speed * Double(total - current)
                if left < 60.0 {
                    suffix = suffix + String(format: "%f s", left)
                } else {
                    suffix = suffix + String(format: "%f m", left / 60.0)
                }
            }
        }
        
        if showMessage {
            prefix = prefix + message
        }
        
        if showCounter {
            prefix = prefix + String(format: "%u/%u", current, total)
            
        }
        
        if showTick {
            prefix = prefix + String(tick[tickState])
        }
        
        if showBar {
            let p = prefix.count + suffix.count + 3
            if p < width {
                let size = width - p
                let currCount = Int(((Double(current) / Double(total)) * Double(size)).rounded())
                if size >= currCount {
                    let remainCount = size - currCount
                    base = barStart
                    if remainCount > 0 && currCount > 0 {
                        base = base + String(repeating: barCurrent, count: currCount - 1) + barCurrentN
                    } else {
                        base = base + String(repeating: barCurrent, count: currCount)
                    }
                    base = base + String(repeating: barRemain, count: remainCount) + barEnd
                }
            }
        }
        
        out = prefix + base + suffix
        if out.count < width {
            let gap = width - out.count
            out = out + String(repeating: " ", count: gap)
        }
        print("\u{1B}[1A\u{1B}[K\(out)")
        lastRefreshTime = Date()
    }
}
