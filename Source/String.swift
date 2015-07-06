//
//  String.swift
//  SwiftFoundation
//
//  Created by Alsey Coleman Miller on 7/5/15.
//  Copyright © 2015 ColemanCDA. All rights reserved.
//

public extension String {
    
    func rangesOfString(findStr:String) -> [Range<String.Index>] {
        
        // from http://sketchytech.blogspot.com/2014/08/swift-pure-swift-method-for-returning.html
        
        var arr = [Range<String.Index>]()
        var startInd = self.startIndex
        // check first that the first character of search string exists
        if self.characters.contains(findStr.characters.first!) {
            // if so set this as the place to start searching
            startInd = self.characters.indexOf(findStr.characters.first!)!
        }
        else {
            // if not return empty array
            return arr
        }
        var i = distance(self.startIndex, startInd)
        while i<=self.characters.count-findStr.characters.count {
            if self[advance(self.startIndex, i)..<advance(self.startIndex, i+findStr.characters.count)] == findStr {
                arr.append(Range(start:advance(self.startIndex, i),end:advance(self.startIndex, i+findStr.characters.count)))
                i = i+findStr.characters.count
            }
            else {
                i++
            }
        }
        return arr
        
        // try further optimisation by jumping to next index of first search character after every find
    }

    func stringByReplacingOccurrencesOfString(string:String, replacement:String) -> String {
        
        // from http://sketchytech.blogspot.com/2014/08/pure-swift-stringbyreplacingoccurrences.html
        
        // get ranges first using rangesOfString: method, then glue together the string using ranges of existing string and old string
        
        let ranges = self.rangesOfString(string)
        // if the string isn't found return unchanged string
        if ranges.isEmpty {
            return self
        }
        
        var newString = ""
        var startInd = self.startIndex
        for r in ranges {
            
            newString += self[startInd..<r.minElement()!]
            newString += replacement
            
            if r.maxElement() < self.endIndex {
                startInd = advance(r.maxElement()!,1)
            }
        }
        
        // add the last part of the string after the final find
        if (ranges.last!.maxElement()!) < self.endIndex {
            newString += self[advance(ranges.last!.maxElement()!,1)..<self.endIndex]
        }
        
        return newString
        
        // try further optimisation by jumping to next index of first search character after every find
    }
}