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
        let maxPossibleValue = CGFloat(topArr.count)
        let normalizedTopArr = topArr.map { $0 / maxPossibleValue * 100 }
            topchartView.data = normalizedTopArr
            topchartView.setNeedsDisplay()
        
        queue.async {
         self.insertionSort(array: self.topArr) { updatedArray in
             DispatchQueue.main.async {
                 self.topArr = updatedArray
                 let normalizedArray = updatedArray.map { $0 / maxPossibleValue * 100 }
                 self.topchartView.data = normalizedArray
                 self.topchartView.setNeedsDisplay()
             }
         }
     }
    }
    

     func insertionSort(array: [CGFloat], onSwap: (([CGFloat]) -> Void)) {
         var result = array
             
         for index in 1..<result.count {
             let element = result[index]
             var j = index
             
             while j > 0 && result[j-1] > element {
                 result[j] = result[j-1]
                 j -= 1
                 Thread.sleep(forTimeInterval: 0.01)
                 debugPrint(result)
                 onSwap(result)
             }
             
             if j != index {
                 result[j] = element
                 onSwap(result)
             }
         }
     }
    
    /*
     func insertionSort(array: [CGFloat], onSwap: (([CGFloat]) -> Void)) {
         var result = array
 
         for index in result.indices {
             let element = result[index]
             
             for innerIndex in 0...index {
                 let innerElement = result[innerIndex]
                 if innerElement > element {
                     debugPrint(result)
                     result.swapAt(innerIndex, index)
                     Thread.sleep(forTimeInterval: 0.2)
                     onSwap(result)
                 }
             }
         }
     }
     */
    
    
    
    
}

