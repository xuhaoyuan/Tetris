//
//  GameTimer.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 13..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class GameTimer: NSObject {
    
    var counter = 0
    private let displayLink: CADisplayLink
    
    init(target:AnyObject, selector:Selector) {
        self.displayLink = CADisplayLink(target: target, selector: selector)
        self.displayLink.preferredFramesPerSecond = 30
        self.displayLink.isPaused = true
        self.displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.default)
        super.init()
    }
    
    func start() {
        self.displayLink.isPaused = false
    }
    func pause() {
        self.displayLink.isPaused = true
    }
    deinit {
        print("deinit GameTimer")
        displayLink.remove(from: RunLoop.current, forMode: .default)
    }
    
}
