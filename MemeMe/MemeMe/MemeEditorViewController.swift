//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Brian Ortega on 3/18/15.
//  Copyright (c) 2015 Brian Ortega. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraPickerButton: UIBarButtonItem!
    @IBOutlet weak var albumPickerButton: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var pickerController = UIImagePickerController()
    var bottomTextFieldEditing = false // this will determine when to push view up when keyboard appears
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets up picker controller for button to source picture from camera
        pickerController.delegate = self
        pickerController.allowsEditing = true
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            cameraPickerButton.enabled = false
        }
        self.shareMemeButton.enabled = false
        
        // Handles additional styling for meme top and bottom text fields
        let memeTextAttributes = [
            NSStrokeColorAttributeName: UIColor.blackColor(),
            NSForegroundColorAttributeName: UIColor.whiteColor(),
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -5.0,
        ]
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.attributedPlaceholder = NSAttributedString(string: "TOP", attributes: memeTextAttributes)
        bottomTextField.attributedPlaceholder = NSAttributedString(string: "BOTTOM", attributes: memeTextAttributes)
        
        // Ensures cancel button does not segue to Sent Memes unless there are any
        if (UIApplication.sharedApplication().delegate as AppDelegate).memes.isEmpty {
            cancelButton.enabled = false
        }
    }
    
    // Image picker code
    @IBAction func pickImageFromCamera(sender: UIBarButtonItem) {
        pickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(pickerController, animated: true, completion: nil)
        self.shareMemeButton.enabled = true
    }
    
    @IBAction func pickImageFromAlbum(sender: UIBarButtonItem) {
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
        self.shareMemeButton.enabled = true
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        } else {
            println("Problem picking an image")
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Text field and keyboard code
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.bottomTextField {
            bottomTextFieldEditing = true
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.bottomTextField {
            bottomTextFieldEditing = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextFieldEditing {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextFieldEditing {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return keyboardSize.CGRectValue().height
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Meme generation code
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        if let image = imageView.image {
            let memedImage = self.generateMemedImage()
            let activityController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            activityController.completionWithItemsHandler =  {
                (String, Bool, [AnyObject]!, NSError) in
                self.saveMeme()
                self.performSegueWithIdentifier("SentMemeSegue", sender: self)
            }
            self.presentViewController(activityController, animated: true, completion: nil)
        }
    }
    
    func saveMeme() {
        var meme = Meme(topText: topTextField.text, bottomText: bottomTextField.text, image: imageView.image!, memedImage: self.generateMemedImage())
        (UIApplication.sharedApplication().delegate as AppDelegate).memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // Need to hide top and bottom bars when capturing image for meme
        self.navigationController?.navigationBar.hidden = true
        self.toolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.navigationController?.navigationBar.hidden = false
        self.toolBar.hidden = false
        
        return memedImage
    }
}
