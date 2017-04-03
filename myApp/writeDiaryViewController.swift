//
//  writeDiaryViewController.swift
//  myApp
//
//  Created by 有希 on 2017/03/27.
//  Copyright © 2017年 Yuki Mitsudome. All rights reserved.
//

import UIKit
import Photos
import MobileCoreServices

class writeDiaryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var textToWrite: UITextView!
    
    @IBOutlet weak var myTitle: UITextField!
    
    @IBOutlet weak var myDate: UITextField!
    
    @IBOutlet weak var firstPic: UIImageView!
    
    @IBOutlet weak var scPic: UIImageView!
    
    var diaryList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        diaryList = [["title":"title1","date":"2017-03-27","diary":"日記"]]
        
        var myDefault = UserDefaults.standard
        
        if (myDefault.object(forKey:"diaryList") != nil){
            diaryList = NSMutableArray(array: myDefault.object(forKey:"diaryList") as! NSMutableArray)
        }
        print(diaryList)
    }
    
    @IBAction func tapToSave(_ sender: UIButton) {
        
        diaryList.add(["title":myTitle.text,"date":myDate.text,"diary":textToWrite.text])
        
        print(diaryList)
      
        //写真も配列に追加する
        
        var myDefault = UserDefaults.standard
        
        myDefault.set(diaryList, forKey:"diaryList")
        
        myDefault.synchronize()
        
    }
    @IBAction func PickImage(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            let controller = UIImagePickerController()
            
            controller.delegate = self
        
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
          
            controller.allowsEditing = true

            self.present(controller, animated: true, completion: nil)

         }
    }
    @IBAction func tapCamera(_ sender: UIButton) {
        
        let camera = UIImagePickerControllerSourceType.camera
        
        if UIImagePickerController.isSourceTypeAvailable(camera){
            
            let picker = UIImagePickerController()
            
            picker.sourceType = camera
            
            picker.delegate = self
            
            self.present(picker,animated: true)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.firstPic.image = image
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        self.dismiss(animated: true)
        
    }

    
    @IBAction func tapToClose(_ sender: UITextField) {
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
