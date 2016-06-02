//
//  PreparationViewController.swift
//  FoodieMe
//
//  Created by iGuest on 5/19/16.
//  Copyright © 2016 Info498Team4. All rights reserved.
//

import UIKit

class PreparationViewController: UIViewController, UIAlertViewDelegate {

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
    
    var favorites : [Recipe] = [Recipe]()
    
    var pictureIngredients : [String] = []
    
    var favoritesArray : [favRece] = []
    
    var imageURL: String!
    
    @IBOutlet weak var youtubeButton: UIButton!
    
    @IBAction func FavoriteButton(sender: AnyObject) {
        var checkdup = true
        for savedFav in favoritesArray{
            if savedFav.name == RecipeName.text!{
                checkdup = false
            }
        }
        
        if checkdup {
            let myFav = favRece(name: RecipeName.text!/*, photourl: imageURL, subtitle: Course!.text!*/)
            favoritesArray.append(myFav!)
            print(myFav)
            saveMeals()
        }
        
        displayAlert("Added", message: "This recipe was added to your favorites list!")
    }
    
    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoritesArray, toFile: favRece.ArchiveURL.path!)
        if !isSuccessfulSave {
            print("Failed to save meals...")
        }
    }
    
    func loadMeals() -> [favRece]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(favRece.ArchiveURL.path!) as? [favRece]
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
    /*
    func loadMeals() -> [favoriteRecipe]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(favoriteRecipe.ArchiveURL.path!) as? [favoriteRecipe]
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let savedMeals = loadMeals() {
            favoritesArray += savedMeals
        }
        print(favoritesArray)
        
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
        
        let image1 = UIImage(named: "YouTube-logo-full_color")!
        youtubeButton.setImage(image1, forState: UIControlState.Normal)
        
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
    @IBAction func YoutubeButton(sender: AnyObject) {
        var url = "https://www.youtube.com/results?search_query=how+to+make+"
        let name = recipeIDInfo.recipeName
        let newString = name.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        url = url + newString
        let fileUrl = NSURL(string: url)
        UIApplication.sharedApplication().openURL(fileUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let foodarray = self.pictureIngredients
        let DestViewController: RecipeDisplayViewController = segue.destinationViewController as! RecipeDisplayViewController
        DestViewController.pictureIngredients = foodarray;
        //DestViewController.favoritesArray = self.favoritesArray
    }

    @IBAction func calendarButton(sender: AnyObject) {
        let addToCalendarView = storyboard?.instantiateViewControllerWithIdentifier("addToCalendarView") as! AddToCalendarViewController!
        addToCalendarView.eventTitle = self.RecipeName.text!
        addToCalendarView.givenRecipe = self.givenRecipe
        addToCalendarView.pictureIngredients = self.pictureIngredients
        addToCalendarView.imageURL = self.imageURL
        self.presentViewController(addToCalendarView, animated: true, completion: nil)
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
