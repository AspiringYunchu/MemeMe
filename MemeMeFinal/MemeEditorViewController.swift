//
//  MemeEditorViewController.swift
//  ImagePicker
//
//  Created by yunchu on 6/30/15.
//  Copyright (c) 2015 AmerPe Studio. All rights reserved.
//

import UIKit
import Foundation

class MemeEditorViewController:UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {

    //Storyboard outlets in Meme Edit View
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var album: UIBarButtonItem!
    @IBOutlet weak var picker2: UIToolbar!
    @IBOutlet weak var camera: UIBarButtonItem!
    @IBOutlet weak var toolbarTop: UIToolbar!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    
    //properties for storing memed images
    var memedImage : UIImage!
    let imagePicker = UIImagePickerController()
    
    //meme text attribute
    let memeTextAttributes = [
        
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -4.0
        
    ]
    
    @IBAction func pickImageFromAlbum(sender: AnyObject) {
        
        //action to pick image from album
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickImageFromCamera(sender: AnyObject) {
        
        //action to pick image from camera
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        //set image picker's delegate, test device camera, set meme text format
        super.viewDidLoad()
        imagePicker.delegate = self
        camera.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        textTop.text = "TOP"
        textBottom.text = "BOTTOM"
        applyStyleToText(textTop)
        applyStyleToText(textBottom)
        
        //set edit view navigation bar items
        navigationItem.rightBarButtonItem = UIBarButtonItem (
            title: "Cancel",
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "startOver")
        
        navigationItem.setLeftBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "share"), animated: true)
        navigationItem.leftBarButtonItem?.enabled = false
    }
    
    func startOver() {
        
        //action method implementation for cancel button
        if let navigationController = self.navigationController {
            navigationController.popToRootViewControllerAnimated(true)
            self.imageView.image = nil
            textTop.text = "TOP"
            textBottom.text = "BOTTOM"
            self.tabBarController?.tabBar.hidden = false
        }
    }
    
    func share() {
        
        // action method implementation for share meme including generating memed image, launch activity view and returning to sent memes views
        memedImage = generateMemedImage()
        let memedImageArrayForm = [generateMemedImage()]
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: memedImageArrayForm, applicationActivities: nil)
        navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
        
        activityViewController.completionWithItemsHandler = {
            (s: String!, ok: Bool, items: [AnyObject]!, err:NSError!) -> Void in
            self.save()
            self.navigationController?.popToRootViewControllerAnimated(true)
            self.tabBarController?.tabBar.hidden = false
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        //subscribe to keyboard notification
        super.viewWillAppear(animated)
        if imageView.image != nil {
            
            navigationItem.leftBarButtonItem?.enabled = true
        } else {
            navigationItem.leftBarButtonItem?.enabled = false
        }
        subscribeToKeyboardNotifications()
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //unsubscribe from keyboard when view is to disappear
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        
        //add edit view controller to observers of keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:"    , name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        //remove edit view from observer list
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        //adjust screen up by keyboard height
        if textBottom.isFirstResponder() {
           view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
        //move screen down by keyboard height
        if textBottom.isFirstResponder() {
            view.frame.origin.y = 0
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        
        //get keyboard height
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
   
    
    func save() {
        
        //Create the meme
        var meme = Meme( textTop: textTop.text, textBottom: textBottom.text, image:
            imageView.image!, memedImage: generateMemedImage())
        AppDelegate.memes.append(meme)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        //format and capitalize all characters
        textField.typingAttributes = memeTextAttributes
        var oldText = textField.text as NSString
        var newText = oldText.stringByReplacingCharactersInRange(range, withString: string)
        var newTextString = String(newText).uppercaseString
        textField.text = newTextString
        return false
    }
    
    func imagePickerController(_picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
            
            // store picked image
            dismissViewControllerAnimated(true, completion: nil)
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                imageView.autoresizingMask = UIViewAutoresizing.FlexibleBottomMargin | UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin | UIViewAutoresizing.FlexibleWidth
                imageView.contentMode = UIViewContentMode.ScaleAspectFit
                imageView.image = pickedImage
            }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
         //dismiss view controller
         dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar, change background to white
        navigationController?.navigationBarHidden = true
        toolbarTop.hidden = true
        picker2.hidden = true
        view.backgroundColor = UIColor.whiteColor()
        // Render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let memedImage : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar,change background to black
        navigationController?.navigationBarHidden = false
        toolbarTop.hidden = false
        picker2.hidden = false
        view.backgroundColor = UIColor.blackColor()
        return memedImage
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        //clear default text upon tapping
        if textField == textTop && textTop.text == "TOP" || textField == textBottom && textBottom.text == "BOTTOM" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        //restore default text if empty
        if textField == textTop && textField.text == "" {
            textField.text = "TOP"
        } else if textField == textBottom && textField.text == "" {
            textField.text = "BOTTOM"
        }
        textTop.defaultTextAttributes = memeTextAttributes
        textBottom.defaultTextAttributes = memeTextAttributes
        textTop.textAlignment = .Center
        textBottom.textAlignment = .Center
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        // dismiss keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func applyStyleToText(textField: UITextField) {
       
        // format textfield
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .Center
    }
}

