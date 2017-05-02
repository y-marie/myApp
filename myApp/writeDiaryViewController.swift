//
//  writeDiaryViewController.swift
//  myApp
//
//  Created by 有希 on 2017/03/27.
//  Copyright © 2017年 Yuki Mitsudome. All rights reserved.


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
    @IBOutlet weak var haikei: UIImageView!
    
    var diaryList = NSMutableArray()
    var selectedDate = Date()

    //datePickerが乗るView(下に隠しておく)
    let baseView:UIView = UIView(frame: CGRect(x:0, y:720, width:200, height:250))
    
    let diaryDatePicker:UIDatePicker = UIDatePicker(frame: CGRect(x: 10, y:20, width:300, height:220))
    
    //datePicker隠すためのボタン
    let closeBtnDP:UIButton = UIButton(type: .system)
    
    let controller = UIImagePickerController()
    
    var memoMemo = NSMutableArray()

  override func viewDidLoad() {
        super.viewDidLoad()
   
        read()
    
        //datePickerのmodeを日付のみに設定
        diaryDatePicker.datePickerMode = UIDatePickerMode.date
        
        //datePIckerの日付が選択された時に発動するイベントを追加
        //順番は後
        diaryDatePicker.addTarget(self, action: #selector(showDateSelected(sender:)), for: .valueChanged)
        //#順番を指定できる
        
        //baseViewにdatePickerを配置
        baseView.addSubview(diaryDatePicker)
        
        //closeBtnDPを配置
        //位置、大きさを決定
        closeBtnDP.frame = CGRect(x: self.view.frame.width - 60, y:  0, width:  50, height: 20)
        
        //タイトルの設定
        closeBtnDP.setTitle("閉じる", for: .normal)
        
        //イベントの追加
        //TODO:後ほど
        closeBtnDP.addTarget(self, action: #selector(closeDatePicker(sender:)), for: .touchUpInside)
        
        //baseViewにcloseBtnDPを配置
        baseView.addSubview(closeBtnDP)
        
        //baseViewを下にぴったり配置、横幅ぴったりの大きさにしておく
        baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
        baseView.frame.size = CGSize(width: self.view.frame.size.width, height: baseView.frame.height)
 
        baseView.backgroundColor = UIColor.gray
        
        //元の画面に追加
        self.view.addSubview(baseView)
        
  }
    
    //テキストフィールド入力開始
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        print("textFieldShouldBeginEditing")
        
        print(textField.tag)
        
        myTitle.resignFirstResponder()
        myDate.resignFirstResponder()
        myDate2.resignFirstResponder()
        
        
        switch textField.tag{
            
        case 1:
            //タイトルのtextfield
            //キーボードを表示する(通常表示)
            return true
            
        case 2:
            //日付のtextfield
            //baseViewの表示
            diaryDatePicker.tag = textField.tag
            
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                
                self.baseView.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height - self.baseView.frame.height)
                
            })
            return false
            
        case 3:
            
            diaryDatePicker.tag = textField.tag
            
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
    
    //DatePickerで選択してる日付を変えた時、日付のTextFieldに値を表示
    func showDateSelected(sender:UIDatePicker){
        
        //フォーマットを設定
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        //"yyyy-MM-dd" also ok
        
        //日付を文字列に変換
        let strSelectedDate =  df.string(from: sender.date)
        
        //TextFieldに値を表示
        
        if diaryDatePicker.tag == 2 {
        
             myDate.text = strSelectedDate
            
        }else{
            
             myDate2.text = strSelectedDate
        }
    }
    
    //DatePickerが乗ったviewを隠す
    func closeDatePicker(sender:UIButton){
        UIView.animate(withDuration: 0.5, animations: {()
            -> Void in self.baseView.frame.origin = CGPoint(x: 0, y: self.view.bounds.height)
        })
        
    }

    
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
                let startDate: Date? = result.value(forKey: "startDate") as? Date
                let endDate: Date? = result.value(forKey: "endDate") as? Date
                
               print("title:\(title)","saveDate:\(saveDate)","image1:\(image1)","content:\(content)","startDate:\(startDate)","ednDate:\(endDate)")
                // ,":\()"  for copy
                
                diaryList.add(["title":title, "saveDate":saveDate,"image1":image1,"startDate":startDate,"content":content,"endDate":endDate])
            }
        }catch{
        }
}
    @IBAction func tapToSave(_ sender: UIButton) {
        
        
          let myDefault = UserDefaults.standard
        
        let nikki = myDefault.string(forKey: "selectedPhotoURL")
        
        if nikki == nil {
            
            let alertController = UIAlertController(title: "写真を選択してください", message: "", preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        } else{
            
            let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let viewContext = appDelegate.persistentContainer.viewContext
            
            let diaryObject = NSEntityDescription.entity(forEntityName: "DIARY", in: viewContext)
            
            let newRecord = NSManagedObject(entity: diaryObject!, insertInto: viewContext)
            
            let mystart = DateFormatter()
            mystart.dateFormat = "yyyy/MM/dd"
            
            let myend = DateFormatter()
            myend.dateFormat = "yyyy/MM/dd"
            
            //newRecord.setValue(mystart, forKey: "startDate")
            var dateDate = mystart.date(from: myDate.text!)
            
            var dateDateDate = mystart.date(from: myDate2.text!)
            
            
            //TODO:値の代入を追加する
            newRecord.setValue(myTitle.text, forKey: "title")
            newRecord.setValue(Date(), forKey:"saveDate")
            newRecord.setValue(textToWrite.text, forKey:"content")
            newRecord.setValue(nikki, forKey: "image1")
            newRecord.setValue(dateDate, forKey: "startDate")
            newRecord.setValue(dateDateDate, forKey: "endDate")
            
            //alert
            let alertController = UIAlertController(title: "保存しました", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
           
            present(alertController, animated: true, completion: nil)
            
            do {
                
                try viewContext.save()
                
                myDefault.removeObject(forKey: "selectedPhotoURL")
                
            }catch{
                
                //例外を書く
                //errorの時とか
            }
           // self.dismiss(animated: true)
        }
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
    
//    @IBAction func tapCamera(_ sender: UIButton) {
//        
//        //カメラが使えるかどうか判別するための情報を取得
//        let camera = UIImagePickerControllerSourceType.camera
//        
//        //このアプリが起動されているデバイスにカメラ機能がついてるか判定
//        if UIImagePickerController.isSourceTypeAvailable(camera){
//            
//            //ImgePickerControllerオブジェクトを作成
//            let picker = UIImagePickerController()
//            
//            //カメラタイプに設定
//            picker.sourceType = camera
//            picker.delegate = self
//            
//            //pickerを表示
//            self.present(picker,animated: true)
//        }
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        //imageに撮影した写真を代入
        //型キャスティング（型変換）
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
       
        self.firstPic.layer.cornerRadius = 35
        self.firstPic.layer.masksToBounds = true
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
            
            print(gps)
            
            // ユーザーデフォルトを用意
            let myDefault = UserDefaults.standard
            
            // データを書き込んで
            myDefault.set(strURL, forKey: "selectedPhotoURL")
            
            // 即反映
            myDefault.synchronize()
            
            self.controller.dismiss(animated: true)
            
        })
    }
    
    @IBAction func tapToInsert(_ sender: UIButton) {
        
        //配列を取り出す
        //UserDefaultを用意
        var myDefault = UserDefaults.standard
        
        //名前を指定してデータを取得（配列に代入）
        if (myDefault.object(forKey:"memoMemo") != nil){
            
            textToWrite?.text = myDefault.object(forKey:"memoMemo") as! String
        }
       
    }
    
    @IBAction func tapToClose(_ sender: UITextField) {
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        }
    
     }

