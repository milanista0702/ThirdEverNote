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

class ViewController: UIViewController  {
    
    @IBOutlet var table: UITableView!
    @IBOutlet var calendarBar: UILabel!
    @IBOutlet var toolbar: UIToolbar!
    
    let color = ColorManager()
    
    var todoArray = [ToDoes]()
    var scheduleArray = [Schedule]()
    let refreshControl = UIRefreshControl()
    
    //倉庫にアクセス
    let saveData: UserDefaults = UserDefaults.standard
    
    
    //メンバ変数の設定（配列格納用）
    var count: Int!
    var buttonsArray = [UIButton] ()
    
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
    
    let currentCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    
    var tapnumber: Int!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = color.blue
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        toolbar.barTintColor = color.blue
        toolbar.tintColor = UIColor.white
        
        
        //addボタン
        let fixedSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tap))
        
        toolbar.setItems([editButtonItem, fixedSpacer, addBtn], animated: false)
        
        table.register(UINib(nibName: "TodoTableCell", bundle: nil), forCellReuseIdentifier: "TodoTableCell")
        
        
        self.table.delegate = self
        self.table.dataSource = self
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: nil, action: "rowButtonAction:")
        longPressRecognizer.allowableMovement = 15
        longPressRecognizer.minimumPressDuration = 0.6
        self.table.addGestureRecognizer(longPressRecognizer)
        
        
        //現在起動中のデバイスを取得（スクリーンの幅・高さ）
        //        let screenWidth  = DeviseSize.screenWidth()
        //        let screenHeight = DeviseSize.screenHeight()
        let screenSize: CGRect = UIScreen.main.bounds
        
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
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let range: NSRange = calendar.range(of: NSCalendar.Unit.day, in:NSCalendar.Unit.month, for:now as Date)
        
        //最初にメンバ変数に格納するための現在日付の情報を取得する
        comps = calendar.components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday],from:now as Date) as NSDateComponents!
        
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
        buttonsArray = [UIButton] ()
        
        //曜日ラベル初期定義
        let monthName:[String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
        
        //曜日ラベルを動的に配置
        setupCalendarLabel(array: monthName as NSArray)
        
        //初期表示時のカレンダーをセットアップする
        setupCurrentCalendar()
        
        //tableviewのdatasourcemesodはviewcontrollerクラスに書く設定
        table.dataSource = self
        
        //UITableViewが持っているDelegatmesodの処理の委託先をViewController.swiftにする
        table.delegate = self
        
        let swipeLeftGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Left))
        swipeLeftGesture.numberOfTouchesRequired = 1
        swipeLeftGesture.direction = UISwipeGestureRecognizerDirection.left
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipeLeftGesture)
        
        
        let swipeRightGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Right))
        swipeRightGesture.numberOfTouchesRequired = 1
        swipeRightGesture.direction = UISwipeGestureRecognizerDirection.right
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipeRightGesture)
        
        
        let swipeUpGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Up))
        swipeUpGesture.numberOfTouchesRequired = 1
        swipeUpGesture.direction = UISwipeGestureRecognizerDirection.up
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(Down))
        swipeDownGesture.numberOfTouchesRequired = 1
        swipeDownGesture.direction = UISwipeGestureRecognizerDirection.down
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(swipeDownGesture)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(NCMBUser.current())
        
        if NCMBUser.current() == nil {
            self.performSegue(withIdentifier: "toSignupView", sender: nil)
        }
    }
    
    
    //曜日ラベルの動的配置関数
    func setupCalendarLabel(array: NSArray) {
        
        let calendarLabelCount = 7
        
        for i in 0...6{
            
            //ラベルを作成
            let calendarBaseLabel: UILabel = UILabel()
            
            //X座標の値をCGFloat型へ変換して設定
            
            calendarBaseLabel.frame = CGRect(x: CGFloat(calendarLabelIntervalX + calendarLabelX * (i % calendarLabelCount)), y: CGFloat(calendarLabelY), width: CGFloat(calendarLabelWidth), height: CGFloat(calendarLabelHeight))
            
            
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
                calendarBaseLabel.textColor = UIColor.lightGray
                
            }
            
            //曜日ラベルの配置
            calendarBaseLabel.text = String(array[i] as! NSString)
            calendarBaseLabel.textAlignment = NSTextAlignment.center
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
            button.frame = CGRect(x: CGFloat(positionX), y: CGFloat(positionY), width: CGFloat(buttonSizeX!), height: CGFloat(buttonSizeY!))
            
            //
            //ボタンの初期設定をする
            if(i < dayOfWeek - 1){
                
                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", for: .normal)
                button.isEnabled = false
                
            }else if(i == dayOfWeek - 1 || i < dayOfWeek + maxDay - 1){
                
                //日付の入る部分はボタンのタグを設定する（日にち）
                button.setTitle(String(tagNumber), for: .normal)
                button.tag = tagNumber
                tagNumber += 1
                
            }else if(i == dayOfWeek + maxDay - 1 || i < total){
                
                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", for: .normal)
                button.isEnabled = false
                
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
                calendarBackGroundColor = UIColor.lightGray
            }
            
            //ボタンのデザインを決定する
            button.backgroundColor = calendarBackGroundColor
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel!.font = UIFont(name: "System", size: CGFloat(calendarFontSize))
            button.layer.cornerRadius = CGFloat(buttonRadius)
            
            //配置したボタンに押した際のアクションを設定する
            button.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
            
            //ボタンを配置する
            self.view.addSubview(button)
            buttonsArray.append(button)
        }
        
    }
    
    
    //タイトル表記を設定する関数
    func setupCalendarTitleLabel() {
        self.navigationItem.title = "\(year!)年\(month!)月"
    }
    
    
    //現在（初期表示時）の年月に該当するデータを取得する関数
    func setupCurrentCalendarData() {
        
        /*************
         * (重要ポイント)
         * 現在月の1日のdayOfWeek(曜日の値)を使ってカレンダーの始まる位置を決めるので、
         * yyyy年mm月1日のデータを作成する。
         * 後述の関数 setupPrevCalendarData, setupNextCalendarData も同様です。
         *************/
        let currentComps: NSDateComponents = NSDateComponents()
        
        currentComps.year  = year
        currentComps.month = month
        currentComps.day   = 1
        
        let currentDate: NSDate = currentCalendar.date(from: currentComps as DateComponents)! as NSDate
        recreateCalendarParameter(currentCalendar: currentCalendar, currentDate: currentDate)
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
        let prevCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let prevComps: NSDateComponents = NSDateComponents()
        
        prevComps.year  = year
        prevComps.month = month
        prevComps.day   = 1
        
        let prevDate: NSDate = prevCalendar.date(from: prevComps as DateComponents)! as NSDate
        recreateCalendarParameter(currentCalendar: prevCalendar, currentDate: prevDate)
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
        let nextCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let nextComps: NSDateComponents = NSDateComponents()
        
        nextComps.year  = year
        nextComps.month = month
        nextComps.day   = 1
        
        let nextDate : NSDate = nextCalendar.date(from: nextComps as DateComponents)! as NSDate
        recreateCalendarParameter(currentCalendar: nextCalendar, currentDate: nextDate)
        
    }
    
    
    //カレンダーのパラメータを再作成する関数
    func recreateCalendarParameter(currentCalendar: NSCalendar, currentDate: NSDate) {
        
        //引数で渡されたものをもとに日付の情報を取得する
        let currentRange: NSRange = currentCalendar.range(of: NSCalendar.Unit.day, in:NSCalendar.Unit.month, for:currentDate as Date)
        
        
        comps = currentCalendar.components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day,
                                            NSCalendar.Unit.weekday], from: currentDate as Date) as NSDateComponents!
        
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
        for i in 0..<buttonsArray.count {
            (buttonsArray[i] as AnyObject).removeFromSuperview()
        }
        
        //配列に格納したボタンオブジェクトも削除する
        buttonsArray.removeAll()
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
        let calendar : NSCalendar = NSCalendar.current as NSCalendar
        let dateComponents = calendar.components([.year, .month, .day], from: date as Date)
        let today = self.create(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)
        return today
    }
    
    func transition() {
        self.performSegue(withIdentifier: "toSignupView" , sender: nil)
    }
    
    //任意の3つの整数入れたら　year　mounth day　でNSDateにする
    func create(year: Int, month: Int, day: Int) -> NSDate {
        
        let zeroFilledM = String(format: "%02d", month)
        let zeroFilledD = String(format: "%02d", day)
        
        let dateString: String = "\(year)/\(zeroFilledM)/\(zeroFilledD) 0:00:00"
        
        
        var formatter = DateFormatter()
        let jaLocale = Locale(identifier: "ja_JP")
        formatter.locale = jaLocale
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        
        print(formatter.date(from: dateString))
        return formatter.date(from: dateString)! as NSDate
    }
    
    
    
    func eaqul (year: Int, month: Int, day: Int) -> NSDate {
        
        let zeroFilledM = String(format: "%02d", month)
        let zeroFilledD = String(format: "%02d", day)
        
        let string: String = "\(year)/\(zeroFilledM)/\(zeroFilledD) 23:59:59"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        print (formatter.date(from: string))
        
        return formatter.date(from: string)! as NSDate
    }
    
    //カレンダーボタンをタップした時のアクション
    func buttonTapped(button: UIButton){
        
        
        button.setTitleColor(UIColor.black, for: .normal)
        
        if tapnumber != nil {
            for i in buttonsArray {
                if i.tag == tapnumber {
                    i.setTitleColor(UIColor.white, for: .normal)
                }
            }
        }
        
        day = button.tag
        self.find()
        
        tapnumber = button.tag
        
        //コンソール表示
        print("\(year!)年\(month!)月\(button.tag)日が選択されました！")
    }
    
    
    func find () {
        let currentCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        let query = NCMBQuery(className: "ToDoes")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("date", lessThanOrEqualTo : self.eaqul(year: year, month: month, day: day))
        query?.whereKey("date", greaterThan: self.create(year: year, month: month, day: day))
        query?.findObjectsInBackground { (objects, error) in
            if error != nil {
                print("nil")
            } else {
                print(objects)
                self.todoArray = objects as! [ToDoes]
                self.table.reloadData()
            }
        }
        
        let sQuery = NCMBQuery(className: "Schedule")
        sQuery?.whereKey("user", equalTo: NCMBUser.current())
        sQuery?.whereKey("date", lessThanOrEqualTo: self.eaqul(year: year, month: month, day: day ))
        sQuery?.whereKey("date", greaterThan: self.create(year: year, month: month, day: day))
        sQuery?.findObjectsInBackground { (objects, error) in
            if error != nil {
                print("nil")
            }else{
                print("objects")
                print(objects)
                print("objects")
                self.scheduleArray = objects as! [Schedule]
                self.table.reloadData()
            }
        }
    }
    
    
    //前月を表示するメソッド
    func prevCalendarSettings() {
        removeCalendarButtonObject()
        setupPrevCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
        
        self.todoArray = []
        self.table.reloadData()
        
    }
    
    
    //次月を表示するメソッド
    func nextCalendarSettings() {
        removeCalendarButtonObject()
        setupNextCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
        
        self.todoArray = []
        self.table.reloadData()
        
    }
    
    
    func Left(gesture: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "toReminder", sender: nil)
    }
    
    func Right () {
        
    }
    
    
    func Up(gesture: UIGestureRecognizer) {
        self.nextCalendarSettings()
    }
    
    func Down() {
        self.prevCalendarSettings()
    }
    
    
}



