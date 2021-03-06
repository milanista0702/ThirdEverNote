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
    @IBOutlet var undertoolbar: UIToolbar!
    
    var calendarBar: UILabel!
    var toolbar = UIToolbar()
    var addBtn: UIBarButtonItem!
    var editBtn: UIBarButtonItem!
    var accountBtn: UIBarButtonItem!
    var todoArray = [ToDoes]()
    var scheduleArray = [Schedule]()
    var refreshControl : UIRefreshControl!
    
    
    
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
    
    let currentCalendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    
    var tapnumber: Int!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.table.delegate = self
        self.table.dataSource = self
        
//        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
//        bg.image = UIImage(named:"アートボード 8.png")
//        bg.layer.zPosition = -1
//        self.view.addSubview(bg)
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        self.table.addSubview(refreshControl)
        
        let graduationLayer: CAGradientLayer = CAGradientLayer()
        graduationLayer.frame = (self.navigationController?.navigationBar.bounds)!
        let color1 = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let color2 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        graduationLayer.colors = [color1, color2]
        
        graduationLayer.startPoint = CGPoint(x: 0, y: 0)
        graduationLayer.endPoint = CGPoint(x: 1.0, y: 10.0)
        
        //self.navigationController?.navigationBar.barTintColor = ColorManager.blue
        self.navigationController?.navigationBar.layer.insertSublayer(graduationLayer, at: 0)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.black]
        
        let graduationLayer2: CAGradientLayer = CAGradientLayer()
        graduationLayer2.frame = self.toolbar.bounds
        let color3 = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let color4 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        graduationLayer2.colors = [color3, color4]
        
        graduationLayer2.startPoint = CGPoint(x: 0, y: 0)
        graduationLayer2.endPoint = CGPoint(x: 1.0, y: 10.0)
        
        toolbar.layer.insertSublayer(graduationLayer2, at: 0)
        toolbar.tintColor = UIColor.white
        
        let graduationLayer3: CAGradientLayer = CAGradientLayer()
        graduationLayer3.frame = self.undertoolbar.bounds
        let color5 = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor
        let color6 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        graduationLayer3.colors = [color5, color6]
        
        graduationLayer3.startPoint = CGPoint(x: 0, y: 0)
        graduationLayer3.endPoint = CGPoint(x: 0.5, y: 0.5)
        
        //undertoolbar.barTintColor = ColorManager.gray
        undertoolbar.tintColor = UIColor.white
        
        //NavigationToolBar
        accountBtn = UIBarButtonItem(image: UIImage(named: "bouninngenn.png"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(tapaccountbtn(sender:)))
        self.navigationItem.rightBarButtonItem = accountBtn
        
        //underBarButton
        addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.onClick(sender:)))
        editBtn = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(self.setEditing(_:animated:)))
        let flexiblespace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        undertoolbar.items = [editBtn, flexiblespace, addBtn]
        
        table.register(UINib(nibName: "TodoTableCell", bundle: nil), forCellReuseIdentifier: "TodoTableCell")
        
        self.table.estimatedRowHeight = 90
        self.table.rowHeight = UITableViewAutomaticDimension
        
