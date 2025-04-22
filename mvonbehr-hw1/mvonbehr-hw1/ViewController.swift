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
    
    // worker threads
    // qos userInteractive
    
    var topArr: [CGFloat] = []
    var bottomArr: [CGFloat] = []
    
    enum ViewState {
        case stopped
        case running
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.bottomChartView.color = .orange
        sizeSegmentChanged(sizeSegControl)
    }
    
    // lecture 2
    // two different threads
    // async
    
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
        sortButton.isEnabled = false
        
        let selectedTop = algorithmPickerTop.selectedSegmentIndex
        let selectedBottom = algorithmPickerBottom.selectedSegmentIndex
        
        let maxPossibleValueBottom = CGFloat(bottomArr.count)
        let maxPossibleValueTop = CGFloat(topArr.count)
        
        let normalizedTopArr = topArr.map { $0 / maxPossibleValueTop * 100 }
        let normalizedBottomArr = bottomArr.map { $0 / maxPossibleValueBottom * 100 }
        
        topchartView.data = normalizedTopArr
        topchartView.setNeedsDisplay()
        
        bottomChartView.data = normalizedBottomArr
        bottomChartView.setNeedsDisplay()
        
        queue.async {
            let topOnSwap: ([CGFloat]) -> Void = { updatedArray in DispatchQueue.main.async {
                self.topArr = updatedArray
                let normalizedArray = updatedArray.map { $0 / maxPossibleValueTop * 100 }
                self.topchartView.data = normalizedArray
                self.topchartView.setNeedsDisplay()
                }
            }
            
            
            switch selectedTop {
                case 0:
                    self.insertionSort(array: self.topArr, onSwap: topOnSwap)
                case 1:
                    self.selectionSort(array: self.topArr, onSwap: topOnSwap)
                case 2:
                    var qsArr = self.topArr
                    self.quickSort(array: &qsArr, low: 0, high: qsArr.count - 1, onSwap: topOnSwap)
                default: self.insertionSort(array: self.topArr, onSwap: topOnSwap)
            }
            
            let bottomOnSwap: ([CGFloat]) -> Void = { updatedArray in DispatchQueue.main.async {
                self.bottomArr = updatedArray
                let normalizedArray = updatedArray.map { $0 / maxPossibleValueBottom * 100 }
                self.bottomChartView.data = normalizedArray
                self.bottomChartView.setNeedsDisplay()
                }
            }
            
            switch selectedBottom {
            case 0:
                self.insertionSort(array: self.bottomArr, onSwap: bottomOnSwap)
            case 1:
                self.selectionSort(array: self.bottomArr, onSwap: bottomOnSwap)
            case 2:
                var qsArr = self.bottomArr
                self.quickSort(array: &qsArr, low: 0, high: qsArr.count - 1, onSwap: bottomOnSwap)
            default: self.insertionSort(array: self.bottomArr, onSwap: bottomOnSwap)
            }
            
        }
        sortButton.isEnabled = true
        
        
        
    }
    
    
    
    private func handle(_ newState: ViewState) {
        
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
    
    func mergeSort(array: [CGFloat], onSwap: (([CGFloat]) -> Void)) {
        
    }
    
    /*
     def mergeSort(array):
         if len(array) > 1:

             #  r is the point where the array is divided into two subarrays
             r = len(array)//2
             L = array[:r]
             M = array[r:]

             # Sort the two halves
             mergeSort(L)
             mergeSort(M)

             i = j = k = 0

             # Until we reach either end of either L or M, pick larger among
             # elements L and M and place them in the correct position at A[p..r]
             while i < len(L) and j < len(M):
                 if L[i] < M[j]:
                     array[k] = L[i]
                     i += 1
                 else:
                     array[k] = M[j]
                     j += 1
                 k += 1

             # When we run out of elements in either L or M,
             # pick up the remaining elements and put in A[p..r]
             while i < len(L):
                 array[k] = L[i]
                 i += 1
                 k += 1

             while j < len(M):
                 array[k] = M[j]
                 j += 1
                 k += 1
     */
    
    
    
}

