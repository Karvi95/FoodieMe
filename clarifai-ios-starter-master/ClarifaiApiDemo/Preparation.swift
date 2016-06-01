//
//  Preparation.swift
//  FoodieMe
//
//  Created by iGuest on 5/17/16.
//  Copyright © 2016 Info498Team4. All rights reserved.
//

import Foundation

public class Preparation {
    public var recipeName : String
    var imageUrl: String? = nil
    public var directions : [String]
    
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("meals")
    
    init(recipeName : String, directions : [String]){
        self.recipeName = recipeName
        self.directions = directions
    }
}