//        let longPressRecognizer = UILongPressGestureRecognizer(target: nil, action: Selector(("rowButtonAction:")))
//        longPressRecognizer.allowableMovement = 15
//        longPressRecognizer.minimumPressDuration = 0.6
//        self.table.addGestureRecognizer(longPressRecognizer)
        
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //iPhone5またはiPhone5s
        //iPhoneSE
        if (screenWidth == 320 && screenHeight == 568){
            
            calendarLabelIntervalX = 5;   //曜日左右
            calendarLabelX         = 45;  //横開き具合
            calendarLabelY         = 93;  //縦開き具合
            calendarLabelWidth     = 40;  //横左右？
            calendarLabelHeight    = 25;  //縦上下
            calendarLableFontSize  = 14;
            
            buttonRadius           = 20.0;  //形
            
            calendarIntervalX      = 5;   //カレンダー左右
            calendarX              = 45;  //縦開き具合
            calendarIntervalY      = 120; //カレンダー上下
            calendarY              = 45;  //縦開き具合
            calendarSize           = 40;
            calendarFontSize       = 17;
            
            //iPhone6
        }else if (screenWidth == 375 && screenHeight == 667){
            
            let remake = -35
            
            calendarLabelIntervalX = 15;
            calendarLabelX         = 50;
            calendarLabelY         = 100 + remake;
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
            
            //iPhone6 P
            //iPhone7 P
            //iPhone8 P
        }else if (screenWidth == 414 && screenHeight == 736){
            
            calendarLabelIntervalX = 15;
            calendarLabelX         = 55;
            calendarLabelY         = 70;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 18;
            
            buttonRadius           = 25;
            
            calendarIntervalX      = 18;
            calendarX              = 55;
            calendarIntervalY      = 110;
            calendarY              = 55;
            calendarSize           = 50;
            calendarFontSize       = 21;
            
            // iPhoneX
        }else if (screenWidth == 375 && screenHeight == 812){
            
            calendarLabelIntervalX = 3;
            calendarLabelX         = 53;
            calendarLabelY         = 105;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 18;
            
            buttonRadius           = 25;
            
            calendarIntervalX      = 3;
            calendarX              = 53;
            calendarIntervalY      = 140;
            calendarY              = 55;
            calendarSize           = 50;
            calendarFontSize       = 21;
            
            //iPhoneXS
        }else if (screenWidth == 375 && screenHeight == 667) {
            
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
            
            //iPhoneXR
            //iPhoneXS M
        }else if (screenWidth == 414 && screenHeight == 896) {
            calendarLabelIntervalX = 8;
            calendarLabelX         = 57;
            calendarLabelY         = 95;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 90;
            calendarLableFontSize  = 18;
            
            buttonRadius           = 25;
            
            calendarIntervalX      = 10;
            calendarX              = 57;
            calendarIntervalY      = 180;
            calendarY              = 60;
            calendarSize           = 50;
            calendarFontSize       = 21;
            
            //iPad
            //iPad 2
            //iPad 3
            //iPad 4
            //iPad Air
            //iPad Air 2
            //iPad Pro 9.7
        }else if (screenWidth == 768 && screenHeight == 1024) {
            
            calendarLabelIntervalX = 50;
            calendarLabelX         = 100;
            calendarLabelY         = 95;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 18;
            
            buttonRadius           = 40;
            
            calendarIntervalX      = 40;
            calendarX              = 100;
            calendarIntervalY      = 135;
            calendarY              = 95;
            calendarSize           = 80;
            calendarFontSize       = 21;
            
            //iPad 10.5
        }else if (screenWidth == 834 && screenHeight == 1112){
            
            calendarLabelIntervalX = 60;
            calendarLabelX         = 112;
            calendarLabelY         = 95;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 18;
            
            buttonRadius           = 50;
            
            calendarIntervalX      = 43;
            calendarX              = 110;
            calendarIntervalY      = 135;
            calendarY              = 110;
            calendarSize           = 100;
            calendarFontSize       = 21;
            
            // iPad Pro 11
        }else if (screenWidth == 834 && screenHeight == 1194) {
            
            calendarLabelIntervalX = 63;
            calendarLabelX         = 110;
            calendarLabelY         = 95;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 25;
            
            buttonRadius           = 50;
            
            calendarIntervalX      = 40;
            calendarX              = 110;
            calendarIntervalY      = 135;
            calendarY              = 120;
            calendarSize           = 100;
            calendarFontSize       = 21;
            
            // iPad Pro 12.9
        }else if (screenWidth == 1024 && screenHeight == 1366) {
            
            calendarLabelIntervalX = 79;
            calendarLabelX         = 136;
            calendarLabelY         = 95;
            calendarLabelWidth     = 55;
            calendarLabelHeight    = 25;
            calendarLableFontSize  = 25;
            
            buttonRadius           = 55;
            
            calendarIntervalX      = 60;
            calendarX              = 135;
            calendarIntervalY      = 160;
            calendarY              = 145;
            calendarSize           = 110;
            calendarFontSize       = 21;
            
        }
        //現在の日付を取得する
        now = NSDate()
        
        //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
        let calendar: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        let range: NSRange = calendar.range(of: NSCalendar.Unit.day, in:NSCalendar.Unit.month, for:now as Date)
        
        //最初にメンバ変数に格納するための現在日付の情報を取得する
        comps = calendar.components([NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second, NSCalendar.Unit.weekday],from:now as Date) as NSDateComponents?
        
        //年月日と最後の日付と曜日を取得(NSIntegerをintへのキャスト不要)
        let orgYear: NSInteger      = comps.year
        let orgMonth: NSInteger     = comps.month
        let orgDay: NSInteger       = comps.day
        let _: NSInteger      = comps.hour
        let _: NSInteger    = comps.minute
        let _: NSInteger   = comps.second
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
            button.titleLabel?.sizeToFit()
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
         var monthE: String!
        if month == 1 {
            monthE = "Jan."
        }else if month == 2 {
            monthE = "Feb."
        }else if month == 3 {
            monthE = "Mar."
        }else if month == 4 {
            monthE = "Apr."
        }else if month == 5 {
            monthE = "May"
        }else if month == 6 {
            monthE = "Jun."
        }else if month == 7 {
            monthE = "Jul."
        }else if month == 8 {
            monthE = "Aug."
        }else if month == 9 {
            monthE = "Sep."
        }else if month == 10 {
            monthE = "Oct."
        }else if month == 11 {
            monthE = "Nov."
        }else{
            monthE = "Dec."
        }
        self.navigationItem.title = "\(monthE!) \(year!)"
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
                                            NSCalendar.Unit.weekday], from: currentDate as Date) as NSDateComponents?
        
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
        
        
        let formatter = DateFormatter()
        let jaLocale = Locale(identifier: "ja_JP")
        formatter.locale = jaLocale
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        
        print(formatter.date(from: dateString) as Any)
        return formatter.date(from: dateString)! as NSDate
    }
    
    
    
    func eaqul (year: Int, month: Int, day: Int) -> NSDate {
        
        let zeroFilledM = String(format: "%02d", month)
        let zeroFilledD = String(format: "%02d", day)
        
        let string: String = "\(year)/\(zeroFilledM)/\(zeroFilledD) 23:59:59"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        
        print (formatter.date(from: string) as Any)
        
        return formatter.date(from: string)! as NSDate
    }
    
    //カレンダーボタンをタップした時のアクション
    @objc func buttonTapped(button: UIButton){
        
        
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
        let _: NSCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        let query = NCMBQuery(className: "ToDoes")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("date", lessThanOrEqualTo : self.eaqul(year: year, month: month, day: day))
        query?.whereKey("date", greaterThan: self.create(year: year, month: month, day: day))
        query?.findObjectsInBackground { (objects, error) in
            if error != nil {
                print("nil")
            } else {
                print("objects")
                print(objects as Any as Any as Any)
                print("objects")
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
                print(objects as Any)
                print("objects")
                print(self.scheduleArray)
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
    
    
    @objc func Left(gesture: UIGestureRecognizer) {
        self.performSegue(withIdentifier: "toReminder", sender: nil)
    }
    
    @objc func Right () {
        
    }
    
    
    @objc func Up(gesture: UIGestureRecognizer) {
        self.nextCalendarSettings()
    }
    
    @objc func Down() {
        self.prevCalendarSettings()
    }
    
    @objc internal func goaccount(sender:UIBarButtonItem) {
        self.performSegue(withIdentifier: "goaccount", sender: nil)
    }
}



// MARK: 画面の下側

extension ViewController: UITableViewDataSource {
    
    func makecell() {
        todoArray = []
        let query = ToDoes.query()
        query?.findObjectsInBackground({objects, error in
            if error != nil {
                print("TODO取得失敗")
            }else{
            let todoes = objects as! [ToDoes]
                for i in 0..<todoes.count {
                    if todoes[i].user == NCMBUser.current() {
                        self.todoArray.append(todoes[i])
                        self.table.reloadData()
                    }
                }
            }
        })
        
        scheduleArray = []
        let querys = Schedule.query()
        querys?.findObjectsInBackground({objects, error in
            if error != nil {
                print("予定取得失敗")
            }else{
                let schedules = objects as! [Schedule]
                for i in 0..<schedules.count {
                    if schedules[i].user == NCMBUser.current() {
                        self.scheduleArray.append(schedules[i])
                        self.table.reloadData()
                    }
                }
            }
        })
    }
    
    //cellの数を設定
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoArray.count + scheduleArray.count
        //これからReminderArrayを作ったら　ReminderArray.count か　それ+1
    }
    
    //ID付きのcellを取得してそれに付属しているlabelとかimageとか
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableCell", for: indexPath as IndexPath) as! TodoTableCell
        if indexPath.row < scheduleArray.count {
            let sortedscheduleArray = scheduleArray.sorted{($0.date as Date) < ($1.date as Date)}
            cell.todolabel.text = sortedscheduleArray[indexPath.row].title
            cell.datelabel.text = formatter(date: sortedscheduleArray[indexPath.row].date)
            cell.arrowImageView.image = UIImage(named:  "矢印.png")
            cell.colorlabel.backgroundColor = ColorManager.orange
        }else{
            let sortedtodoArray = todoArray.sorted{( $0.date as Date) < ($1.date as Date)}
            cell.todolabel.text = sortedtodoArray[indexPath.row - scheduleArray.count].todo
            cell.datelabel.text = formatter(date: sortedtodoArray[indexPath.row - scheduleArray.count].date)
            cell.arrowImageView.image = UIImage(named:  "矢印.png")
            cell.colorlabel.backgroundColor = ColorManager.green
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
    
}

extension ViewController: UITableViewDelegate {
    //myaccount
    @objc internal func tapaccountbtn(sender: UIButton) {
        self.performSegue(withIdentifier: "goaacount", sender: nil)
    }
    
    // add
    @objc internal func onClick(sender: UIButton) {
        self.performSegue(withIdentifier: "Saddsegue", sender: nil)
    }
    
    //editが押された時の処理
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        table.isEditing = editing
    }
    
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
                print(error?.localizedDescription as Any)
            }
        }
        let sobject = scheduleArray[indexPath.row]
        sobject.deleteEventually { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
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
    }
    
    @objc func refresh() {
        loadData()
        refreshControl.endRefreshing()
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
    
    func dismiss(segue: UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
}
