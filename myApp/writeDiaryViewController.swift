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
import CoreData

class writeDiaryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var textToWrite: UITextView!
    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var firstPic: UIImageView!
    @IBOutlet weak var scPic: UIImageView!
    
    var diaryList = NSMutableArray()
    var selectedDate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()
  }
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//
//    }
    
    func read(){
        
        diaryList = NSMutableArray()
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //エンティティを操作するためのオブジェクトを作成
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let query: NSFetchRequest<DIARY> = DIARY.fetchRequest()
        
        do{
            //データを一括取得
            let fetchResults = try viewContext.fetch(query)
            
            //データの取得
            for result: AnyObject in fetchResults{
                
                let title: String? = result.value(forKey: "title") as? String
                
                let saveDate: Date? = result.value(forKey: "saveDate") as? Date
                
                let content: String? = result.value(forKey:"content") as? String
                
                let image1: String? = result.value(forKey: "image1") as? String
                
                let image2: String? = result.value(forKey: "image2") as? String
                
                let date: Date? = result.value(forKey: "date") as? Date
                
                
                //("title:\(title) saveDate:\(saveDate)")
                
                diaryList.add(["title":title, "saveDate":saveDate,"image1":image1,"image2":image2,"date":date,"content":content])
            }
        }catch{

        }

}
    @IBAction func tapToSave(_ sender: UIButton) {
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let diaryObject = NSEntityDescription.entity(forEntityName: "DIARY", in: viewContext)
        
        let newRecord = NSManagedObject(entity: diaryObject!, insertInto: viewContext)
        
        
        //TODO:値の代入を追加する
        newRecord.setValue(myTitle.text, forKey: "title")
        newRecord.setValue(Date(), forKey:"saveDate")
        newRecord.setValue(textToWrite.text, forKey:"content")
        newRecord.setValue(firstPic.image, forKey: "image1")
        newRecord.setValue(scPic.image, forKey: "image2")
        
        do {
            try viewContext.save()
            
            //再読み込み
//            read()
            
        }catch{
        }
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
