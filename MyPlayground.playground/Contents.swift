//: Playground - noun: a place where people can play

import SwiftFoundation
import Foundation

class Test {
    
    func observe() {
        
        NotificationCenter.defaultCenter.addObserver(self, method: Test.notification, name: "Hey", domain: "Test", sender: nil)
    }
    
    func notification(n: Notification<AnyObject>) {
        
        print("Hey")
    }
}

let