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
    
    var queue: DispatchQueue = DispatchQueue(label: "sort", qos: .background)
        
    var topHeights: [CGFloat] = []
    var topPositions: [Int] = []
    
    var bottomHeights: [CGFloat] = []
    var bottomPositions: [Int] = []
  
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
        
        topHeights = Array(1...size).shuffled().map{CGFloat($0)}
        topPositions = Array(0..<size)
        
        bottomArr = Array(1...size).shuffled().map{CGFloat($0)}

        topchartView.heights = topHeights
        topchartView.positions = topPositions
        topchartView.setNeedsDisplay()
    }
    
    func setBarData(_ data: [CGFloat]) -> [CGFloat] {
        let maxValue = data.max() ?? 100
        return data.map { $0 / maxValue * 100 }
    }
    
    
    @IBAction func sort(_ sender: UIButton) {
        queue.async {
            self.insertionSort(array: self.topArr) { updatedArray in
                DispatchQueue.main.async {
                    self.topArr = updatedArray
                    self.updateUI(self.topArr)
                }
            }
        }
    }
    
    func updateUI(_ array: [CGFloat]){
        self.topchartView.data = self.setBarData(array)
        self.topchartView.setNeedsDisplay()
    }
    
    func insertionSort(array: [CGFloat], onSwap: (([CGFloat]) -> Void)) {
        var result = array
        
        for index in result.indices {
            let element = result[index]
            
            for innerIndex in 0...index {
                let innerElement = result[innerIndex]
                if innerElement > element {
                    result.swapAt(innerIndex, index)
                    Thread.sleep(forTimeInterval: 0.01)
                    onSwap(result)
                }
            }
        }
    }
    
    
    
}