// MARK: 画面の下側

extension ViewController: UITableViewDataSource {
    
    //editが押された時の処理
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.isEditing = editing
    }
    
    
    //cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count + scheduleArray.count
        
        //これからReminderArrayを作ったら　ReminderArray.count か　それ+1
    }
    
    
    //ID付きのcellを取得してそれに付属しているlabelとかimageとか
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableCell", for: indexPath as IndexPath) as! TodoTableCell
        if indexPath.row <= todoArray.count {
            cell.todolabel.text = todoArray[indexPath.row].todo
            cell.datelabel.text = formatter(date: todoArray[indexPath.row].date)
            cell.arrowImageView.image = UIImage(named:  "矢印.png")
        }else{
            cell.todolabel.text = scheduleArray[indexPath.row - todoArray.count].title
            cell.datelabel.text = formatter(date: scheduleArray[indexPath.row].date)
            cell.arrowImageView.image = UIImage(named:  "矢印.png")
        }
        return cell
    }
    
    func formatter (date: NSDate) -> String {
        let dateFormatter  = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale!
        dateFormatter.dateFormat = "HH:mm"
        
        return dateFormatter.string(from: date as Date)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row <= todoArray.count{
            NSLog("%@が選択された", todoArray[indexPath.row])
        }else{
            NSLog("%@が選択された", scheduleArray[indexPath.row - todoArray.count])
        }
        
        if let cell: TodoTableCell = table.cellForRow(at: indexPath as IndexPath) as? TodoTableCell {
            if cell.arrowImageView.image == UIImage(named: "check.png") {
                cell.arrowImageView.image = UIImage(named: "矢印.png")
            } else {
                cell.arrowImageView.image = UIImage(named: "check.png")
            }
        }
        
        if tableView.allowsSelectionDuringEditing {
            print("asdfghj")
        }
        
    }
    
    func loadData() {
        Schedule.loadall(callback: {objects in
            self.scheduleArray.removeAll()
            
            for object in objects {
                self.scheduleArray.append(object)
            }
            self.table.reloadData()
        })
    }
    
    func refresh() {
        loadData()
        refreshControl.endRefreshing()
    }
    
}

