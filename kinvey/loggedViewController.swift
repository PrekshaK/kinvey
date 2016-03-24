//
//  loggedViewController.swift
//  kinvey
//
//  Created by Preksha Koirala on 3/18/16.
//  Copyright © 2016 Preksha Koirala. All rights reserved.
//

import UIKit

class myobject: NSObject{
    var entityId: String?
    var name: String?
    var date: NSDate?
    var photoid: String?
    
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return[
            "entityId": KCSEntityKeyId,
            "name": "name",
            "date": "date",
            "photoid": "photoid"
        ]
    }
    
    
    override class func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return[
            "photo": KCSFileStoreCollectionName
        ]
    }
    
    
    override func referenceKinveyPropertiesOfObjectsToSave() -> [AnyObject]! {
        return["photo"]
    }
    
    
}



class Photo: NSObject{
    
    var PhotoId: String?
    var name: String?
    var date: NSDate?
    var image = UIImage?();
    
    
    
    override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return[
            "PhotoId" : KCSEntityKeyId,
            "name" : "name",
            "date" : "date",
            "image" : "image"

        ]
    }
 }




class loggedViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
 
    
    @IBOutlet weak var mSave: UIButton!
    
    @IBOutlet weak var mlogout: UIButton!
    @IBOutlet weak var mImageView: UIImageView!
    
    @IBOutlet weak var mchooseImage: UIButton!
    
    
    let imagePicker = UIImagePickerController();
    
    override func viewDidLoad() {
        super.viewDidLoad();
        imagePicker.delegate = self;
        self.navigationController?.navigationBarHidden = true;
        
    
        
    }
    
    
    @IBAction func chooseImageAction(sender: AnyObject) {
        let alertController = UIAlertController(title: "Camera Vs PhotoLibrary", message: "Which one do you prefer?", preferredStyle: .Alert)

        
        let CameraButton = UIAlertAction(title: "Camera", style: .Default){(action) in
            
                        self.imagePicker.allowsEditing = false;
                        self.imagePicker.sourceType = .Camera;
                        self.presentViewController(self.imagePicker, animated: true, completion: nil);
            
                    }
        
        alertController.addAction(CameraButton)
        
        
        let PhotoLibraryButton = UIAlertAction(title: "Photo Library", style: .Default){(action) in
            
                        self.imagePicker.allowsEditing = false;
                        self.imagePicker.sourceType = .PhotoLibrary;
                        self.presentViewController(self.imagePicker, animated: true, completion: nil);
            
        }
        
        alertController.addAction(PhotoLibraryButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)
 
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            mImageView.contentMode = .ScaleAspectFill;
            mImageView.image = pickedImage;

        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func saveAction(sender: AnyObject) {

       //savePhoto();
        saveImage();
        
        //saveObject();
    }
    
    
    func saveImage(){
        
        
        let store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "myobject",
            KCSStoreKeyCollectionTemplateClass : myobject.self
            ])
        
        let data = UIImageJPEGRepresentation(mImageView.image!, 0.9)
        KCSFileStore.uploadData(data, options: nil, completionBlock: {(uploadInfo: KCSFile!, error: NSError!) -> Void in
                print ("hello")
            print("file id is\(uploadInfo.fileId)");
           
            
            let mobject = myobject()
            mobject.name = "new objects"
            mobject.date = NSDate(timeIntervalSince1970: 1352149171) //sample date
            mobject.photoid = uploadInfo.fileId;
            store.saveObject(
                mobject,
                withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
                    if errorOrNil != nil {
                        //save failed
                        NSLog("Save failed, with error: %@", errorOrNil.localizedFailureReason!)
                    } else {
                        //save was successful
                        NSLog("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
                    }
                },
                withProgressBlock: nil
            )
            
            
            
            
            
            }, progressBlock: nil)
        
        
      
        

        
        
    }
    

    
//
//    func saveObject()
//    {
//        let store = KCSAppdataStore.storeWithOptions([
//            KCSStoreKeyCollectionName : "myobject",
//            KCSStoreKeyCollectionTemplateClass : myobject.self
//            ])
//        
//        let mobject = myobject()
//        mobject.name = "new objects"
//        mobject.date = NSDate(timeIntervalSince1970: 1352149171) //sample date
//        mobject.photo = mImageView.image
//        store.saveObject(
//            mobject,
//            withCompletionBlock: { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
//                if errorOrNil != nil {
//                    //save failed
//                    NSLog("Save failed, with error: %@", errorOrNil.localizedFailureReason!)
//                } else {
//                    //save was successful
//                    NSLog("Successfully saved event (id='%@').", (objectsOrNil[0] as! NSObject).kinveyObjectId())
//                }
//            },
//            withProgressBlock: nil
//        )
//        
//        
//    }
    
    
    
    
    
    
    
    func savePhoto(){
        let store = KCSAppdataStore.storeWithOptions([KCSStoreKeyCollectionName: "Photos",
            KCSStoreKeyCollectionTemplateClass: Photo.self  ])
        
        let photo = Photo();
        photo.name = "My photo"
        photo.date = NSDate(timeIntervalSince1970: 1352149171)
        photo.image = mImageView.image;
        store.saveObject(
            photo,
            withCompletionBlock: {(objectsOrNil: [AnyObject]!, errorOrNil: NSError!) ->
               Void in
               if errorOrNil != nil{
                
               }else{
                
               }
            },
        
            withProgressBlock: nil
        )
        
    }
    
    
   
 
    
    
    @IBAction func logoutAction(sender: AnyObject) {
        
//        KCSUser.activeUser().removeWithCompletionBlock { (objectsOrNil: [AnyObject]!, errorOrNil: NSError!) -> Void in
//            if errorOrNil != nil {
//                NSLog("error %@ when deleting active user", errorOrNil)
//            } else {
//                NSLog("active user deleted")
//                self.performSegueWithIdentifier("logoutsegue", sender: self);
//                
//            }
//        }
        
        
        
        KCSUser.activeUser().logout();
        NSLog("active user deleted")
                        self.performSegueWithIdentifier("logoutsegue", sender: self);
        
    }
    
    
    
    
    
    

}