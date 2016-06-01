//
//  FavDisplayViewController.swift
//  ClarifaiApiDemo
//
//  Created by MyungJin Eun on 5/31/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit

/*struct recipeIDInfo {
    static var recipeID = ""
    static var recipeName = ""
    static var course = ""
    static var pictureIngredients : [String] = []
    static var directions : [String] = []
}*/

class FavDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    
    var favoritesArray : [favRece] = []
    
    @IBOutlet weak var favTableView: UITableView!
    
    /*
     public var recipeNameToIdDict : [String : String]
     public var course : String
     public var ingredients : [String]
     public var imageURL: String
 */
 
    /*let theData = GetData()
    
    @IBOutlet weak var tableView: UITableView!
    var recipeNamesToIds : [[String : String]] = [[:]]
    var courses : [String] = []
    
    var returnedRecipes : [Recipe] = [Recipe]()
    
    var pictureIngredients : [String] = []*/
    
    func loadMeals() -> [favRece]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(favRece.ArchiveURL.path!) as? [favRece]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedMeals = loadMeals() {
            favoritesArray += savedMeals
        }
        // Do any additional setup after loading the view, typically from a nib.
        
        favTableView.dataSource = self
        favTableView.delegate = self
        
        //recipeIDInfo.pictureIngredients = self.pictureIngredients
        
        /*self.theData.searchRecipes {
            self.recipeNamesToIds = self.theData.recipeNamesToIds
            self.courses = self.theData.courses
            
            self.returnedRecipes = self.theData.returnedRecipes
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.tableView.reloadData()
            })
        }*/
    }
    
    //    func makeString(pictureIngredients: [String]) -> String {
    //        var stringToSend = ""
    //        stringToSend += ("&allowedIngredient[]=" + pictureIngredients[0])
    //        for i in 1 ..< pictureIngredients.count {
    //            stringToSend += ("&allowedIngredient[]=" + pictureIngredients[i])
    //        }
    //        return stringToSend
    //    }
    
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
        return favoritesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.favTableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TableViewCell

        cell.subject.text = favoritesArray[indexPath.row].name
        
        
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController: SwiftRecognitionViewController = segue.destinationViewController as! SwiftRecognitionViewController
        //DestViewController.favoritesArray = self.favoritesArray
    }
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let prepVC = self.storyboard?.instantiateViewControllerWithIdentifier("PreparationDisplay") as! PreparationViewController
        prepVC.givenRecipe = favoritesArray[indexPath.row]
        prepVC.pictureIngredients = recipeIDInfo.pictureIngredients
        prepVC.imageURL = favoritesArray[indexPath.row].imageURL
        //prepVC.favoriteButton.setTitle("unFavorite", forState: .Normal)
        
        recipeIDInfo.recipeID = favoritesArray[indexPath.row].recipeNameToIdDict[Array(favoritesArray[indexPath.row].recipeNameToIdDict.keys)[indexPath.section]]!
        recipeIDInfo.recipeName = Array(favoritesArray[indexPath.row].recipeNameToIdDict.keys)[indexPath.section]
        
        recipeIDInfo.course = favoritesArray[indexPath.row].course
        
        
        
        //        print("ID: \(recipeIDInfo.recipeID)")
        //        print("Name: \(recipeIDInfo.recipeName)")
        
        self.presentViewController(prepVC, animated: false, completion: nil)
    }*/
}
