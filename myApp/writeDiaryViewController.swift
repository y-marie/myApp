//
//  writeDiaryViewController.swift
//  myApp
//
//  Created by 有希 on 2017/03/27.
//  Copyright © 2017年 Yuki Mitsudome. All rights reserved.
//

import UIKit
import Photos
//import MobileCoreServices
import CoreData

class writeDiaryViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate{

    @IBOutlet weak var textToWrite: UITextView!
    @IBOutlet weak var myTitle: UITextField!
    @IBOutlet weak var myDate: UITextField!
    @IBOutlet weak var myDate2: UITextField!
    @IBOutlet weak var firstPic: UIImageView!
    
    var diaryList = NSMutableArray()
    var selectedDate = Date()

    //datePickerが乗るView(下に隠しておく)
    let baseView:UIView = UIView(frame: CGRect(x:0, y:720, width:200, height:250))
    
    let diaryDatePicker:UIDatePicker = UIDatePicker(frame: CGRect(x: 10, y:20, width:300, height:220))
    
    let controller = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        read()
        
        //baseViewにdatePickerを配置
        baseView.addSubview(diaryDatePicker)
        
        //baseViewを下にぴったり配置、横幅ぴったりの大きさにしておく
        baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
        baseView.frame.size = CGSize(width: self.view.frame.size.width, height: baseView.frame.height)
        
        //baseViewに背景色をつける
        baseView.backgroundColor = UIColor.gray
        
        //元の画面に追加
        self.view.addSubview(baseView)
        
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
                
                let date: Date? = result.value(forKey: "date") as? Date
                
               print("title:\(title)","saveDate:\(saveDate)","image1:\(image1)","content:\(content)")
                
                diaryList.add(["title":title, "saveDate":saveDate,"image1":image1,"date":date,"content":content])
            }
        }catch{

        }

}
    @IBAction func tapToSave(_ sender: UIButton) {
        
        
        let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let viewContext = appDelegate.persistentContainer.viewContext
        
        let diaryObject = NSEntityDescription.entity(forEntityName: "DIARY", in: viewContext)
        
        let newRecord = NSManagedObject(entity: diaryObject!, insertInto: viewContext)
        
        let myDefault = UserDefaults.standard
        
        let nikki = myDefault.string(forKey: "selectedPhotoURL")
        
        
        //TODO:値の代入を追加する
        newRecord.setValue(myTitle.text, forKey: "title")
        newRecord.setValue(Date(), forKey:"saveDate")
        newRecord.setValue(textToWrite.text, forKey:"content")
        newRecord.setValue(nikki, forKey: "image1")
        
        //firstPicにデータが入ってなかったら
        if "image2" == nil {
            
            let alertController = UIAlertController(title: "写真を選択", message: "", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
                    } else{
        }

        
        do {
            try viewContext.save()
            
            //再読み込み
//            read()
            
        }catch{
            
            //例外を書く
            //errorの時とか
        }
        
        self.dismiss(animated: true)
        
}
    
    
    @IBAction func PickImage(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            
            //写真ライブラリ(カメラロール)表示用のViewControllerを宣言
            
            controller.delegate = self
            
           //新しく宣言したViewControllerでカメラとカメラロールのどちらを表示するかを指定
            controller.sourceType = UIImagePickerControllerSourceType.photoLibrary
          
            //トリミング
            controller.allowsEditing = true

              //新たに追加したカメラロール表示ViewControllerをpresentViewControllerにする
            self.present(controller, animated: true, completion: nil)

         }
    }
    
    @IBAction func tapCamera(_ sender: UIButton) {
        
        //カメラが使えるかどうか判別するための情報を取得
        let camera = UIImagePickerControllerSourceType.camera
        
        //このアプリが起動されているデバイスにカメラ機能がついてるか判定
        if UIImagePickerController.isSourceTypeAvailable(camera){
            
            //ImgePickerControllerオブジェクトを作成
            let picker = UIImagePickerController()
            
            //カメラタイプに設定
            picker.sourceType = camera
            
            //指示を出すところはViewControllerだと設定
            //デリゲート:委任する、代理人
            picker.delegate = self
            
            //pickerを表示
            self.present(picker,animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //imageに撮影した写真を代入
        //型キャスティング（型変換）
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        self.firstPic.image = image
        
        //  自分のデバイスに（アプリが動いてる場所）に写真を保存
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        //モーダルで表示した写真撮影用の画面を閉じる（前の画面に戻る）
        self.dismiss(animated: true)
        
        let assetURL:AnyObject = info[UIImagePickerControllerReferenceURL]! as AnyObject
        
        let strURL:String = assetURL.description
        
        print(strURL)
        
        let result = PHAsset.fetchAssets(withALAssetURLs: [assetURL as! URL], options: nil)
        
        let asset = result.firstObject
        
        // コンテンツ編集セッションを開始するためのアセットの要求
        asset?.requestContentEditingInput(with: nil, completionHandler: { contentEditingInput, info in
            
            // contentEditingInput = 編集用のアセットに関する情報を提供するコンテナ
            let url = contentEditingInput?.fullSizeImageURL
            
            // 対象アセットのURLからCIImageを生成
            let inputImage = CIImage(contentsOf: url!)!
            
            let gps = inputImage.properties["{GPS}"]
            
            // ユーザーデフォルトを用意
            let myDefault = UserDefaults.standard
            
            // データを書き込んで
            myDefault.set(strURL, forKey: "selectedPhotoURL")
            
            // 即反映
            myDefault.synchronize()
            
            self.controller.dismiss(animated: true)
            
            
        })
        
    }
    
    //テキストフィールド入力開始
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("textFieldShouldBeginEditing")
        
        print(textField.tag)
        
        switch textField.tag{
        
        case 1:
            //タイトルのtextfield
            //キーボードを表示する(通常表示)
            return true
            
        case 2:
            //日付のtextfield
            //baseViewの表示
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                
                self.baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - self.baseView.frame.height)
            
            })
            
        case 3:
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                
          self.baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - self.baseView.frame.height)
               
            })
                
            //キーボードを出さないようにする
            return false
        default:
            return true
            
            }
         return true
        
        }
   
    @IBAction func tapToClose(_ sender: UITextField) {
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
}
