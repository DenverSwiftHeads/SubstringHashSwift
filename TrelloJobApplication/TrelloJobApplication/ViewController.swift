//
//  ViewController.swift
//  TrelloJobApplication
//
//  Created by Vui Nguyen on 2/28/16.
//  Copyright © 2016 Sunfish Empire. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    @IBOutlet weak var hashNumberField: UITextField!
    @IBOutlet weak var stringLengthField: UITextField!
    @IBOutlet weak var answerLabel: UILabel!
    
    let ProblemHashKey = "acdegilmnoprstuw"
    let DefaultHashNumber = 25377615533200
    let DefaultWordLength = 8
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
        hashReverser = reverseHashGen(wordLength, hashKey: ProblemHashKey)
    }
    
    // MARK: Hash Computations
    
    // Given a String, find its hash
    func hash (inputString: String) ->Int64
    {
        var h:Int64 = 7
        let letters:String = "acdegilmnoprstuw"
        
        for i in 0..<inputString.characters.count {
            let inputStringIndex = inputString.startIndex.advancedBy(i);
            
            let inputStringChar = inputString[inputStringIndex]
            let lettersIndex = letters.characters.indexOf(inputStringChar)
            let position = letters.startIndex.distanceTo(lettersIndex!)
            h = (h * 37 + position);
        }
        return h
    }
    
    // Generate a reverse hash function given a word length and the hash key
    func reverseHashGen(wordLength: Int, hashKey: String) -> (Int64) -> String {
        return {[weak self] (hashie: Int64) -> String in
            guard let strongSelf = self else { return "" }
            return strongSelf.reverseHash(hashie, wordLength: wordLength, hashKey: hashKey)
        }
    }
    
    func reverseHash(hashie:Int64, wordLength:Int, hashKey: String) -> String
    {
        let remainders = computeRemainders(hashie, wordLength: wordLength)
        let resultString = decodeRemainders(remainders, wordLength: wordLength, hashKey: hashKey)
        return resultString
    }
    
    func computeRemainders(hashie: Int64, wordLength: Int) -> [Int64] {
        var remainders:[Int64] = [hashie]
        for i in 1...wordLength {
            remainders.append(remainders[i-1] / 37)
        }
        return remainders
    }
    
    func decodeRemainders(remainders:[Int64], wordLength: Int, hashKey: String) -> String {
        var resultString = ""
        
        for i in (0..<wordLength).reverse() {
            let letterIndex = remainders[i] - (remainders[i+1] * 37)
            let lettersStringIndex = hashKey.startIndex.advancedBy(Int(letterIndex));
            
            resultString.append(hashKey[lettersStringIndex])
        }
        
        return resultString;
    }
}

