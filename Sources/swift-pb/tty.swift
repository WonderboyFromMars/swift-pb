//
//  tty.swift
//  swift-pb
//
//  Created by Anuschah Akbar-Rabii on 08.12.18.
//
#if os(Linux)
import Glibc
#elseif os(Windows)
import CRT
import WinSDK
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
    
    guard ioctl(STDOUT_FILENO, UInt(TIOCGWINSZ), &winSize) == 0 else {
        fatalError("ioctl call failed")
    }
    
    print("col: \(winSize.ws_col)")
    let rows = winSize.ws_row
    let cols = winSize.ws_col
    
    return (rows, cols)
    
}
#endif

#if os(Windows)
func terminalSize() -> (UInt16, UInt16) {
    var csbi = UnsafeMutablePointer<CONSOLE_SCREEN_BUFFER_INFO>.allocate(capacity: 1);
    var columns: Int16,  rows: Int16;

    GetConsoleScreenBufferInfo(GetStdHandle(STD_OUTPUT_HANDLE), csbi);
  
    columns = csbi.pointee.srWindow.Right - csbi.pointee.srWindow.Left + 1;
    rows = csbi.pointee.srWindow.Bottom - csbi.pointee.srWindow.Top + 1;

    csbi.deallocate()
   return (UInt16(rows), UInt16(columns))
    
}
#endif
