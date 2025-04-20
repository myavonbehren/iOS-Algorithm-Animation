//
//  ViewController.swift
//  mvonbehr-hw1
//
//  Created by Mya Von Behren on 4/14/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topchartView: ChartView!
    @IBOutlet weak var bottomChartView: ChartView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sizeSegControl: UISegmentedControl!
    @IBOutlet weak var algorithmPickerTop: UISegmentedControl!
    @IBOutlet weak var algorithmPickerBottom: UISegmentedControl!
    
    var array16 = Array(1...16).shuffled()
    var array32 = Array(1...32).shuffled()
    var array48 = Array(1...48).shuffled()
    var array64 = Array(1...64).shuffled()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bottomChartView.color = .orange
        sizeSegmentChanged(sizeSegControl)
        
        
    }
    
    @IBAction func sizeSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.topchartView.data = setBarData(array16.map{CGFloat($0)})
            self.topchartView.setNeedsDisplay()
            self.bottomChartView.data = setBarData(array16.map{CGFloat($0)})
            self.bottomChartView.setNeedsDisplay()
        case 1:
            self.topchartView.data = setBarData(array32.map{CGFloat($0)})
            self.topchartView.setNeedsDisplay()
            self.bottomChartView.data = setBarData(array32.map{CGFloat($0)})
            self.bottomChartView.setNeedsDisplay()
        case 2:
            self.topchartView.data = setBarData(array48.map{CGFloat($0)})
            self.topchartView.setNeedsDisplay()
            self.bottomChartView.data = setBarData(array48.map{CGFloat($0)})
            self.bottomChartView.setNeedsDisplay()
        case 3:
            self.topchartView.data = setBarData(array64.map{CGFloat($0)})
            self.topchartView.setNeedsDisplay()
            self.bottomChartView.data = setBarData(array64.map{CGFloat($0)})
            self.bottomChartView.setNeedsDisplay()
        default:
            return
        }
        
    }
    
    func setBarData(_ data: [CGFloat]) -> [CGFloat] {
        let maxValue = data.max() ?? 100
        return data.map { CGFloat($0) / maxValue * 100 }
    }
    
}

