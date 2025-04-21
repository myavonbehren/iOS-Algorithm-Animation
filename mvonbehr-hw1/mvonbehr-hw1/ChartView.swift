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
    var spacing : CGFloat = 4
    var heights: [CGFloat] = []
    var positions: [Int] = []
    
    override func draw(_ rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext( ) {
            if heights.isEmpty { return }
            
            let barCount = CGFloat(heights.count)
            let totalSpacing = spacing * (barCount - 1)
            let barWidth = (self.frame.width - totalSpacing) / barCount
            
            let maxHeight = heights.map({$0}).max() ?? 100
            
            context.setFillColor(self.color.cgColor)

            
            for (index, value) in heights.enumerated( ) {
                let height = heights[index]
                let position = positions[index]
                
                let heightPercentage = height / maxHeight
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
