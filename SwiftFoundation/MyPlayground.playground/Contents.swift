//: Playground - noun: a place where people can play

import SwiftFoundation
import Foundation


let items = ["coleman", "Coleman", "alsey", "miller", "Z", "A"]

let ascending = false

let sortedItems = (items as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: nil, ascending: ascending)])

let sortedItems2 = Sort(items, sortDescriptor: ComparableSortDescriptor(ascending: ascending))

