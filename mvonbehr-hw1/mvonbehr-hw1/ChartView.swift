//
//  ChartView.swift
//  mvonbehr-hw1
//
//  Created by Mya Von Behren on 4/14/25.
//

import UIKit

class ChartView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var percentage: CGFloat = 0
    var color : UIColor = .green
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext( ) {
            let fillHeight = self.frame.height * (self.percentage / 100)
            
            context.setFillColor(self.color.cgColor)
            context.fill(CGRect(x: self.frame.origin.x,
                                y: self.frame.height - fillHeight,
                                width: self.frame.width,
                                height: fillHeight))
        }
    }

}
