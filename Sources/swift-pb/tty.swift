//
//  tty.swift
//  swift-pb
//
//  Created by Anuschah Akbar-Rabii on 08.12.18.
//
#if os(Linux)
import Glibc
#else
import Darwin.C
#endif

#if os(Linux) || os(macOS)
func terminalSize() -> (UInt16, UInt16) {
    let isTTY = isatty(STDOUT_FILENO) == 1
    if !isTTY {
        return (0,0)
    }
    
    var winSize = winsize()
    
    ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winSize)
    
    print("col: \(winSize.ws_col)")
    let rows = winSize.ws_row
    let cols = winSize.ws_col
    
    return (rows, cols)
    
}
#endif
