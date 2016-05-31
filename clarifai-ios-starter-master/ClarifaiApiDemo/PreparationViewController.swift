//
//  PreparationViewController.swift
//  FoodieMe
//
//  Created by iGuest on 5/19/16.
//  Copyright © 2016 Info498Team4. All rights reserved.
//

import UIKit

class PreparationViewController: UIViewController {

    let theData = GetData()
    
    @IBOutlet weak var RecipeName: UILabel!
    
    @IBOutlet weak var Course: UILabel!
    
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var LabelinScrollView: UILabel!
    
    @IBOutlet weak var imageofFood: UIImageView!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    var labeltext = ""
    
    var givenRecipe: Recipe!
    
    var returnedPreps : [Preparation] = [Preparation]()
    
    var inFavorite = false
    var favorites : [Recipe] = [Recipe]()
    
    var pictureIngredients : [String] = []
    
    var favoritesArray : [Recipe] = []
    
    var imageURL: String!
    
    @IBAction func FavoriteButton(sender: AnyObject) {
        /*inFavorite = !inFavorite
        if(inFavorite) {
            
        }*/
        // pop up alert saying that it's successfully added and ask if the user wants to see the list of favorites
        // check if the recipe is already in the favorites
        if (sender.titleLabel!!.text == "Favorite") {
            favoritesArray.append(givenRecipe)
        } else {
            //delete it
            print("Delete the given recipe from favorites list")
        }
        print(favoritesArray)
    }
    
    @IBAction func goHome(sender: AnyObject) {
        let homeView = storyboard?.instantiateViewControllerWithIdentifier("home") as! SwiftRecognitionViewController!
        homeView.favoritesArray = self.favoritesArray
        self.presentViewController(homeView, animated: true, completion: nil)
    }
    
    
    @IBAction func myShareButton(sender: UIButton) {
        // Hide the keyboard
        RecipeName.resignFirstResponder()
        // Check and see if the text field is empty
        if (RecipeName.text == "") {
            // The text field is empty so display an Alert
            displayAlert("Warning", message: "The title is empty yo")
        } else {
            // We have contents so display the share sheet
            displayShareSheet(RecipeName.text!)
        }
    }
    
    func displayShareSheet(shareContent:String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        presentViewController(activityViewController, animated: true, completion: {})
    }
    
    func displayAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
        return
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RecipeName.text = recipeIDInfo.recipeName
        if recipeIDInfo.course != "Unspecified" {
            Course.text = recipeIDInfo.course
        } else {
            Course.text = ""
        }
        self.ScrollView.addSubview(LabelinScrollView)
        
        // Do any additional setup after loading the view.
        
        let url = NSURL(string:imageURL)
        let data = NSData(contentsOfURL:url!)
        if data != nil {
            imageofFood.image = UIImage(data:data!)
        }
        
        
        
        self.theData.makePreparations {
            self.returnedPreps = self.theData.returnedPreps
            //            print(self.returnedPreps.count)
            //            print(self.returnedPreps[0].recipeName)
            //            print(self.returnedPreps[0].directions)
            for direction in self.returnedPreps[0].directions {
                self.labeltext += "\(direction) \n"
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.LabelinScrollView.text = self.labeltext
                self.LabelinScrollView.reloadInputViews()
            })
        }
        
        print(recipeIDInfo)
        
        print("MY RECIPES: \(self.returnedPreps.count)")
        
//        self.RecipeName.text = self.returnedPreps[0].recipeName
//        self.Course.text = givenRecipe.course
//        
//        let setOfDirections = self.returnedPreps[0].directions
//        
//        var int: CGFloat = 30
//        for direction in [""] {
//            let label = UILabel(frame: CGRectMake(40, 100, 300, 21))
//            label.text = direction
//            label.textAlignment = NSTextAlignment.Left
//            label.textColor = UIColor.whiteColor()
//            label.center = CGPointMake(182, int)
//            int = int + 30
//            
//            self.directionsScrollView.addSubview(label)
//        }
//        
//        for text in setOfDirections {
//            labeltext += "\(text) /n"
//            LabelinScrollView.text = labeltext
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let foodarray = self.pictureIngredients
        let DestViewController: RecipeDisplayViewController = segue.destinationViewController as! RecipeDisplayViewController
        DestViewController.pictureIngredients = foodarray;
        DestViewController.favoritesArray = self.favoritesArray
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
