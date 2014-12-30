// Playground - noun: a place where people can play

import Foundation
import UIKit


//tuple
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

class TestDataSource : NSObject, UITableViewDataSource {
    
    let tipCalc = TipCalculatorModel(total: 33.25, taxPct: 0.06)
    var possibleTips = Dictionary<Int, (tipAmt:Double,total:Double)>()
    var sortedKeys:[Int] = []
    
    override init() {
        possibleTips = tipCalc.returnPossibleTips()
        sortedKeys = sorted(Array(possibleTips.keys))
        super.init()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedKeys.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Value2, reuseIdentifier: nil)
        
        let tipPct = sortedKeys[indexPath.row]
        
        let tipAmt = possibleTips[tipPct]!.tipAmt
        let total = possibleTips[tipPct]!.total
        
        cell.textLabel?.text = "\(tipPct)%:"
        cell.detailTextLabel?.text = String(format: "Tip:$%0.2f,Total:$0.2f",tipAmt,total)
        
        return cell
        
    }
    
}

let testDataSource = TestDataSource()
let tableview = UITableView(frame: CGRect(x: 0, y: 0, width: 320, height: 320), style: .Plain)
tableview.dataSource = testDataSource
tableview.reloadData()


//protocol

@objc protocol Speaker{
    func Speak()
    optional func TellJoke()
}

class Vicki:Speaker{
    func Speak() {
        println("Hello, I am Vicki!")
    }
    
    func TellJoke() {
        println("Q:What did Sushi A say to Sushi B?")
    }
}

class Ray : Speaker{
    func Speak() {
        println("Yo, I am Ray")
    }
    func TellJoke() {
        println("Q: Whats the object-oriented way to become wealthy?")
    }
    func WriteTutorial(){
        println("I'm on it!")
    }
    
}

class Animal{
    
}

class Dog : Animal,Speaker {
    func Speak() {
        println("Woof!")
    }
}


var speaker:Speaker
speaker =  Ray()
speaker.Speak()
(speaker as Ray).WriteTutorial()
speaker = Vicki()
speaker.Speak()

speaker.TellJoke?()  //put a ? mark after the method name,it will check if it exists before calling it.
speaker = Dog()
speaker.TellJoke?()

//delegate

protocol DateSimulatorDelegate{
    func dateSimulatorDidStart(sim:DateSimulator,a:Speaker,b:Speaker)
    func dateSimulatorDidEnd(sim:DateSimulator,a:Speaker,b:Speaker)
}


class LoggingDateSimulator:DateSimulatorDelegate{
    func dateSimulatorDidStart(sim: DateSimulator, a: Speaker, b: Speaker) {
        println("Date started!")
    }
    func dateSimulatorDidEnd(sim: DateSimulator, a: Speaker, b: Speaker) {
        println("Date ended!")
    }
}


class DateSimulator{
    let a:Speaker
    let b:Speaker
    var delegate:DateSimulatorDelegate?
    
    
    init(a:Speaker, b:Speaker){
        self.a = a
        self.b = b
    }
    
    func simulate(){
        delegate?.dateSimulatorDidStart(self, a: a, b: b)
        println("Off to dinner...")
        a.Speak()
        b.Speak()
        println("Walking back home")
        a.TellJoke?()
        b.TellJoke?()
        delegate?.dateSimulatorDidEnd(self, a: a, b: b)
    }
}

let sim = DateSimulator(a:Vicki(),b:Ray())

sim.delegate = LoggingDateSimulator()
sim.simulate()



func switchtest(idx: Int){
    switch idx{
    case 0, 1, 2:
        println("Small")
    case 3...7:
        println("Medium")
    case 8..<10:
        println("Large")
    case _ where idx % 2 == 0:
        println("Even")
    case _ where idx % 2 == 1:
        println("Odd")
    default:
        break
    }
}

func switchStringTest(Name : NSString){
    switch Name{
        case "Matt Galloway":
            println("Autor of an interesting Swift article")
        case "Ray Wenderlich":
            println("Has a great website")
        case "Tim Cook":
            println("CEO of Apple Inc.")
        default:
            println("Someone else")
    }
}







