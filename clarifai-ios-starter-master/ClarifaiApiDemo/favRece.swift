//
//  Recipe.swift
//  favorites
//
//  Created by Brittney Hoy on 5/29/16.
//  Copyright © 2016 Brittney Hoy. All rights reserved.
//

import UIKit


//This is where we grab the recipe NAME from the listing
//In charge of storing and loading the name by assigning the value of each property to a particular key
class favRece: NSObject, NSCoding {
    
    var name: String //Pretty much all we're "saving" to favorites?
    //Add anymore variables depending on what we want to save (persist)
//    var subtitle: String
//    var photourl: String
    
    //This is the file path to the data
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    
    //Outside of the Recipe class, we'll access the recipes by using Recipe.ArchiveURL.path!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("recipes")
    
    //Storage
    struct PropertyKey {
        static let nameKey = "name"
//        static let photoKey = "photo"
//        static let ratingKey = "rating"
    }
    
    
    //Initialization
    init?(name: String/*, photourl: String, subtitle: String*/) {
        // Initialize stored properties.
        self.name = name
//        self.photourl = photourl
//        self.subtitle = subtitle
        
        super.init()
    }
    
    //NSCoding properties
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
//        aCoder.encodeObject(photourl, forKey: PropertyKey.photoKey)
//        aCoder.encodeObject(subtitle, forKey: PropertyKey.ratingKey)
    }
    
    //Implements the initializer to load the list of recipes
    required convenience init?(coder aDecoder: NSCoder) {
        
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Because photo is an optional property of Meal, use conditional cast.
//        let photourl = aDecoder.decodeObjectForKey(PropertyKey.photoKey) as! String
//        
//        let subtitle = aDecoder.decodeObjectForKey(PropertyKey.ratingKey) as! String
        
        self.init(name: name/*, photourl: photourl, subtitle: subtitle*/)
        
    }
}
