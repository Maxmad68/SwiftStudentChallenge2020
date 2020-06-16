//
//  Extensions.swift
//  BookCore
//
//  Created by Maxime on 15/05/2020.
//

import Foundation
import CoreGraphics

extension CGPoint {
    public func Distance(from: CGPoint) -> CGFloat {
		// Returns distance between two points
        return sqrt(pow(self.x - from.x, 2) + pow(self.y - from.y, 2))
    }
}

extension CGVector {
    public var Abs: CGFloat {
        get {
			// Get absolute value of the vector
            return sqrt(pow(dx, 2) + pow(dy, 2))
        }
    }
}

