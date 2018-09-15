//
//  ViewController.swift
//  HillClimbing
//
//  Created by Daniel Aragon Ore on 9/14/18.
//  Copyright © 2018 Daragonor. All rights reserved.
//

import UIKit
class Cell: UICollectionViewCell{
    
    @IBOutlet weak var numLabel: UITextField!
}
class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let correctAns = [1,2,3,8,0,4,7,6,5]
    var currentArr = [0,3,1,5,2,4,6,7,8]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.numLabel.text = "\(currentArr[indexPath.item])"
        return cell
    }
    
    @IBAction func begin(_ sender: Any) {
        var heuristic = calcHeuristic(currentArr,correctAns)
        if heuristic > 0 {
            var voidIndex = Int()
            for (index,value) in currentArr.enumerated(){
                if value == 0{
                    voidIndex = index
                }
            }
            let indexToSwap = bestCase(voidIndex)
            swapCells(start: voidIndex, end: indexToSwap)
            heuristic = calcHeuristic(currentArr, correctAns)
        }
//        var voidIndex = Int()
//        for (index,value) in currentArr.enumerated(){
//            if value == 0{
//                voidIndex = index
//            }
//        }
//        let indexToSwap = bestCase(voidIndex)
//        swapCells(start: voidIndex, end: indexToSwap)
//        heuristic = calcHeuristic(currentArr, correctAns)
//        pau
//        if heuristic > 0{
//            self.begin(sender)
//        }
    }
    
    func swapCells(start: Int, end: Int){
        collectionView.performBatchUpdates({
            collectionView.moveItem(at: IndexPath(item: start, section: 0), to: IndexPath(item: end, section: 0))
            collectionView.moveItem(at: IndexPath(item: end, section: 0), to: IndexPath(item: start, section: 0))
            currentArr.swapAt(start, end)
        }){ (finished) in
            let heuristic = self.calcHeuristic(self.currentArr, self.correctAns)
                if heuristic > 0{
                    self.begin(send)
                }
            }
    }
    func bestCase(_ voidIndex: Int)->Int{
        var smallest = 100
        var heuristicIndexes: [Int:Int] = [:]
        var randHeuristics: [Int] = []
        for index in 0..<currentArr.count{
            
            if (index == voidIndex - 3 ||
                index == voidIndex + 3 ||
                ( index == voidIndex - 1 && voidIndex % 3 != 0) ||
                (index == voidIndex + 1 && ( voidIndex != 1 || voidIndex != 5 || voidIndex != 8 )) ||
                (voidIndex == 4 && index != 4)
                ){
                var tempCurrenArr = currentArr
                tempCurrenArr.swapAt(index, voidIndex)
                heuristicIndexes[index] = calcHeuristic(tempCurrenArr, correctAns)
            }
        }
        print(heuristicIndexes)
        for (_,small) in heuristicIndexes{
            if small <= smallest{
                smallest = small
            }
        }
        for (index,small) in heuristicIndexes{
            if smallest == small || smallest == small + 1{
                randHeuristics.append(index)
            }
        }
        let bestCase = Int(arc4random_uniform(UInt32(randHeuristics.count)))
        print(randHeuristics)
        return randHeuristics[bestCase]
    }
    func calcHeuristic(_ curr: [Int], _ ans: [Int])->Int{
        var value = 0
        for i in 0..<ans.count {
            if curr[i] != ans[i]{
                value+=1
            }
        }
        return value
    }
    
}

