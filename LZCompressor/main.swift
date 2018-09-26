//
//  main.swift
//  LZCompressor
//
//  Created by Joe Farrell on 9/4/18.
//  Copyright © 2018 Joe Farrell. All rights reserved.
//

import Foundation

let lz:LZ = LZ()
var rawData = ""
var initFileSize: UInt64 = 0
var finalFileSize: UInt64 = 0

print("Enter filepath: ")
let fileName = readLine()

// Start user input loop, break out on successful input or quit
var loop = 1
while loop == 1 {
    if fileName == "exit" || fileName == "" {
        exit(EXIT_SUCCESS)
    }
    
    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
        let fileURL = dir.appendingPathComponent(fileName!)
        
        do {
            rawData = try String(contentsOf: fileURL, encoding: .ascii)
            
            let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
            initFileSize = attr[FileAttributeKey.size] as! UInt64
            
            print("Compressing file: \(fileName!)")
            
            loop = 0
        } catch {
            print("Unable to read in data. Terminating file compression...")
            exit(EXIT_FAILURE)
        }
    }
}

// perform the actual compression
let compressed = lz.compress(rawData: rawData)

var outputURL = fileName!.split(separator: ".")[0] + ".jzip"
print(outputURL)

if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
    let fileURL = dir.appendingPathComponent(String(outputURL))

    do {
        print("Fix this")
        let stringEncoding = compressed.description
        try stringEncoding.write(to: fileURL, atomically: false, encoding: .ascii)
        
        let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
        finalFileSize = attr[FileAttributeKey.size] as! UInt64
        
        print("File compression complete. Output file \(outputURL) created")
        print("Initial file size: \(initFileSize)")
        print("Compressed file size: \(finalFileSize)")
        print("Compression ratio: \(finalFileSize / initFileSize)")
    }
    catch {
        print("Unable to output compressed data to file")
        exit(EXIT_FAILURE)
    }
}

//let decompressed = lz.decompress(compressed: compressed)
//print(decompressed!)
