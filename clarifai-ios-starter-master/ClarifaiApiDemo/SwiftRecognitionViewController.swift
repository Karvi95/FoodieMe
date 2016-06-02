
//
//  SwiftRecognitionViewController.swift
//  ClarifaiApiDemo
//

import UIKit
import Foundation

/**
 * This view controller performs recognition using the Clarifai API.
 */
class SwiftRecognitionViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!

    var favoritesArray : [Recipe] = []
    
    private lazy var client : ClarifaiClient = ClarifaiClient(appID: clarifaiClientID, appSecret: clarifaiClientSecret)

    @IBAction func buttonPressed(sender: AnyObject) {
        // Show a UIImagePickerController to let the user pick an image from their library.
        let picker = UIImagePickerController()
        picker.sourceType = .Camera
        picker.allowsEditing = false
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "LaunchImages.png")!)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            // The user picked an image. Send it to Clarifai for recognition.
            imageView.image = image
            textView.text = "Recognizing..."
            cameraButton.enabled = false
            recognizeImage(image)
        }
    }

    private func recognizeImage(image: UIImage!) {
        // Scale down the image. This step is optional. However, sending large images over the
        // network is slow and does not significantly improve recognition performance.
        let size = CGSizeMake(320, 320 * image.size.height / image.size.width)
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let foodlist : [String] = ["banana", "apple", "orange", "pepper", "avocado", "lemon", "ham", "salmon", "pork", "chicken", "egg", "milk", "tomato", "noodles", "cheddar", "broccoli", "cabbage", "cucumber", "carrot", "garlic"]
        var foodfound : [String] = []
        // Encode as a JPEG.
        let jpeg = UIImageJPEGRepresentation(scaledImage, 0.9)!

        // Send the JPEG to Clarifai for standard image tagging.
        client.recognizeJpegs([jpeg]) {
            (results: [ClarifaiResult]?, error: NSError?) in
            if error != nil {
                print("Error: \(error)\n")
                self.textView.text = "Sorry, there was an error recognizing your image."
            } else {
                for n in results![0].tags{
                    if foodlist.contains(n){
                        foodfound.append(n)
                    }
                }
                self.textView.text = foodfound.joinWithSeparator(", ")
            }
            self.cameraButton.enabled = true
        }
    }
    
    @IBAction func clicktype(sender: AnyObject) {
        //let storyBoard : UIStoryboard = UIStoryboard(name:"Main", bundle:nil)
        
        let textBoxView = storyboard?.instantiateViewControllerWithIdentifier("textBoxView") as! TextboxViewController!
        textBoxView.favoritesArray = self.favoritesArray
        self.presentViewController(textBoxView, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let foodList = self.textView.text.lowercaseString
        
        print("SHOULD BE LOWERCASE: \(foodList)")
        
        let foodarray = foodList.componentsSeparatedByString(" ")
        let DestViewController: RecipeDisplayViewController = segue.destinationViewController as! RecipeDisplayViewController
        DestViewController.pictureIngredients = foodarray;
        DestViewController.favoritesArray = self.favoritesArray
    }
    
    @IBAction func clickFavorites(sender: AnyObject) {
        let favView = storyboard?.instantiateViewControllerWithIdentifier("FavDisplayView") as! FavDisplayViewController!
        //favView.favoritesArray = self.favoritesArray
        self.presentViewController(favView, animated: true, completion: nil)
    
    }
    
}
