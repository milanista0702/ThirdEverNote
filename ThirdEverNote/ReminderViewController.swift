//
//  ReminderViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2016/02/23.
//  Copyright © 2016年 makka misako. All rights reserved.
//

import UIKit
import NCMB

class ReminderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
   @IBOutlet var table: UITableView!
   @IBOutlet var reminderTextField: UITextField!
   @IBOutlet var toolbar: UIToolbar!
   
   var remindArray = [ToDoes]()
   var remindimageArray = [String]()
   var addBtn: UIBarButtonItem!
   let refreshControl = UIRefreshControl()
   
   //userdefaults(倉庫)にアクセス
   let saveData: UserDefaults = UserDefaults.standard
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      toolbar.barTintColor = ColorManager.gray
      toolbar.tintColor = UIColor.white
      
      self.table.estimatedRowHeight = 90
      self.table.rowHeight = UITableViewAutomaticDimension
      
      table.register(UINib(nibName: "TodoTableCell", bundle: nil), forCellReuseIdentifier: "TodoTableCell")
      
      
      let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: Selector("rowButtonAction:"))
      longPressRecognizer.allowableMovement = 15
      longPressRecognizer.minimumPressDuration = 0.6
      self.table.addGestureRecognizer(longPressRecognizer)
      
      
      //tableviewのdatasourcemesodはviewcontrollerクラスに書く設定
      table.dataSource = self
      
      //UITableViewが持っているDelegatmesodの処理の委託先をViewController.swiftにする
      table.delegate = self
      let swipeRightGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeRight(gesture:)))
      swipeRightGesture.numberOfTouchesRequired = 1
      swipeRightGesture.direction = UISwipeGestureRecognizerDirection.right
      self.view.isUserInteractionEnabled = true
      self.view.addGestureRecognizer(swipeRightGesture)
      
      refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
      refreshControl.addTarget(self, action: #selector(ReminderViewController.refresh), for: UIControlEvents.valueChanged)
      table.addSubview(refreshControl)
      
      //navigationvar にeditボタンをつける
      navigationItem.leftBarButtonItem = editButtonItem
      
      
      //addボタン
      addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onClick(sender:)))
      
      self.navigationItem.rightBarButtonItem = addBtn
      
      self.navigationItem.title = "TODO LIST"
      
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      print("a")
      loadData()
      
   }
   
   func loadData() {
      ToDoes.loadall(callback: {objects in
         self.remindArray = []
         for object in objects {
            self.remindArray.append(object)
         }
         self.table.reloadData()
      })
   }
   
   func refresh() {
      loadData()
      refreshControl.endRefreshing()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   
   //editが押された時の処理
   override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)
      table.isEditing = editing
   }
   
   
   
   //cellの数を設定
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return remindArray.count
      //これからReminderArrayを作ったら　ReminderArray.count か　それ+1
   }
   
   
   //ID付きのcellを取得してそれに付属しているlabelとかimageとか
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableCell") as! TodoTableCell
      cell.todolabel.text = remindArray[indexPath.row].todo
      cell.datelabel.text = formatter(date: remindArray[indexPath.row].date)
      if remindArray[indexPath.row].done == true {
         cell.arrowImageView.image = UIImage(named: "Check.png")
      }else{
         cell.arrowImageView.image = UIImage(named: "矢印.png")
      }
      
      return cell
   }
   
   func formatter (date: NSDate) -> String {
      let dateFormatter  = DateFormatter()
      dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
      dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
      
      return dateFormatter.string(from: date as Date)
   }
   
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)  {
      NSLog("%@が選択された", remindArray[indexPath.row])
      let cell = tableView.cellForRow(at: indexPath) as! TodoTableCell
      //キャストしてる？
      
      remindArray[indexPath.row].done = true
      if remindArray[indexPath.row].done == true {
         cell.arrowImageView.image = UIImage(named: "Check.png")
      }else{
         cell.arrowImageView.image = UIImage(named: "矢印.png")
      }
   }
   
   
   //削除可能なcellのindexpath取得(今は全て)
   func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      
      self.delegateObjec(indexPath: indexPath as NSIndexPath)
      
      // 先にデータを更新する
      remindArray.remove(at: indexPath.row)
      
      // それからテーブルの更新
      table.deleteRows(at: [NSIndexPath(row: indexPath.row, section: 0) as IndexPath],
                       with: UITableViewRowAnimation.fade)
   }
   
   
   //cellの並べ替え
   
   func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      let targetTitle = remindArray[sourceIndexPath.row]
      if let index = remindArray.index(of: targetTitle) {
         remindArray.remove(at: index)
         remindArray.insert(targetTitle, at: destinationIndexPath.row)
      }
   }
   
   
   //編集中以外にcellを左スワイプできない
   func tableView(_ table: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
      if table.isEditing {
         return UITableViewCellEditingStyle.delete
      } else {
         return UITableViewCellEditingStyle.none
      }
      
      //編集中にもcellを選択できる
      table.allowsSelectionDuringEditing = true
      table.cellForRow(at: indexPath)?.textInputMode
   }
   
   func delegateObjec(indexPath: NSIndexPath) {
      let object = remindArray[indexPath.row]
      object.deleteEventually { (error) in
         if error != nil {
            print(error?.localizedDescription)
         }
      }
   }
   
   
   func handleSwipeRight(gesture: UIGestureRecognizer) {
      print("右にスワイプされました")
      self.navigationController?.popViewController(animated: true)
   }
   
   
   func rowButtonAction(sender : UILongPressGestureRecognizer) {
      
      let point: CGPoint = sender.location(in: table)
      let indexPath = table.indexPathForRow(at: point)
      
      print("a")
      
      if let indexPath = indexPath {
         if sender.state == UIGestureRecognizerState.began {
            
            // セルが長押しされたときの処理
            print("long pressed \(indexPath.row)")
         }
      }else{
         print("long press on table view")
      }
   }
   
   
   //appボタンが押された時 → onClickが呼ばれる
   func onClick(sender: AnyObject) {
      self.performSegue(withIdentifier: "addsegue", sender: nil)
   }
   
   func dismiss(segue: UIStoryboardSegue) {
      self.dismiss(animated: true, completion: nil)
   }
   
}
