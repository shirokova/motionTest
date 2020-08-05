//
//  CGRect+Diagonal.swift
//  MotionTest
//
//  Created by Anna Shirokova on 05/08/2020.
//  Copyright © 2020 Anna Shirokova. All rights reserved.
//

import CoreGraphics

extension CGRect {
    var diagonalSize: CGFloat {
        sqrt((width * width) + ((height) * (height)))
    }
}
