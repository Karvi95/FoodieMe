//
//  AddToCalendarViewController.swift
//  ClarifaiApiDemo
//
//  Created by MyungJin Eun on 6/1/16.
//  Copyright © 2016 Clarifai, Inc. All rights reserved.
//


import UIKit
import EventKit

class AddToCalendarViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    //For segueing back to PrepVC
    var givenRecipe: Recipe!
    var pictureIngredients : [String] = []
    var imageURL: String!
    
    // Used to create an event
    var eventTitle : String = ""
    var dateString : String = ""
    var timeString : String = ""
    var calendars : [String] = []   //Names of retrieved calendars
    var calendarRow : Int = 0       //selected row index
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var calendarPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pre-filled text fields for title, date, and time
        //Date and time text fields are disabled and can be changed only through select button
        titleField.text = eventTitle
        dateField.textColor = UIColor.lightGrayColor()
        dateField.userInteractionEnabled = false
        timeField.textColor = UIColor.lightGrayColor()
        timeField.userInteractionEnabled = false
        
        // For calendars pickerview
        self.calendarPicker.dataSource = self
        self.calendarPicker.delegate = self
        
        // Request Access to the calendar on the device and retrieve names of the calendars
        let eventStore = EKEventStore()
        var event: EKEvent = EKEvent(eventStore: eventStore)
        // 2
        switch EKEventStore.authorizationStatusForEntityType(.Event) {
        case .Authorized:
            let calendars = eventStore.calendarsForEntityType(.Event)
                as! [EKCalendar]
            for one in calendars {
                self.calendars.append(one.title)
            }
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(.Event, completion:
                {[weak self] (granted: Bool, error: NSError?) -> Void in
                    if granted {
                        let calendars = eventStore.calendarsForEntityType(.Event)
                            as! [EKCalendar]
                        for one in calendars {
                            self!.calendars.append(one.title)
                        }
                        
                    } else {
                        print("Access denied")
                    }
                })
        default:
            print("Case Default")
        }
    }
    
    //number of columns to show in calendar pickerview
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //number of rows to show in calendar pickerview
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return calendars.count;
    }
    
    //The titles of each row in calendar pickerview
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return calendars[row]
    }
    
    //When the calendar is selected, updates the index of the row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.calendarRow = row
    }
    
    // Pulls up DatePickerDialog to select the Date
    @IBAction func selectDate(sender: AnyObject) {
        DatePickerDialog().show("Select Date", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Date) {
            (date) -> Void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy" //format style. you can change according to yours
            self.dateString = dateFormatter.stringFromDate(date)
            self.dateField.textColor = UIColor.blackColor()
            self.dateField.text = self.dateString
        }
    }
    
    // Pulls up DatePickerDialog to select the time
    @IBAction func selectTime(sender: AnyObject) {
        DatePickerDialog().show("Select Start Time", doneButtonTitle: "Done", cancelButtonTitle: "Cancel", datePickerMode: .Time) {
            (date) -> Void in
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "h:mm a" //format style. you can change according to yours
            self.timeString = dateFormatter.stringFromDate(date)
            self.timeField.textColor = UIColor.blackColor()
            self.timeField.text = self.timeString
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Settings", message: "\(message)", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //
    @IBAction func addEvent(sender: AnyObject) {
        //If not both of date and time are selected, it does not add an event
        guard (dateField.textColor != UIColor.lightGrayColor() && timeField.textColor != UIColor.lightGrayColor()) else {
            showAlert("please specify date and time")
            return
        }
        
        let eventStore = EKEventStore()
        insertEvent(eventStore)
        
        /*let eventStore = EKEventStore()
        var event: EKEvent = EKEvent(eventStore: eventStore)
        // 2
        switch EKEventStore.authorizationStatusForEntityType(.Event) {
        case .Authorized:
            insertEvent(eventStore)
        case .Denied:
            print("Access denied")
        case .NotDetermined:
            // 3
            eventStore.requestAccessToEntityType(.Event, completion:
                {[weak self] (granted: Bool, error: NSError?) -> Void in
                    if granted {
                        self!.insertEvent(eventStore)
                        
                    } else {
                        print("Access denied")
                    }
                })
        default:
            print("Case Default")
        }*/
    }
    
    
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendarsForEntityType(.Event)
            as! [EKCalendar]
        
        //for calendar in calendars {
            // 2
            //if calendar.title == "ioscreator" {
        
        let calendar = calendars[calendarRow]
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        let dateAsString = "\(dateString) \(timeString)"
        let startDate = dateFormatter.dateFromString(dateAsString)!
                
        let endDate = startDate.dateByAddingTimeInterval(1 * 60 * 60)
                
 
                // 4
                // Create Event
                let event = EKEvent(eventStore: store)
                event.calendar = calendar
                
                event.title = titleField.text!
                event.startDate = startDate
                event.endDate = endDate
                
                // 5
                // Save Event in Calendar
                var error: NSError?
                var result: ()
                do {
                    result = try store.saveEvent(event, span: EKSpan.ThisEvent, commit: true)
                } catch {
                    print("it doesn't work")
                }
                
                //if result == false {
                if let theError = error {
                    print("An error occured \(theError)")
                }
                //}
            //}
            
            showAlert("Event successfully added to Calendar")
        //}
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let DestViewController: PreparationViewController = segue.destinationViewController as! PreparationViewController
        DestViewController.givenRecipe = self.givenRecipe
        DestViewController.pictureIngredients = self.pictureIngredients
        DestViewController.imageURL = self.imageURL
    }
    
    
}

