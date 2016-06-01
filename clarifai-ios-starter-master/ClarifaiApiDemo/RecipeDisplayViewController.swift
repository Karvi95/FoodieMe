//
//  ViewController.swift
//  FoodieMe
//
//  Created by iGuest on 5/16/16.
//  Copyright © 2016 Info498Team4. All rights reserved.
//

import UIKit

struct recipeIDInfo {
    static var recipeID = ""
    static var recipeName = ""
    static var course = ""
    static var pictureIngredients : [String] = []
    static var directions : [String] = []
}

class RecipeDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    let theData = GetData()
    
    @IBOutlet weak var tableView: UITableView!
    var recipeNamesToIds : [[String : String]] = [[:]]
    var courses : [String] = []
    
    var returnedRecipes : [Recipe] = [Recipe]()
    
    var pictureIngredients : [String] = []
    
    var favoritesArray : [Recipe] = []
       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        tableView.dataSource = self
        tableView.delegate = self
        
        recipeIDInfo.pictureIngredients = self.pictureIngredients
        
        self.theData.searchRecipes {
            self.recipeNamesToIds = self.theData.recipeNamesToIds
            self.courses = self.theData.courses
            
            self.returnedRecipes = self.theData.returnedRecipes

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if self.returnedRecipes.isEmpty {
                    var int: CGFloat = 30
                    let label = UILabel(frame: CGRectMake(40, 100, 300, 21))
                    label.text = "There were no matches!"
                    label.textAlignment = NSTextAlignment.Left
                    label.textColor = UIColor.blackColor()
                    label.center = CGPointMake(182, int)
                    int = int + 30
                    
                    self.tableView.addSubview(label)
                }
                
                self.tableView.reloadData()
            })
        }
    }

    
//    func makeString(pictureIngredients: [String]) -> String {
//        var stringToSend = ""
//        stringToSend += ("&allowedIngredient[]=" + pictureIngredients[0])
//        for i in 1 ..< pictureIngredients.count {
//            stringToSend += ("&allowedIngredient[]=" + pictureIngredients[i])
//        }
//        return stringToSend
//    }
    
    @IBAction func goHome(sender: AnyObject) {
        let homeView = storyboard?.instantiateViewControllerWithIdentifier("home") as! SwiftRecognitionViewController!
        //homeView.favoritesArray = self.favoritesArray
        self.presentViewController(homeView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return returnedRecipes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell
        
        let dict = returnedRecipes[indexPath.row].recipeNameToIdDict
        let recipeName = Array(dict.keys)[indexPath.section]
        
        
        cell.subject.text = recipeName
        let text = returnedRecipes[indexPath.row].course
        if text != "Unspecified" {
            cell.subtitle.text = text
        } else {
            cell.subtitle.text = ""
        }
        
        let url = NSURL(string:returnedRecipes[indexPath.row].imageURL)
        let data = NSData(contentsOfURL:url!)
        if data != nil {
            cell.photo.image = UIImage(data:data!)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let prepVC = self.storyboard?.instantiateViewControllerWithIdentifier("PreparationDisplay") as! PreparationViewController
        prepVC.givenRecipe = returnedRecipes[indexPath.row]
        prepVC.pictureIngredients = recipeIDInfo.pictureIngredients
        prepVC.imageURL = returnedRecipes[indexPath.row].imageURL
        //prepVC.favoritesArray = self.favoritesArray
        
        
        recipeIDInfo.recipeID = returnedRecipes[indexPath.row].recipeNameToIdDict[Array(returnedRecipes[indexPath.row].recipeNameToIdDict.keys)[indexPath.section]]!
        recipeIDInfo.recipeName = Array(returnedRecipes[indexPath.row].recipeNameToIdDict.keys)[indexPath.section]
        
        recipeIDInfo.course = returnedRecipes[indexPath.row].course
        
        
        
//        print("ID: \(recipeIDInfo.recipeID)")
//        print("Name: \(recipeIDInfo.recipeName)")
        
        self.presentViewController(prepVC, animated: false, completion: nil)
    }
}