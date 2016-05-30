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
    
    
    var labeltext = ""
    
    var givenRecipe: Recipe!
    
    var returnedPreps : [Preparation] = [Preparation]()
    
    var inFavorite = false
    var favorites : [Recipe] = [Recipe]()
    
    var pictureIngredients : [String] = []
    
    @IBAction func FavoriteButton(sender: AnyObject) {
        inFavorite = !inFavorite
        if(inFavorite) {
            
        }
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
        
        self.theData.makePreparations {
            self.returnedPreps = self.theData.returnedPreps
            //            print(self.returnedPreps.count)
            //            print(self.returnedPreps[0].recipeName)
            //            print(self.returnedPreps[0].directions)
            for direction in self.returnedPreps[0].directions {
                self.labeltext += "\(direction) /n"
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
