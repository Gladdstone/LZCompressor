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
let regex = try! NSRegularExpression(pattern: "^.*\\.jzip$")

print("Enter filepath: ")
let fileName = readLine()

if (regex.firstMatch(in: fileName!, options: [], range: NSRange(location: 0, length: fileName!.count)) != nil) {
    print("decompress")
    //let decompressed = lz.decompress(compressed: compressed)
    //print(decompressed!)
} else {
    print("compress")
    let fileStats = lz.compress(fileName: fileName!)
    
    print("File compression complete. Output file \(fileStats.outputURL) created")
    print("Initial file size: \(fileStats.initSize)")
    print("Compressed file size: \(fileStats.finalSize)")
    
    let ratio = 1 / (Float(fileStats.initSize) / Float(fileStats.finalSize))
    print("Compression ratio: \(ratio)")
}




