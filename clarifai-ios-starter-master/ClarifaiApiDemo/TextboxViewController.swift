//
//  TextboxViewController.swift
//  ClarifaiApiDemo
//
//  Created by MyungJin Eun on 5/19/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit

class TextboxViewController: UIViewController {
    
    var favoritesArray : [Recipe] = []
    
    @IBOutlet weak var inputBox: UITextField!
    
    @IBAction func clickTextbox(sender: AnyObject) {
        if inputBox.textColor == UIColor.lightGrayColor() {
            inputBox.text = nil
            inputBox.textColor = UIColor.blackColor()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        inputBox.text = "Type in items separated by a comma"
        inputBox.textColor = UIColor.lightGrayColor()
    }
    
    func inputBoxDidBeginEditing(inputBox: UITextField) {
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let foodlist = self.inputBox.text?.lowercaseString
        let foodarray = foodlist!.componentsSeparatedByString(",")
        let DestViewController: RecipeDisplayViewController = segue.destinationViewController as! RecipeDisplayViewController
        DestViewController.pictureIngredients = foodarray
        DestViewController.favoritesArray = self.favoritesArray
    }
    
}
