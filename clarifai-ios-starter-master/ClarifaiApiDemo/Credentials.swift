//
//  Credentials.swift
//  ClarifaiApiDemo
//

import Foundation


// IMPORTANT NOTE: you should replace the clarifaiClientID and clarifaiClientSecret values below
// with your own. You can obtain these at https://developer.clarifai.com/applications -- the
// defaults are shared credentials that will stop working once their quota is reached.
// 
// Also, if you're committing your code to a public repo, be careful not to check in your
// credentials -- we're including these here so you can get started out of the box, but this is
// generally a bad practice.
let clarifaiClientID = "RH-XsztwvVaanDz4JEukOQFEi_K15P5SkBzIEk4-"
let clarifaiClientSecret = "pozmLtHYBBJTYQLkpo2DjWXOK0eZfmdPpf0rkrIn"


@objc class Credentials : NSObject {
  class func clientID() -> String { return clarifaiClientID }
  class func clientSecret() -> String { return clarifaiClientSecret }
}
