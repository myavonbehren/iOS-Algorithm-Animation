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
    var percentage2: CGFloat = 0
    var color : UIColor = .green
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext( ) {
            let barWidth: CGFloat = self.frame.width / 2
            
            let fillHeight = self.frame.height * (self.percentage / 100)
            
        
            context.setFillColor(self.color.cgColor)
            context.fill(CGRect(x: 0,
                                y: self.frame.height - fillHeight,
                                width: barWidth,
                                height: fillHeight))
            
            let fillHeight2 = self.frame.height * (self.percentage2 / 100)
            context.setFillColor(self.color.cgColor)
            context.fill(CGRect(x: barWidth,
                                y: self.frame.height - fillHeight2,
                                width: barWidth,
                                height: fillHeight2))
        }
        
        
    }

}
