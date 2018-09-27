//
//  LZRefactor.swift
//  LZCompressor
//
//  Created by Joe Farrell on 9/24/18.
//  Copyright © 2018 Joe Farrell. All rights reserved.
//

import Foundation

class LZ {
    
    func compress(fileName: String) -> (outputURL: String, initSize: UInt64, finalSize: UInt64) {
        var rawData = ""
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(fileName)
            
            do {
                rawData = try String(contentsOf: fileURL, encoding: .ascii)
                
                let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                initFileSize = attr[FileAttributeKey.size] as! UInt64
                
                print("Compressing file: \(fileName)")
            } catch {
                print("Unable to read in data. Terminating file compression...")
                exit(EXIT_FAILURE)
            }
        }
        
        var refDic = [String: Int]()
        var refCnt = 256;
        
        for i in 0..<256 {
            let str = String(UnicodeScalar(i)!)
            refDic[str] = i
        }
        
        var matchWindow = ""
        var compressed = [Int]()
        for char in rawData {
            let searchWindow = matchWindow + String(char)
            
            if refDic[searchWindow] != nil {
                matchWindow = searchWindow
            } else {
                compressed.append(refDic[matchWindow]!)
                refCnt += 1
                refDic[searchWindow] = refCnt
                matchWindow = String(char)
            }
        }
        
        if matchWindow != "" {
            compressed.append(refDic[matchWindow]!)
        }
        
        let outputURL = fileName.split(separator: ".")[0] + ".jzip"
        print(outputURL)
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent(String(outputURL))
            
            do {
                let stringEncoding = compressed.description
                try stringEncoding.write(to: fileURL, atomically: false, encoding: .ascii)
                
                let attr = try FileManager.default.attributesOfItem(atPath: fileURL.path)
                finalFileSize = attr[FileAttributeKey.size] as! UInt64
                
                return (String(outputURL), initFileSize, finalFileSize)
            }
            catch {
                print("Unable to output compressed data to file")
                exit(EXIT_FAILURE)
            }
        }
        
        return ("", 0, 0)
    }
    
    func decompress(compressed: [Int]) -> String? {
        var refDic = [Int: String]()
        var refCnt = 256
        
        for i in 0..<256 {
            refDic[i] = String(UnicodeScalar(i)!)
        }
        
        var matchWindow = String(UnicodeScalar(refDic[0]!)!)
        var decompressed = matchWindow
        for char in compressed[1..<compressed.count] {
            let searchWindow: String
            
            if let x = refDic[char] {
                searchWindow = x
            } else if char == refCnt {
                searchWindow = matchWindow + String(matchWindow.first!)
            } else {
                return nil
            }
            
            decompressed += searchWindow
            refCnt += 1
            refDic[refCnt] = matchWindow + String(searchWindow.first!)
            matchWindow = searchWindow
        }
        
        return decompressed
    }
    
}
