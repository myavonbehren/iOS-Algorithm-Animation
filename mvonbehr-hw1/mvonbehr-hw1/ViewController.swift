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
    
    var queue: DispatchQueue = DispatchQueue(label: "")
    
    var topArr: [CGFloat] = []
    var bottomArr: [CGFloat] = []
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bottomChartView.color = .orange
        sizeSegmentChanged(sizeSegControl)
        
        
    }
    
    
    @IBAction func sizeSegmentChanged(_ sender: UISegmentedControl) {
        let size: Int
        
        switch sender.selectedSegmentIndex {
        case 0: size = 16
        case 1: size = 32
        case 2: size = 48
        case 3: size = 64
        default: size = 16
        }
        
        topArr = Array(1...size).shuffled().map{CGFloat($0)}
        bottomArr = Array(1...size).shuffled().map{CGFloat($0)}

        topchartView.data = setBarData(topArr)
        bottomChartView.data = setBarData(bottomArr)
        topchartView.setNeedsDisplay()
        bottomChartView.setNeedsDisplay()
    }
    
    func setBarData(_ data: [CGFloat]) -> [CGFloat] {
        let maxValue = data.max() ?? 100
        return data.map { $0 / maxValue * 100 }
    }
    
    
    @IBAction func sort(_ sender: UIButton) {
        /*
        switch algorithmPickerTop.selectedSegmentIndex {
        case 0:
            test.insertionSort(array16, )
        
        }*/
    }
    
    
}

