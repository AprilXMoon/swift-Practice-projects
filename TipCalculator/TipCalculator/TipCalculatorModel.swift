//
//  TipCalculatorModel.swift
//  TipCalculator
//
//  Created by April Lee on 2014/12/22.
//  Copyright (c) 2014年 april. All rights reserved.
//

import Foundation

class TipCalculatorModel {
    
    var total: Double
    var taxPct: Double
    var subtotal: Double{
        get{
            return total / (taxPct + 1)
        }
    }
    
    init(total: Double, taxPct: Double) {
        self.total = total
        self.taxPct = taxPct
    }
    
    func calcTipWithTipPct(tipPct: Double) -> (tipAmt:Double,total:Double) {
        let tipAmt = subtotal * tipPct;
        let finaltotal =  total + tipAmt
        return (tipAmt,finaltotal)
    }
    
    
    func returnPossibleTips() -> [Int : (tipAmt:Double,total:Double)]{
        
        let possibleTipsInferred = [0.15,0.18,0.20]
        let possibleTipsExplicit:[Double] = [0.15,0.18,0.20]
        
        var retval = Dictionary<Int,(tipAmt:Double,total:Double)>()
        
        for possibleTip in possibleTipsInferred{
            let intPct = Int(possibleTip * 100)
            retval[intPct] = calcTipWithTipPct(possibleTip)
        }
        
        return retval
    }
}
