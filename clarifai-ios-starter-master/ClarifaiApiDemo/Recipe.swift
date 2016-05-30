//
//  Recipe.swift
//  FoodieMe
//
//  Created by iGuest on 5/17/16.
//  Copyright © 2016 Info498Team4. All rights reserved.
//

import Foundation

public class Recipe {
    public var recipeNameToIdDict : [String : String]
    public var course : String
    public var ingredients : [String]
    public var imageURL: String
    
    
    init(recipeNameToIdDict : [String : String], course : String, ingredients : [String], imageURL: String){
        self.recipeNameToIdDict = recipeNameToIdDict
        self.course = course
        self.ingredients = ingredients
        self.imageURL =  imageURL
    }
}