extension ViewController: UITableViewDelegate {
    
    //削除可能なcellのindexpath取得(今は全て)
    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    //削除された時の実装
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        self.delegateObjec(indexPath: indexPath as NSIndexPath)
        
        
        // 先にデータを更新する
        todoArray.remove(at: indexPath.row)
        scheduleArray.remove(at: indexPath.row)
        
        // それからテーブルの更新
        table.deleteRows(at: [NSIndexPath(row: indexPath.row, section: 0) as IndexPath],
                         with: UITableViewRowAnimation.fade)
    }
    
    func delegateObjec(indexPath: NSIndexPath) {
        let object = todoArray[indexPath.row]
        object.deleteEventually { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
        let sobject = scheduleArray[indexPath.row]
        sobject.deleteEventually { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    
    //cellの並べ替え
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let targetTitle = todoArray[sourceIndexPath.row]
        if let index = todoArray.index(of: targetTitle) {
            todoArray.remove(at: index)
            todoArray.insert(targetTitle, at: destinationIndexPath.row)
        }
        let stargetTitle = scheduleArray[sourceIndexPath.row]
        if let index = scheduleArray.index(of: stargetTitle) {
            scheduleArray.remove(at: index)
            scheduleArray.insert(stargetTitle, at: destinationIndexPath.row)
        }
    }
    
    
    //編集中以外にcellを左スワイプできない
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if table.isEditing {
            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.none
        }
        
        
        //編集中にもcellを選択できる
        table.allowsSelectionDuringEditing = true
        table.cellForRow(at: indexPath as IndexPath)?.textInputMode
    }
    
    
    func rowButtonAction(sender : UILongPressGestureRecognizer) {
        
        let point: CGPoint = sender.location(in: table)
        let indexPath = table.indexPathForRow(at: point)
        
        if let indexPath = indexPath {
            if sender.state == UIGestureRecognizerState.began {
                
                // セルが長押しされたときの処理
                print("long pressed \(indexPath.row)")
            }
        }else{
            print("long press on table view")
        }
    }
    
    
    //appボタンが押された時 → tapが呼ばれる
    func tap(sender: AnyObject) {
        self.performSegue(withIdentifier: "Saddsegue", sender: nil)
    }
    
    func dismiss(segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
}
