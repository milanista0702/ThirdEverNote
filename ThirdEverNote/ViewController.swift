//
//  ViewController.swift
//  ThirdEverNote
//
//  Created by makka misako on 2016/02/16.
//  Copyright © 2016年 makka misako. All rights reserved.
//

import UIKit
import NCMB

//CALayerクラスのインポート
import QuartzCore

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    //下半分のtableview
    @IBOutlet var table: UITableView!
    @IBOutlet var calendarBar: UILabel!
    @IBOutlet var toolbar: UIToolbar!
    
    //var SArray = [ToDoes]()
    
    //倉庫から取り出す
    let saveData: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    //メンバ変数の設定（配列格納用）
    var count: Int!
    var mArray: NSMutableArray!
    
    //メンバ変数の設定（カレンダー用）
    var now: NSDate!
    var year: Int!
    var month: Int!
    var day: Int!
    var hour: Int!
    var minute: Int!
    var second: Int!
    var maxDay: Int!
    var dayOfWeek: Int!
    
    //メンバ変数の設定（カレンダー関数から取得したものを渡す）
    var comps: NSDateComponents!
    
    //メンバ変数の設定（カレンダーの背景色）
    var calendarBackGroundColor: UIColor!
    
    
    //カレンダーの位置決め用メンバ変数
    var calendarLabelIntervalX: Int!
    var calendarLabelX: Int!
    var calendarLabelY: Int!
    var calendarLabelWidth: Int!
    var calendarLabelHeight: Int!
    var calendarLableFontSize: Int!
    
    var buttonRadius: Float!
    
    var calendarIntervalX: Int!
    var calendarX: Int!
    var calendarIntervalY: Int!
    var calendarY: Int!
    var calendarSize: Int!
    var calendarFontSize: Int!
    
    var addBtn: UIBarButtonItem!
    
    var sArray = [String]()
    
    let currentCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addボタン
        let fixedSpacer = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: self, action: nil)
        addBtn = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(tap))
        
        toolbar.setItems([editButtonItem(), fixedSpacer, addBtn], animated: false)
        
        
        
        
        self.table.delegate = self
        self.table.dataSource = self
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: nil, action: "rowButtonAction:")
        longPressRecognizer.allowableMovement = 15
        longPressRecognizer.minimumPressDuration = 0.6
        self.table.addGestureRecognizer(longPressRecognizer)
        
        
        //現在起動中のデバイスを取得（スクリーンの幅・高さ）
        //        let screenWidth  = DeviseSize.screenWidth()
        //        let screenHeight = DeviseSize.screenHeight()
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //iPhone4s
        if(screenWidth == 320 && screenHeight == 480){
            
            calendarLabelIntervalX = 5;
            calendarLabelX         = 45;
            calendarLabelY         = 93;
            calendarLabelWidth     = 40;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 14;
            
            buttonRadius           = 20.0;
            
            calendarIntervalX      = 5;
            calendarX              = 45;
            calendarIntervalY      = 120;
            calendarY              = 45;
            calendarSize           = 40;
            calendarFontSize       = 17;
            
            //iPhone5またはiPhone5s
        }else if (screenWidth == 320 && screenHeight == 568){
            
            calendarLabelIntervalX = 5;
            calendarLabelX         = 45;
            calendarLabelY         = 93;
            calendarLabelWidth     = 40;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 14;
            
            buttonRadius           = 20.0;
            
            calendarIntervalX      = 5;
            calendarX              = 45;
            calendarIntervalY      = 120;
            calendarY              = 45;
            calendarSize           = 40;
            calendarFontSize       = 17;
            
            //iPhone6
        }else if (screenWidth == 375 && screenHeight == 667){
            
            let remake = -35
            
            calendarLabelIntervalX = 15;
            calendarLabelX         = 50;
            calendarLabelY         = 95 + remake;
            calendarLabelWidth     = 45;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 16;
            
            buttonRadius           = 22.5;
            
            calendarIntervalX      = 15;
            calendarX              = 50;
            calendarIntervalY      = 125 + remake ;
            calendarY              = 50;
            calendarSize           = 45;
            calendarFontSize       = 19;
            
            //            self.prevMonthButton.frame = CGRectMake(15, 438, CGFloat(calendarSize), CGFloat(calendarSize));
            //            self.nextMonthButton.frame = CGRectMake(314, 438, CGFloat(calendarSize), CGFloat(calendarSize));
            
            //iPhone6 plus
        }else if (screenWidth == 414 && screenHeight == 736){
            
            calendarLabelIntervalX = 15;
            calendarLabelX         = 55;
            calendarLabelY         = 95;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 18;
            
            buttonRadius           = 25;
            
            calendarIntervalX      = 18;
            calendarX              = 55;
            calendarIntervalY      = 125;
            calendarY              = 55;
            calendarSize           = 50;
            calendarFontSize       = 21;
        }
        
        //現在の日付を取得する
        now = NSDate()
        
        //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let range: NSRange = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit:NSCalendarUnit.Month, forDate:now)
        
        //最初にメンバ変数に格納するための現在日付の情報を取得する
        comps = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second, NSCalendarUnit.Weekday],fromDate:now)

        //年月日と最後の日付と曜日を取得(NSIntegerをintへのキャスト不要)
        let orgYear: NSInteger      = comps.year
        let orgMonth: NSInteger     = comps.month
        let orgDay: NSInteger       = comps.day
        let orgHour: NSInteger      = comps.hour
        let orgMinute: NSInteger    = comps.minute
        let orgSecond: NSInteger   = comps.second
        let orgDayOfWeek: NSInteger = comps.weekday
        let max: NSInteger          = range.length
        
        year      = orgYear
        month     = orgMonth
        day       = orgDay
        dayOfWeek = orgDayOfWeek
        maxDay    = max
        
        //空の配列を作成する（カレンダーデータの格納用）
        mArray = NSMutableArray()
        
        //曜日ラベル初期定義
        let monthName:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        
        //曜日ラベルを動的に配置
        setupCalendarLabel(monthName)
        
        //初期表示時のカレンダーをセットアップする
        setupCurrentCalendar()
        
        //tableviewのdatasourcemesodはviewcontrollerクラスに書く設定
        table.dataSource = self
        
        //UITableViewが持っているDelegatmesodの処理の委託先をViewController.swiftにする
        table.delegate = self
        
        // Do any additional setup after loading the view.
        
        sArray = []
        
        let swipeLeftGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Left))
        swipeLeftGesture.numberOfTouchesRequired = 1
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        
        let swipeRightGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Right))
        swipeRightGesture.numberOfTouchesRequired = 1
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(swipeRightGesture)
        
        
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Up))
        swipeUpGesture.numberOfTouchesRequired = 1
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.Up
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Down))
        swipeDownGesture.numberOfTouchesRequired = 1
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.Down
        self.view.userInteractionEnabled = true
        self.view.addGestureRecognizer(swipeDownGesture)
        
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if NCMBUser.currentUser() == nil {
            self.performSegueWithIdentifier("toSignupView", sender: nil)
        }
    }
    
    
    //editが押された時の処理
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.editing = editing
    }
    
    
    
    //曜日ラベルの動的配置関数
    func setupCalendarLabel(array: NSArray) {
        
        let calendarLabelCount = 7
        
        for i in 0...6{
            
            //ラベルを作成
            let calendarBaseLabel: UILabel = UILabel()
            
            //X座標の値をCGFloat型へ変換して設定
            calendarBaseLabel.frame = CGRectMake(
                CGFloat(calendarLabelIntervalX + calendarLabelX * (i % calendarLabelCount)),
                CGFloat(calendarLabelY),
                CGFloat(calendarLabelWidth),
                CGFloat(calendarLabelHeight)
            )
            
            //日曜日の場合は赤色を指定
            if(i == 0){
                
                //RGBカラーの設定は小数値をCGFloat型にしてあげる
                calendarBaseLabel.textColor = UIColor(
                    red: CGFloat(0.831), green: CGFloat(0.349), blue: CGFloat(0.224), alpha: CGFloat(1.0)
                )
                
                //土曜日の場合は青色を指定
            }else if(i == 6){
                
                //RGBカラーの設定は小数値をCGFloat型にしてあげる
                calendarBaseLabel.textColor = UIColor(
                    red: CGFloat(0.400), green: CGFloat(0.471), blue: CGFloat(0.980), alpha: CGFloat(1.0)
                )
                
                //平日の場合は灰色を指定
            }else{
                
                //既に用意されている配色パターンの場合
                calendarBaseLabel.textColor = UIColor.lightGrayColor()
                
            }
            
            //曜日ラベルの配置
            calendarBaseLabel.text = String(array[i] as! NSString)
            calendarBaseLabel.textAlignment = NSTextAlignment.Center
            calendarBaseLabel.font = UIFont(name: "System", size: CGFloat(calendarLableFontSize))
            self.view.addSubview(calendarBaseLabel)
        }
    }
    
    
    //カレンダーを生成する関数
    func generateCalendar(){
        
        //タグナンバーとトータルカウントの定義
        var tagNumber = 1
        let total     = 42
        
        //7×6=42個のボタン要素を作る
        for i in 0...41{
            
            //配置場所の定義
            let positionX   = calendarIntervalX + calendarX * (i % 7)
            let positionY   = calendarIntervalY + calendarY * (i / 7)
            let buttonSizeX = calendarSize;
            let buttonSizeY = calendarSize;
            
            //ボタンをつくる
            let button: UIButton = UIButton()
            button.frame = CGRectMake(
                CGFloat(positionX),
                CGFloat(positionY),
                CGFloat(buttonSizeX),
                CGFloat(buttonSizeY)
            );
            
            //ボタンの初期設定をする
            if(i < dayOfWeek - 1){
                
                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", forState: .Normal)
                button.enabled = false
                
            }else if(i == dayOfWeek - 1 || i < dayOfWeek + maxDay - 1){
                
                //日付の入る部分はボタンのタグを設定する（日にち）
                button.setTitle(String(tagNumber), forState: .Normal)
                button.tag = tagNumber
                tagNumber++
                
            }else if(i == dayOfWeek + maxDay - 1 || i < total){
                
                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", forState: .Normal)
                button.enabled = false
                
            }
            
            //ボタンの配色の設定
            //@remark:このサンプルでは正円のボタンを作っていますが、背景画像の設定等も可能です。
            if(i % 7 == 0){
                calendarBackGroundColor = UIColor(
                    red: CGFloat(0.831), green: CGFloat(0.349), blue: CGFloat(0.224), alpha: CGFloat(1.0)
                )
            }else if(i % 7 == 6){
                calendarBackGroundColor = UIColor(
                    red: CGFloat(0.400), green: CGFloat(0.471), blue: CGFloat(0.980), alpha: CGFloat(1.0)
                )
            }else{
                calendarBackGroundColor = UIColor.lightGrayColor()
            }
            
            //ボタンのデザインを決定する
            button.backgroundColor = calendarBackGroundColor
            button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            button.titleLabel!.font = UIFont(name: "System", size: CGFloat(calendarFontSize))
            button.layer.cornerRadius = CGFloat(buttonRadius)
            
            //配置したボタンに押した際のアクションを設定する
            button.addTarget(self, action: "buttonTapped:", forControlEvents: .TouchUpInside)
            
            //ボタンを配置する
            self.view.addSubview(button)
            mArray.addObject(button)
        }
        
    }
    
    
    //タイトル表記を設定する関数
    func setupCalendarTitleLabel() {
        self.navigationItem.title = "\(year)年\(month)月"
    }
    
    
    //現在（初期表示時）の年月に該当するデータを取得する関数
    func setupCurrentCalendarData() {
        
        /*************
         * (重要ポイント)
         * 現在月の1日のdayOfWeek(曜日の値)を使ってカレンダーの始まる位置を決めるので、
         * yyyy年mm月1日のデータを作成する。
         * 後述の関数 setupPrevCalendarData, setupNextCalendarData も同様です。
         *************/
        // let currentCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let currentComps: NSDateComponents = NSDateComponents()
        
        currentComps.year  = year
        currentComps.month = month
        currentComps.day   = 1
        
        let currentDate: NSDate = currentCalendar.dateFromComponents(currentComps)!
        recreateCalendarParameter(currentCalendar, currentDate: currentDate)
    }
    
    
    //前の年月に該当するデータを取得する関数
    func setupPrevCalendarData() {
        
        //現在の月に対して-1をする
        if(month == 0){
            year = year - 1;
            month = 12;
        }else{
            month = month - 1;
        }
        
        //setupCurrentCalendarData()と同様の処理を行う
        let prevCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let prevComps: NSDateComponents = NSDateComponents()
        
        prevComps.year  = year
        prevComps.month = month
        prevComps.day   = 1
        
        let prevDate: NSDate = prevCalendar.dateFromComponents(prevComps)!
        recreateCalendarParameter(prevCalendar, currentDate: prevDate)
    }
    
    
    //次の年月に該当するデータを取得する関数
    func setupNextCalendarData() {
        
        //現在の月に対して+1をする
        if(month == 12){
            year = year + 1;
            month = 1;
        }else{
            month = month + 1;
        }
        
        //setupCurrentCalendarData()と同様の処理を行う
        let nextCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let nextComps: NSDateComponents = NSDateComponents()
        
        nextComps.year  = year
        nextComps.month = month
        nextComps.day   = 1
        
        let nextDate : NSDate = nextCalendar.dateFromComponents(nextComps)!
        recreateCalendarParameter(nextCalendar, currentDate: nextDate)
    }
    
    
    //カレンダーのパラメータを再作成する関数
    func recreateCalendarParameter(currentCalendar: NSCalendar, currentDate: NSDate) {
        
        //引数で渡されたものをもとに日付の情報を取得する
        let currentRange: NSRange = currentCalendar.rangeOfUnit(NSCalendarUnit.Day, inUnit:NSCalendarUnit.Month, forDate:currentDate)
        
        // comps = currentCalendar.([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Weekday],fromDate:currentDate)
        
        comps = currentCalendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day,
            NSCalendarUnit.Weekday], fromDate: currentDate)
        
        //年月日と最後の日付と曜日を取得(NSIntegerをintへのキャスト不要)
        let currentYear: NSInteger      = comps.year
        let currentMonth: NSInteger     = comps.month
        let currentDay: NSInteger       = comps.day
        let currentDayOfWeek: NSInteger = comps.weekday
        let currentMax: NSInteger       = currentRange.length
        
        year      = currentYear
        month     = currentMonth
        day       = currentDay
        dayOfWeek = currentDayOfWeek
        maxDay    = currentMax
    }
    
    
    
    //表示されているボタンオブジェクトを一旦削除する関数
    func removeCalendarButtonObject() {
        
        //ビューからボタンオブジェクトを削除する
        for i in 0..<mArray.count {
            mArray[i].removeFromSuperview()
        }
        
        //配列に格納したボタンオブジェクトも削除する
        mArray.removeAllObjects()
    }
    
    //現在のカレンダーをセットアップする関数
    func setupCurrentCalendar() {
        
        setupCurrentCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
    }
    
    
    // NSDate出してる
    //NSDate の　年と月と日を取り出したNSDate
    func day ( date : NSDate) -> NSDate {
        let calendar : NSCalendar = NSCalendar.currentCalendar()
        let dateComponents = calendar.components([.Year, .Month, .Day], fromDate: date)
        let today = self.create(dateComponents.year, month: dateComponents.month, day: dateComponents.day)
        return today
    }
    
    //任意の3つの整数入れたら　year　mounth day　でNSDateにする
    func create(year: Int, month: Int, day: Int) -> NSDate {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = 
        
        print(NSCalendar.currentCalendar().dateFromComponents(components))
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    
    }
    
    func eaqul (year: Int, month: Int, day: Int) -> NSDate {
        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 23
        components.minute = 59
        components.second = 59
        
        print(NSCalendar.currentCalendar().dateFromComponents(components))
        
        return NSCalendar.currentCalendar().dateFromComponents(components)!
    }
    
    //カレンダーボタンをタップした時のアクション
    func buttonTapped(button: UIButton){
        
        self.find()
        
        //コンソール表示
        print("\(year)年\(month)月\(button.tag)日が選択されました！")
        day = button.tag
        
    }
    
    func find () {
        let currentCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        
        let query = NCMBQuery(className: "ToDoes")
        query.whereKey("user", equalTo: NCMBUser.currentUser())
        query.whereKey("date", lessThanOrEqualTo : self.eaqul(year, month: month, day: day))
        query.whereKey("date", greaterThan: self.create(year, month: month, day: day))
       // query.whereKey("date", greaterThanOrEqualTo: self.eaqul(year, month: month, day: day ))
        query.findObjectsInBackgroundWithBlock { (objects, error) in
            if error != nil {
                print(error.localizedDescription)
            } else {
                print(objects)
            }
        }
    }
    
    
    
    //前月を表示するメソッド
    func prevCalendarSettings() {
        removeCalendarButtonObject()
        setupPrevCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
    }
    
    
    //次月を表示するメソッド
    func nextCalendarSettings() {
        removeCalendarButtonObject()
        setupNextCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
    }
    
    
    //cellの数を設定
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sArray.count
        //これからReminderArrayを作ったら　ReminderArray.count か　それ+1
    }
    
    
    //ID付きのcellを取得してそれに付属しているlabelとかimageとか
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel!.text = sArray[indexPath.row]
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)  {
        NSLog("%@が選択された", sArray[indexPath.row])
        
        if tableView.allowsSelectionDuringEditing {
            print("asdfghj")
        }
        
    }
    
    
    func Left(gesture: UIGestureRecognizer) {
        self.performSegueWithIdentifier("toReminder", sender: nil)
    }
    
    func Right () {
        
    }
    
    
    func Up(gesture: UIGestureRecognizer) {
        self.nextCalendarSettings()
    }
    
    func Down() {
        self.prevCalendarSettings()
        
    }
    
    
    
    
    //削除可能なcellのindexpath取得(今は全て)
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    //削除された時の実装
    func tableView(table: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // 先にデータを更新する
        sArray.removeAtIndex(indexPath.row)
        
        // それからテーブルの更新
        table.deleteRowsAtIndexPaths([NSIndexPath(forRow: indexPath.row, inSection: 0)],
                                     withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    
    //cellの並べ替え
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    func tableView(table: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let targetTitle = sArray[sourceIndexPath.row]
        if let index = sArray.indexOf(targetTitle) {
            sArray.removeAtIndex(index)
            sArray.insert(targetTitle, atIndex: destinationIndexPath.row)
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
    
    
    func rowButtonAction(sender : UILongPressGestureRecognizer) {
        
        let point: CGPoint = sender.locationInView(table)
        let indexPath = table.indexPathForRowAtPoint(point)
        
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
    
    
    func tap() {
        
        let alert = UIAlertController(title: "NEW SCHEDULE", message: "予定を追加", preferredStyle: .Alert)
        let saveAction = UIAlertAction(title: "Done", style: .Default) { (action:UIAlertAction!) -> Void in
            
            // 入力したテキストをコンソールに表示
            let textField = alert.textFields![0] as UITextField
            //            self.label.text = textField.text
            self.sArray.append(textField.text!)
            self.table.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action:UIAlertAction!) -> Void in
        }
        
        // UIAlertControllerにtextFieldを追加
        alert.addTextFieldWithConfigurationHandler { (textField:UITextField!) -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    
}
