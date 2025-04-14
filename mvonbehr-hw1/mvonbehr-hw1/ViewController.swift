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
    
    var array2 = Array(1...3)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
       
        let maxValue = CGFloat(array2.max() ?? 100)
        let percentageData = array2.map { CGFloat($0) / maxValue * 100 }
        
        self.chartView.data = percentageData.map{$0}
        debugPrint(self.chartView.data)

        self.chartView.setNeedsDisplay()
        
    }
    
    @IBAction func sizeSegmentChanged(_ sender: UISegmentedControl) {
        
    }
    



}

