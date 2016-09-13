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
    
    var remindArray = [ToDoes]()
    var remindimageArray = [String]()
    var addBtn: UIBarButtonItem!
    let refreshControl = UIRefreshControl()
    
    
    //userdefaults(倉庫)にアクセス
    let saveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "rowButtonAction:")
        longPressRecognizer.allowableMovement = 15
        longPressRecognizer.minimumPressDuration = 0.6
        self.table.addGestureRecognizer(longPressRecognizer)
        
        
        //tableviewのdatasourcemesodはviewcontrollerクラスに書く設定
        table.dataSource = self
        
        //UITableViewが持っているDelegatmesodの処理の委託先をViewController.swiftにする
        table.delegate = self
        
        // Do any additional setup after loading the view.
        
        let swipeRightGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ReminderViewController.handleSwipeRight(_:)))
        swipeRightGesture.numberOfTouchesRequired = 1
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(swipeRightGesture)
        
        refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        refreshControl.addTarget(self, action: #selector(ReminderViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        table.addSubview(refreshControl)
        
        //navigationvar にeditボタンをつける
        navigationItem.leftBarButtonItem = editButtonItem()
        
        //addボタン
        addBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(ReminderViewController.handleSwipeRight(_:)))
        
        self.navigationItem.rightBarButtonItem = addBtn
        
        
        self.navigationItem.title = "やることリスト"
        
        
        //        remindArray = saveData.objectForKey("ToDoList")
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        print("a")
        loadData()
        
    }
    
    func loadData() {
        ToDoes.loadall({objects in
            self.remindArray.removeAll()
            
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
        // Dispose of any resources that can be recreated.
    }
    
    
    //editが押された時の処理
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.editing = editing
    }
    
    
    
    //cellの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return remindArray.count
        //これからReminderArrayを作ったら　ReminderArray.count か　それ+1
    }
    
    
    //ID付きのcellを取得してそれに付属しているlabelとかimageとか
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel!.text = remindArray[indexPath.row].todo
        cell.imageView!.image = UIImage(named: "矢印.png")
        cell.imageView!.frame.size = CGSize(width: 10,height: 10)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        NSLog("%@が選択された", remindArray[indexPath.row])
        
        if table.cellForRowAtIndexPath(indexPath)?.imageView!.image == UIImage(named:"check.png") {
            table.cellForRowAtIndexPath(indexPath)?.imageView!.image = UIImage(named:"矢印.png")
            
        } else {
            table.cellForRowAtIndexPath(indexPath)?.imageView!.image = UIImage(named:"check.png")
        }
    }
    
    
    //削除可能なcellのindexpath取得(今は全て)
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //削除された時の実装
    func tableView(table: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        self.delegateObjec(indexPath)
        
        // 先にデータを更新する
        remindArray.removeAtIndex(indexPath.row)
        
        // それからテーブルの更新
        table.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
                                     withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    
    //cellの並べ替え
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(table: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let targetTitle = remindArray[sourceIndexPath.row]
        if let index = remindArray.indexOf(targetTitle) {
            remindArray.removeAtIndex(index)
            remindArray.insert(targetTitle, atIndex: destinationIndexPath.row)
        }
    }
    
    
    //編集中以外にcellを左スワイプできない
    func tableView(table: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if table.editing {
            return UITableViewCellEditingStyle.Delete
        } else {
            return UITableViewCellEditingStyle.None
        }
        
        //編集中にもcellを選択できる
        table.allowsSelectionDuringEditing = true
        table.cellForRowAtIndexPath(indexPath)?.textInputMode
    }
    
    func delegateObjec(indexPath: NSIndexPath) {
        let object = remindArray[indexPath.row]
        object.deleteEventually { (error) in
            if error != nil {
                print(error.localizedDescription)
            }
        }
    }
    
    
    func handleSwipeRight(gesture: UIGestureRecognizer) {
        print("右にスワイプされました")
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    
    func rowButtonAction(sender : UILongPressGestureRecognizer) {
        
        let point: CGPoint = sender.locationInView(table)
        let indexPath = table.indexPathForRowAtPoint(point)
        
        print("a")
        
        if let indexPath = indexPath {
            if sender.state == UIGestureRecognizerState.Began {
                
                // セルが長押しされたときの処理
                print("long pressed \(indexPath.row)")
            }
        }else{
            print("long press on table view")
        }
    }
    
    
    //appボタンが押された時 → onClickが呼ばれる → tapが呼ばれる
    func onClick(sender: AnyObject) {
        self.performSegueWithIdentifier("addsegue", sender: nil)
    }
    
    func dismiss(segue: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}


//    func tap() {
//
//        var alert = UIAlertController(title: "NEW REMINDER", message: "やること追加", preferredStyle: .Alert)
//        let saveAction = UIAlertAction(title: "Done", style: .Default) { (action:UIAlertAction!) -> Void in
//
//            // 入力したテキストをコンソールに表示
//            let textField = alert.textFields![0] as UITextField
//            //            self.label.text = textField.text
//            self.remindArray.append(textField.text!)
//            self.table.reloadData()
//
//            self.saveData.setObject(self.remindArray, forKey: "ToDoList")
//        }
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action:UIAlertAction!) -> Void in
//       }

// UIAlertControllerにtextFieldを追加
//        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
//        }
//
//        alert.addAction(cancelAction)
//        alert.addAction(saveAction)
//
//        presentViewController(alert, animated: true, completion: nil)
//    }


/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
 // Get the new view controller using segue.destinationViewController.
 // Pass the selected object to the new view controller.
 }
 */



