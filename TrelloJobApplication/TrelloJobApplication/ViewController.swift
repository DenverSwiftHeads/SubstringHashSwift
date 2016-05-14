//
//  ViewController.swift
//  TrelloJobApplication
//
//  Created by Vui Nguyen on 2/28/16.
//  Copyright © 2016 Sunfish Empire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    let DefaultHashNumber = 25377615533200
    let DefaultWordLength = 8
    
    // MARK: Properties
    @IBOutlet weak var hashNumberField: UITextField!
    @IBOutlet weak var stringLengthField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    var hashConfiguration: HashConfigurationModel!
    var hashReverser: ((Int64) -> String)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetToDefaults()
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Actions
    @IBAction func hashNumberChanged(sender: AnyObject) {
        updateHashConfiguration()
    }
    
    @IBAction func stringLengthChanged(sender: AnyObject) {
        updateHashConfiguration()
    }
    
    @IBAction func calculateStringFromHash(sender: UIButton) {
        let reverseHashValues = hashReverser(hashConfiguration.hashNumber)
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
        
        updateHashConfiguration()
    }
    
    func updateHashConfiguration() -> Void {
        let hashNumber: Int64 = Int64(hashNumberField.text!)!;
        let wordLength = Int(stringLengthField.text!) ?? DefaultWordLength
        let newConfiguration = HashConfigurationModel(hashNumber: hashNumber, wordLength: wordLength)
        if newConfiguration != hashConfiguration {
            hashConfiguration = newConfiguration
            updateReverseHash()
        }
    }
    
    func updateReverseHash() -> Void {
        hashReverser = HashUtils.reverseHashGen(hashConfiguration.wordLength, hashKey: ProblemHashKey)
    }
}

