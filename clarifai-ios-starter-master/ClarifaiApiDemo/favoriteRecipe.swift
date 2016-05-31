//
//  favoriteRecipe.swift
//  ClarifaiApiDemo
//
//  Created by iGuest on 5/30/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//

import UIKit

class favoriteRecipe: NSObject, NSCoding {
    var name: String
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("recipes")
    
    // MARK: Types
    
    struct PropertyKey {
        static let nameKey = "name"
    }
    
    // MARK: Initialization
    
    init?(name: String) {
        // Initialize stored properties.
        self.name = name

        super.init()

    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        
        // Must call designated initializer.
        self.init(name: name)
    }
    
    
}
