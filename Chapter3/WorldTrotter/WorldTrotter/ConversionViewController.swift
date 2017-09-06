//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Kevin on 17/08/2017.
//  Copyright © 2017 Kevin. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var celsiusLabel: UILabel!
    
    @IBOutlet var textField: UITextField!
    
    var fahrenheitvalue: Measurement<UnitTemperature>?{
        didSet {
            updateCelsiusLabel()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>?{
        if let fahrenheitvalue = fahrenheitvalue {
            return fahrenheitvalue.converted(to: .celsius)
        }else{
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateCelsiusLabel()
        
        let string = "Mon-Thurs:  8:00 - 18:00\nFri:        7:00 - 17:00\nSat-Sun:    10:00 - 15:00"
        let skippedCharacters = NSMutableCharacterSet()
        skippedCharacters.formIntersection(with: NSCharacterSet.punctuationCharacters)
        skippedCharacters.formIntersection(with: NSCharacterSet.whitespaces)
        
        string.enumerateLines { (line, _) in
            let scanner = Scanner(string: line)
            scanner.charactersToBeSkipped = skippedCharacters as CharacterSet
            
            var startDay, endDay: NSString?
            var startHour: Int = 0
            var startMinute: Int = 0
            var endHour: Int = 0
            var endMinute: Int = 0
            
            scanner.scanCharacters(from: NSCharacterSet.letters, into: &startDay)
            scanner.scanCharacters(from: NSCharacterSet.letters, into: &endDay)
            
            scanner.scanInt(&startHour)
            scanner.scanInt(&startMinute)
            scanner.scanInt(&endHour)
            scanner.scanInt(&endMinute)
        }
        
    }

    @IBAction func fahrenheitFieldEditingChanged(_ textField: UITextField){
        
        if let text = textField.text, let value = Double(text) {
            fahrenheitvalue = Measurement(value: value, unit: .fahrenheit)
        }else {
            fahrenheitvalue = nil
        }
    }
    
    func updateCelsiusLabel() {
        if let celsiusValue = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }else{
            celsiusLabel.text = "???"
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
        textField.resignFirstResponder()
    }
    
    // MARK: - UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        print("Current text: \(textField.text!)")
//        print("Replacement text: \(string)")
//        return true
        
        
        // prevent text field enter more than two decimal separator
//        let exitingTextHasDecimalSeparator = textField.text?.range(of: ".")
//        let replacementTextHasDecimalSeparator = string.range(of: ".")
//        
//        if exitingTextHasDecimalSeparator != nil,
//           replacementTextHasDecimalSeparator != nil{
//            return false
//        }else{
//            return true
//        }
        
        let characterSet = NSCharacterSet.decimalDigits.inverted
        
        let filterStrings = string.components(separatedBy: characterSet)
        
        let textStr = filterStrings.joined(separator: "")
        
        if string == textStr {
            return true
        }else{
            return false
        }
    }
}
