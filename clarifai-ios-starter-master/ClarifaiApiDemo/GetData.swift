//
//  GetData.swift
//  FoodieMe
//
//  Created by iGuest on 5/16/16.
//  Copyright © 2016 Info498Team4. All rights reserved.
//


import UIKit


class GetData {
    
    var recipeNamesToIds : [[String : String]] = []
    var courses : [String] = []
    var images : [String] = []
    
    var returnedRecipes : [Recipe] = [Recipe]()
    
    var returnedPreps : [Preparation] = [Preparation]()
    
    let recipeInfoURLBegining : String = "http://api.yummly.com/v1/api/recipe/"
    let recipeInfoURLEnding : String = "?_app_id=727f9e61&_app_key=6432cf347203b199cad6e4ccd21ba822"
    
    func makeString() -> String {
        var stringToSend = ""
        stringToSend += ("&allowedIngredient[]=" + recipeIDInfo.pictureIngredients[0])
        for i in 1 ..< recipeIDInfo.pictureIngredients.count {
            stringToSend += ("&allowedIngredient[]=" + recipeIDInfo.pictureIngredients[i])
        }
        return stringToSend
    }
    
    func searchRecipes(completionHandler: () -> Void) {
        let foodList = makeString()
        let searchURL : String = "http://api.yummly.com/v1/api/recipes?_app_id=727f9e61&_app_key=6432cf347203b199cad6e4ccd21ba822&q=" + foodList
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: searchURL)!) { (data, response, error) -> Void in
            let HTTPResponse = response as! NSHTTPURLResponse
            let statusCode = HTTPResponse.statusCode
            
            if (statusCode == 200) {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    
                    guard let matches = json["matches"] as? [[String : AnyObject]] else {return}
                    
                    for match in matches {
                        guard let recipeName = match["recipeName"] as? String else {return}
                        guard let identifier = match["id"] as? String else {return}
                        
                        var recipeNameToIdDict : [String : String] = [:]
                        recipeNameToIdDict[recipeName] = identifier
                        self.recipeNamesToIds.append(recipeNameToIdDict)
                        
                        var courseTemp = "Unspecified"
                        if let attribute = match["attributes"] as? [String:[String]] {
                            if attribute["course"] != nil {
                                if attribute["course"]!.count == 1 {
                                    courseTemp = attribute["course"]![0]
                                }
                            }
                        }
                        self.courses.append(courseTemp)
                        
                        var imageURL = ""
                        guard let images = match["smallImageUrls"] as? [String] else {return}
                        for i in images {
                            imageURL = i
                        }
                        self.images.append(imageURL)
                        
                        guard let ingredients = match["ingredients"] as? [String]  else {return}
                        
                        self.returnedRecipes.append(Recipe(recipeNameToIdDict: recipeNameToIdDict, course: courseTemp, ingredients: ingredients, imageURL: imageURL))
                    }
                    
                    completionHandler()
                    
                }  catch {
                    print("Error Response in searching recipies \n\(error)")
                }
            }
        }
        
        task.resume()
    }
    
    func makePreparations(completionHandler: () -> Void) {
//        var aPreparation : Preparation = Preparation(recipeName: "dummy", directions: [])
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: self.recipeInfoURLBegining + recipeIDInfo.recipeID + self.recipeInfoURLEnding)!) { (data, response, error) -> Void in
            
            let HTTPResponse = response as! NSHTTPURLResponse
            let statusCode = HTTPResponse.statusCode
            
            if (statusCode == 200) {
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: [])
                    
                    guard let directions = json["ingredientLines"] as? [String] else {return}
                    
                    recipeIDInfo.directions = directions
                    
                    let aPreparation = Preparation(recipeName: recipeIDInfo.recipeName, directions: directions)
                    
                    // We can grab flavors, nutritional info and images here
                    let imageURLs = json["images"] as! [[String: AnyObject]]
                    let imageUrlsBySize = imageURLs[0]["imageUrlsBySize"]
                    
                    if let imageUrlsBySize = imageUrlsBySize {
                        aPreparation.imageUrl = imageUrlsBySize["360"] as? String
                    }
                
                    self.returnedPreps.append(aPreparation)
                    
                    completionHandler()
                    
                }  catch {
                    print("Error Response in getting recipie info! \n\(error)")
                }
            }
        }
        task.resume()
    }
    
}