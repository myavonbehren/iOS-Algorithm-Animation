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
        let algorithm: (([CGFloat], (([CGFloat]) -> Void)) -> Void)
        
        switch self.algorithmPickerTop.selectedSegmentIndex {
            case 0: algorithm = insertionSort
            case 1: algorithm = selectionSort
            default: algorithm = insertionSort
        }
        
        let maxPossibleValue = CGFloat(topArr.count)
        
        let normalizedTopArr = topArr.map { $0 / maxPossibleValue * 100 }
            topchartView.data = normalizedTopArr
            topchartView.setNeedsDisplay()
        
        queue.async {
            algorithm(self.topArr) { updatedArray in
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
        
        /*
         selectionSort(array, size)
           for i from 0 to size - 1 do
             set i as the index of the current minimum
             for j from i + 1 to size - 1 do
               if array[j] < array[current minimum]
                 set j as the new current minimum index
             if current minimum is not i
               swap array[i] with array[current minimum]
         end selectionSort
         */
    }
    
    /*
     
     quickSort(array, leftmostIndex, rightmostIndex)
       if (leftmostIndex < rightmostIndex)
         pivotIndex <- partition(array,leftmostIndex, rightmostIndex)
         quickSort(array, leftmostIndex, pivotIndex - 1)
         quickSort(array, pivotIndex, rightmostIndex)

     partition(array, leftmostIndex, rightmostIndex)
       set rightmostIndex as pivotIndex
       storeIndex <- leftmostIndex - 1
       for i <- leftmostIndex + 1 to rightmostIndex
       if element[i] < pivotElement
         swap element[i] and element[storeIndex]
         storeIndex++
       swap pivotElement and element[storeIndex+1]
     return storeIndex + 1
     */
    
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

