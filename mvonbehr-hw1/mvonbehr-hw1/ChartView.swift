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
    
    var color : UIColor = .green
    var spacing : CGFloat = 10
    var data: [CGFloat] = []
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext( ) {
            if data.isEmpty { return }
            
            let barCount = CGFloat(data.count)
            let totalSpacing = spacing * (barCount - 1)
            let barWidth = (self.frame.width - totalSpacing) / barCount
            
            
            context.setFillColor(self.color.cgColor)

            
            for (index, value) in data.enumerated( ) {
                let fillHeight = self.frame.height * (value / 100)
                let xPosition = CGFloat(index) * (barWidth + spacing)
                
                context.fill(CGRect(x: xPosition,
                                    y: self.frame.height - fillHeight,
                                    width: barWidth,
                                    height: fillHeight))
            }
        
        }
        
    }

}
