//: Playground - noun: a place where people can play

import SwiftFoundation
import Foundation


let items  = ["coleman", "Coleman", "alsey", "miller", "Z", "A"]

let sortedItems = (items as NSArray).sortedArrayUsingDescriptors([NSSortDescriptor(key: nil, ascending: true)])

