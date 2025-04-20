//
//  SortingAlgorithms.swift
//  mvonbehr-hw1
//
//  Created by Mya Von Behren on 4/20/25.
//

import Foundation

class SortingAlgorithms {
    
    func insertionSort(array: [Int], onSwap: (([Int]) -> Void)) {
        var result = array
        
        for index in result.indices {
            let element = result[index]
            
            for innerIndex in 0...index {
                let innerElement = result[innerIndex]
                if innerElement > element {
                    result.swapAt(innerIndex, index)
                    Thread.sleep(forTimeInterval: 0.001)
                    onSwap(result)
                }
            }
        }
    }
            
        
        
    func selectionSort(_ array: [Int]) -> [Int] {
        return [0]
        
    }
    
    func quickSort(_ array: [Int]) -> [Int] {
        return [0]
        
    }
    
    func mergeSort(_ array: [Int]) -> [Int] {
        return [0]
    }
        
        
   
    
    
}
