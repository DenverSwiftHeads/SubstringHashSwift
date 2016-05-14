//
//  ViewController.swift
//  TrelloJobApplication
//
//  Created by Vui Nguyen on 2/28/16.
//  Copyright © 2016 Sunfish Empire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let ProblemHashKey = "acdegilmnoprstuw"
    let DefaultHashNumber = 25377615533200
    let DefaultWordLength = 8
    
    // MARK: Properties
    @IBOutlet weak var hashNumberField: UITextField!
    @IBOutlet weak var stringLengthField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    var hashReverser: ((Int64) -> String)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks
        hashNumberField.delegate   = self
        stringLengthField.delegate = self
        resetToDefaults()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions
    @IBAction func stringLengthChanged(sender: AnyObject) {
        updateReverseHash()
    }
    
    @IBAction func calculateStringFromHash(sender: UIButton) {
        let hashie: Int64? = Int64(hashNumberField.text!);
        let reverseHashValues = hashReverser(hashie!)
        answerLabel.text = reverseHashValues
//        answerLabel.text            = reverseHashValues.calculatedString
//        answerLabel.backgroundColor = reverseHashValues.background
    }
    
    @IBAction func resetToDefaultValues(sender: UIButton) {
        resetToDefaults()
    }
    
    // MARK: View Helpers
    func resetToDefaults() -> Void {
        hashNumberField.text   = String(format: "%ld", DefaultHashNumber)
        stringLengthField.text = String(format: "%d", DefaultWordLength)
        answerLabel.text       = "<answer displayed here>"
        answerLabel.backgroundColor = UIColor.clearColor()
        updateReverseHash()
    }
    
    func updateReverseHash() -> Void {
        let wordLength = Int(stringLengthField.text!) ?? DefaultWordLength
        hashReverser = HashUtils.reverseHashGen(wordLength, hashKey: ProblemHashKey)
    }
}

