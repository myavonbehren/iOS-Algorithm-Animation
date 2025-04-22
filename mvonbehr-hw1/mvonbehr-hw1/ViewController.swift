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
    
    private var dispatchQueue: DispatchQueue = DispatchQueue(label: "background", qos: .background)
    private var queue1: DispatchQueue = DispatchQueue(label: "queue-1", qos: .userInteractive)
    private var queue2: DispatchQueue = DispatchQueue(label: "queue-2", qos: .userInteractive)
    
    var topArr: [CGFloat] = []
    var bottomArr: [CGFloat] = []
    
    enum ViewState {
        case stopped
        case running
    }
    
    var state: ViewState = .stopped {
        didSet {
            self.handle(state)
        }
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bottomChartView.color = .orange
        sizeSegmentChanged(sizeSegControl)
    }
    
    private func handle(_ newState: ViewState) {
        let selectedTop = algorithmPickerTop.selectedSegmentIndex
        let selectedBottom = algorithmPickerBottom.selectedSegmentIndex
        
        switch newState {
        case .stopped:
            sortButton.isEnabled = true
        case .running:
            sortButton.isEnabled = false
            
            self.dispatchQueue.async {
                let group = DispatchGroup()
                
                // Top Array
                group.enter()
                self.queue1.async {
                    
                    let topOnSwap: ([CGFloat]) -> Void = { updatedArray in DispatchQueue.main.async {
                        self.topArr = updatedArray
                        self.topchartView.data = self.setBarData(self.topArr)
                        self.topchartView.setNeedsDisplay()
                        }
                    }
                    
                    switch selectedTop {
                        case 0:
                            self.insertionSort(array: self.topArr, onSwap: topOnSwap)
                        case 1:
                            self.selectionSort(array: self.topArr, onSwap: topOnSwap)
                        case 2:
                            var quickSortArray = self.topArr
                            self.quickSort(array: &quickSortArray, low: 0, high: quickSortArray.count - 1, onSwap: topOnSwap)
                        case 3:
                            var mergeSortArr = self.topArr
                            self.mergeSort(array: &mergeSortArr, low: 0, high: mergeSortArr.count - 1, onSwap: topOnSwap)
                        default: self.insertionSort(array: self.topArr, onSwap: topOnSwap)
                    }
                    
                    group.leave()
                }
                
                // Bottom Array
                group.enter()
                self.queue2.async {
                    let bottomOnSwap: ([CGFloat]) -> Void = { updatedArray in DispatchQueue.main.async {
                        self.bottomArr = updatedArray
                        self.bottomChartView.data = self.setBarData(self.bottomArr)
                        self.bottomChartView.setNeedsDisplay()
                        }
                    }
                    
                    switch selectedBottom {
                    case 0:
                        self.insertionSort(array: self.bottomArr, onSwap: bottomOnSwap)
                    case 2:
                        var quickSortArray = self.bottomArr
                        self.quickSort(array: &quickSortArray, low: 0, high: quickSortArray.count - 1, onSwap: bottomOnSwap)
                    case 3:
                        var mergeSortArr = self.bottomArr
                        self.mergeSort(array: &mergeSortArr, low: 0, high: mergeSortArr.count - 1, onSwap: bottomOnSwap)
                    default: self.insertionSort(array: self.bottomArr, onSwap: bottomOnSwap)
                    }
                
                    group.leave()
                }
                group.wait()
                
                DispatchQueue.main.async {
                    self.state = .stopped
                }
            }
        }
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
        let maxValue = CGFloat(data.count)
        return data.map { $0 / maxValue * 100 }
    }
    
    
    @IBAction func sort(_ sender: UIButton) {
        switch self.state {
        case .stopped:
            self.state = .running
        case .running:
            self.state = .stopped
        }
    }
    
    
    // Sorting Algorithms
     func insertionSort(array: [CGFloat], onSwap: (([CGFloat]) -> Void)) {
         var result = array
             
         for index in 1..<result.count {
             let element = result[index]
             var j = index
             
             while j > 0 && result[j-1] > element {
                 result[j] = result[j-1]
                 j -= 1
                 Thread.sleep(forTimeInterval: 0.01)
                 onSwap(result)
             }
             
             if j != index {
                 result[j] = element
                 onSwap(result)
             }
         }
     }
    
    func selectionSort(array: [CGFloat], onSwap: (([CGFloat]) -> Void)) {
        var result = array
        let size = array.count
        
        for index in 0..<size-1 {
            var minIndex = index
            
            for j in index+1..<size {
                if result[j] < result[minIndex] {
                    minIndex = j
                }
            }
            
            if minIndex != index {
                result.swapAt(index, minIndex)
                Thread.sleep(forTimeInterval: 0.1)
                onSwap(result)
            }
        }
    }
    
    func partition(array: inout [CGFloat], low: Int, high: Int, onSwap: (([CGFloat]) -> Void)) -> Int {
        let pivot = array[high]
        var index = low - 1
        
        for j in low..<high {
            if array [j] <= pivot {
                index += 1
                array.swapAt(index, j)
                Thread.sleep(forTimeInterval: 0.1)
                onSwap(array)
            }
        }
        array.swapAt(index+1, high)
        onSwap(array)
        return index+1
    }
    
    func quickSort(array: inout [CGFloat], low: Int, high: Int, onSwap: (([CGFloat]) -> Void)) {
        if (low < high) {
            let pivotIndex = partition(array: &array, low: low, high: high, onSwap: onSwap)
            quickSort(array: &array, low: low, high: pivotIndex - 1, onSwap: onSwap)
            quickSort(array: &array, low: pivotIndex + 1, high: high, onSwap: onSwap)
        }
    }
    
    func merge(array: inout [CGFloat], low: Int,  high: Int, mid: Int, onSwap: (([CGFloat]) -> Void)) {
        
        let n1 = mid - low + 1
        let n2 = high - mid

        var left: [CGFloat] = []
        var right: [CGFloat] = []
        
        for i in 0..<n1 {
            left.append(array[low + i])
        }
        for i in 0..<n2 {
            right.append(array[mid + 1 + i])
        }
        
        var i = 0
        var j = 0
        var k = low
        
        while i < n1 && j < n2 {
            if left[i] <= right[j] {
                array[k] = left[i]
                i += 1
            } else {
                array[k] = right[j]
                j += 1
            }
            k += 1
            Thread.sleep(forTimeInterval: 0.05)
            onSwap(array)
        }
        
        while (i < n1) {
            array[k] = left[i]
            i += 1
            k += 1
            Thread.sleep(forTimeInterval: 0.05)
            onSwap(array)
        }
        
        while (j < n2) {
            array[k] = right[j]
            j += 1
            k += 1
            Thread.sleep(forTimeInterval: 0.05)
            onSwap(array)
        }
    }
    
    func mergeSort(array: inout [CGFloat], low: Int, high: Int, onSwap: (([CGFloat]) -> Void)) {
        if (low < high) {
            let mid = low + (high - low) / 2
            
            mergeSort(array: &array, low: low, high: mid, onSwap: onSwap)
            mergeSort(array: &array, low: mid + 1, high: high, onSwap: onSwap)
            merge(array: &array, low: low, high: high, mid: mid, onSwap: onSwap)
        }
        
    }
    
    
    
    
}

