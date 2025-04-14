//
//  ViewController.swift
//  mvonbehr-hw1
//
//  Created by Mya Von Behren on 4/14/25.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var chartView: ChartView!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var sizeSegControl: UISegmentedControl!
    @IBOutlet weak var algorithmPickerTop: UISegmentedControl!
    @IBOutlet weak var algorithmPickerBottom: UISegmentedControl!
    
    var array16 = Array(1...16)
    var array32 = Array(1...32)
    var array48 = Array(1...48)
    var array64 = Array(1...64)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func sizeSegmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.chartView.data = setBarData(array16.map{CGFloat($0)})
            self.chartView.setNeedsDisplay()
        case 1:
            self.chartView.data = setBarData(array32.map{CGFloat($0)})
            self.chartView.setNeedsDisplay()
        case 2:
            self.chartView.data = setBarData(array48.map{CGFloat($0)})
            self.chartView.setNeedsDisplay()
        case 3:
            self.chartView.data = setBarData(array64.map{CGFloat($0)})
            self.chartView.setNeedsDisplay()
        default:
            return
        }
        
    }
    
    func setBarData(_ data: [CGFloat]) -> [CGFloat] {
        let maxValue = data.max() ?? 100
        return data.map { CGFloat($0) / maxValue * 100 }
    }
    



}

