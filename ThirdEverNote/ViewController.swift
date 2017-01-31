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
    
    
    var scheduleArray = [Schedule]()
    let refreshControl = UIRefreshControl()
    
    var buttons: [UIButton] = []
    
    //メンバ変数の設定（カレンダー用）
    var now: Date!
    var year: Int!
    var month: Int!
    var day: Int!
    var maxDay: Int!
    var weekday: Int!
    
    
    var labelLayout: CalendarLabelLayout!
    var buttonRadius: Float!
    var calendarLayout: CalendarLayout!
    
    var todoes = [ToDoes]()
    
    let currentCalendar: Calendar = Calendar(identifier: .gregorian)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //addボタン
        let fixedSpacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let addBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tap))
        
        toolbar.setItems([editButtonItem, fixedSpacer, addBtn], animated: false)
        
        table.register(UINib(nibName: "TodoTableCell", bundle: nil), forCellReuseIdentifier: "TodoTableCell")
        
        
        self.table.delegate = self
        self.table.dataSource = self
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: nil, action: #selector(rowButtonAction(sender:)))
        longPressRecognizer.allowableMovement = 15
        longPressRecognizer.minimumPressDuration = 0.6
        self.table.addGestureRecognizer(longPressRecognizer)
        
        
        //現在起動中のデバイスを取得（スクリーンの幅・高さ）
        let screenSize: CGRect = UIScreen.main.bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        //iPhone4s
        if screenWidth == 320 && screenHeight == 480 {
            
            self.labelLayout = CalendarLabelLayout(intervalX: 5, x: 45, y: 93, width: 40, height: 25, fontSize: 14)
            self.calendarLayout = CalendarLayout(intervalX: 5, intervalY: 120, x: 45, y: 45, size: 40, fontSize: 17)
            
            buttonRadius           = 20.0;
            //iPhone5またはiPhone5s
        }else if screenWidth == 320 && screenHeight == 568 {
           
            self.labelLayout = CalendarLabelLayout(intervalX: 5, x: 45, y: 93, width: 40, height: 25, fontSize: 14)
            self.calendarLayout = CalendarLayout(intervalX: 15, intervalY: 120, x: 45, y: 45, size: 40, fontSize: 17)
            buttonRadius           = 20.0;
            //iPhone6
        }else if (screenWidth == 375 && screenHeight == 667){
            
            let remake = -35
            self.labelLayout = CalendarLabelLayout(intervalX: 15, x: 50, y: 95 + remake, width: 45, height: 25, fontSize: 16)
            self.calendarLayout = CalendarLayout(intervalX: 15, intervalY: 125 + remake, x: 50, y: 50, size: 45, fontSize: 19)
            buttonRadius           = 22.5;
            //iPhone6 plus
        }else if screenWidth == 414 && screenHeight == 736 {
            
            self.labelLayout = CalendarLabelLayout(intervalX: 15, x: 55, y: 95, width: 55, height: 25, fontSize: 18)
            self.calendarLayout = CalendarLayout(intervalX: 18, intervalY: 125, x: 55, y: 55, size: 50, fontSize: 21)
            buttonRadius           = 25;
        }
        
        //現在の日付を取得する
        now = Date()
        
        //inUnit:で指定した単位（月）の中で、rangeOfUnit:で指定した単位（日）が取り得る範囲
        let calendar: Calendar = Calendar(identifier: .gregorian)
        let range = calendar.range(of: .day, in: .month, for: now)!
        
        //最初にメンバ変数に格納するための現在日付の情報を取得する
        let comps = calendar.dateComponents([.year, .month, .day, .weekday],from: now)
        
        //年月日と最後の日付と曜日を取得(NSIntegerをintへのキャスト不要)
        let max: Int = range.count
        
        year      = comps.year
        month     = comps.month
        day       = comps.day
        weekday = comps.weekday
        maxDay    = max
        
        //曜日ラベルを動的に配置
        setupCalendarLabel()
        
        //初期表示時のカレンダーをセットアップする
        setupCurrentCalendar()
        
        table.dataSource = self //tableviewのdatasourcemesodはviewcontrollerクラスに書く設定
        table.delegate = self //UITableViewが持っているDelegatmesodの処理の委託先をViewController.swiftにする
        
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
        if NCMBUser.current() == nil {
            self.performSegue(withIdentifier: "toSignupView", sender: nil)
        }
    }
    
    
    //曜日ラベルの動的配置関数
    func setupCalendarLabel() {
        
        let calendarLabelCount = 7
        
        for i in 0...6 {
            
            //ラベルを作成
            let calendarBaseLabel: UILabel = UILabel()
            
            //X座標の値をCGFloat型へ変換して設定
            calendarBaseLabel.frame = CGRect(x: CGFloat(labelLayout.intervalX + labelLayout.x * (i % calendarLabelCount)), y: CGFloat(labelLayout.y), width: CGFloat(labelLayout.width), height: CGFloat(labelLayout.height))

            
            if i == 0 { //日曜日の場合は赤色を指定
                
                calendarBaseLabel.textColor = UIColor(red: 0.831, green: 0.349, blue: 0.224, alpha: 1.0)
                
            }else if i == 6 { //土曜日の場合は青色を指定
                
                calendarBaseLabel.textColor = UIColor(red: 0.400, green: 0.471, blue: 0.980, alpha: 1.0)
                
            }else { //平日の場合は灰色を指定
                
                calendarBaseLabel.textColor = UIColor.lightGray
            }
            
            //曜日ラベルの配置
            let weekNames: [String] = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
            calendarBaseLabel.text = weekNames[i]
            calendarBaseLabel.textAlignment = NSTextAlignment.center
            calendarBaseLabel.font = UIFont(name: "System", size: CGFloat(labelLayout.fontSize))
            self.view.addSubview(calendarBaseLabel)
        }
    }
    
    
    //カレンダーを生成する関数
    func generateCalendar(){
        
        //タグナンバーとトータルカウントの定義
        var tagNumber = 1
        let total     = 42
        
        //7×6=42個のボタン要素を作る
        for i in 0...41 {
            
            //配置場所の定義
            let positionX   = calendarLayout.intervalX + calendarLayout.x * (i % 7)
            let positionY   = calendarLayout.intervalY + calendarLayout.y * (i / 7)
            let buttonSizeX = calendarLayout.size
            let buttonSizeY = calendarLayout.size
            
            //ボタンをつくる
            let button: UIButton = UIButton()
            button.frame = CGRect(x: CGFloat(positionX), y: CGFloat(positionY), width: CGFloat(buttonSizeX!), height: CGFloat(buttonSizeY!))
            //ボタンの初期設定をする
            if i < weekday - 1 {
                
                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", for: .normal)
                button.isEnabled = false
                
            }else if i == weekday - 1 || i < weekday + maxDay - 1 {
                
                //日付の入る部分はボタンのタグを設定する（日にち）
                button.setTitle(String(tagNumber), for: .normal)
                button.tag = tagNumber
                tagNumber += 1
                
            }else if i == weekday + maxDay - 1 || i < total {
                
                //日付の入らない部分はボタンを押せなくする
                button.setTitle("", for: .normal)
                button.isEnabled = false
            }
            
            let calendarBackGroundColor: UIColor = {
                if i % 7 == 0{
                    return UIColor(red: 0.831, green: 0.349, blue: 0.224, alpha: 1.0)
                }else if i % 7 == 6{
                    return UIColor(red: 0.400, green: 0.471, blue: 0.980, alpha: 1.0)
                }else{
                    return UIColor.lightGray
                }
            }()
            
            button.backgroundColor = calendarBackGroundColor
            button.setTitleColor(UIColor.white, for: .normal)
            button.titleLabel!.font = UIFont(name: "System", size: CGFloat(calendarLayout.fontSize))
            button.layer.cornerRadius = CGFloat(buttonRadius)
            
            //配置したボタンに押した際のアクションを設定する
            button.addTarget(self, action: #selector(self.buttonTapped(button:)), for: .touchUpInside)
            
            //ボタンを配置する
            self.view.addSubview(button)
            buttons.append(button)
        }
        
    }
    
    
    //タイトル表記を設定する関数
    func setupCalendarTitleLabel() {
        self.navigationItem.title = "\(year!)年\(month!)月"
    }
    
    
    //現在（初期表示時）の年月に該当するデータを取得する関数
    func setupCurrentCalendarData() {
        
        var currentComps: DateComponents = DateComponents()
        currentComps.year  = year
        currentComps.month = month
        currentComps.day   = 1
        
        let currentDate = currentCalendar.date(from: currentComps)!
        recreateCalendarParameter(currentCalendar: currentCalendar, currentDate: currentDate)
    }
    
    
    //前の年月に該当するデータを取得する関数
    func setupPrevCalendarData() {
        
        //現在の月に対して-1をする
        if month == 0 {
            year = year - 1
            month = 12
            
        }else {
            
            month = month - 1
        }
        
        //setupCurrentCalendarData()と同様の処理を行う
        let prevCalendar: Calendar = Calendar(identifier: .gregorian)
        var prevComps: DateComponents = DateComponents()
        
        prevComps.year  = year
        prevComps.month = month
        prevComps.day   = 1
        
        let prevDate: Date = prevCalendar.date(from: prevComps)!
        recreateCalendarParameter(currentCalendar: prevCalendar, currentDate: prevDate)
    }
    
    
    //次の年月に該当するデータを取得する関数
    func setupNextCalendarData() {
        
        //現在の月に対して+1をする
        if month == 12 {
            year = year + 1
            month = 1
        }else {
            month = month + 1
        }
        
        //setupCurrentCalendarData()と同様の処理を行う
        let nextCalendar: Calendar = Calendar(identifier: .gregorian)
        var nextComps: DateComponents = DateComponents()
        
        nextComps.year  = year
        nextComps.month = month
        nextComps.day   = 1
        
        let nextDate : Date = nextCalendar.date(from: nextComps)!
        recreateCalendarParameter(currentCalendar: nextCalendar, currentDate: nextDate)
    }
    
    
    //カレンダーのパラメータを再作成する関数
    func recreateCalendarParameter(currentCalendar: Calendar, currentDate: Date) {
        
        //引数で渡されたものをもとに日付の情報を取得する
        let currentRange = currentCalendar.range(of: .day, in: .month, for: currentDate)!
        let comps = currentCalendar.dateComponents([.year, .month, .day, .weekday], from: currentDate)
        let currentMax: Int = currentRange.count
        
        year      = comps.year
        month     = comps.month
        day       = comps.day
        weekday = comps.weekday
        maxDay    = currentMax
    }
    
    
    
    //表示されているボタンオブジェクトを一旦削除する関数
    func removeCalendarButtonObject() {
        
        //ビューからボタンオブジェクトを削除する
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons.removeAll() //配列に格納したボタンオブジェクトも削除する
    }
    
    //現在のカレンダーをセットアップする関数
    func setupCurrentCalendar() {
        
        setupCurrentCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
    }
    
    
    // NSDate出してる
    //NSDate の　年と月と日を取り出したNSDate
    func day(date : NSDate) -> NSDate {
        let calendar : NSCalendar = NSCalendar.current as NSCalendar
        let dateComponents = calendar.components([.year, .month, .day], from: date as Date)
        let today = self.create(year: dateComponents.year!, month: dateComponents.month!, day: dateComponents.day!)
        return today
    }
    
    //任意の3つの整数入れたら　year　mounth day　でNSDateにする
    func create(year: Int, month: Int, day: Int) -> NSDate {
        
        let string: String = "\(year)/\(month)/\(day) 0:00:00"
        
        let formatter = DateFormatter()
        let jaLocale = Locale(identifier: "ja_JP")
        formatter.locale = jaLocale
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.date(from: string)! as NSDate
    }
    
    
    func eaqul (year: Int, month: Int, day: Int) -> NSDate {
        
        let string: String = "\(year)/\(month)/\(day) 23:59:59"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return formatter.date(from: string)! as NSDate
    }
    
    //カレンダーボタンをタップした時のアクション
    func buttonTapped(button: UIButton){
        
        day = button.tag
        self.find()
    }
    
    func find () {
        
        let query = NCMBQuery(className: "ToDoes")
        query?.whereKey("user", equalTo: NCMBUser.current())
        query?.whereKey("date", lessThanOrEqualTo : self.eaqul(year: year, month: month, day: day))
        query?.whereKey("date", greaterThan: self.create(year: year, month: month, day: day))
        query?.findObjectsInBackground { (objects, error) in
            if error != nil {
                print("nil")
            } else {
                
                self.todoes = objects as! [ToDoes]
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
    }
    
    
    //次月を表示するメソッド
    func nextCalendarSettings() {
        removeCalendarButtonObject()
        setupNextCalendarData()
        generateCalendar()
        setupCalendarTitleLabel()
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
        return todoes.count
        //これからReminderArrayを作ったら　ReminderArray.count か　それ+1
    }
    
    
    //ID付きのcellを取得してそれに付属しているlabelとかimageとか
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoTableCell", for: indexPath as IndexPath) as! TodoTableCell
        cell.todolabel.text = todoes[indexPath.row].todo
        return cell
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        NSLog("%@が選択された", todoes[indexPath.row])
        
        if tableView.allowsSelectionDuringEditing {
            print("asdfghj")
        }
    }
    
    //削除可能なcellのindexpath取得(今は全て)
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    
    //削除された時の実装
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        // 先にデータを更新する
        todoes.remove(at: indexPath.row)
        
        // それからテーブルの更新
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
    
    //cellの並べ替え
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let targetTitle = todoes[sourceIndexPath.row]
        if let index = todoes.index(of: targetTitle) {
            todoes.remove(at: index)
            todoes.insert(targetTitle, at: destinationIndexPath.row)
        }
        
    }
    
    
    //編集中以外にcellを左スワイプできない
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if tableView.isEditing {
            return UITableViewCellEditingStyle.delete
        } else {
            return UITableViewCellEditingStyle.none
        }
        
        //編集中にもcellを選択できる
        tableView.allowsSelectionDuringEditing = true
        tableView.cellForRow(at: indexPath)?.textInputMode
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
    
    
    //appボタンが押された時 → onClickが呼ばれる → tapが呼ばれる
    func tap() {
        
        let alert = UIAlertController(title: "NEW SCHEDULE", message: "予定を追加", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Done", style: .default) { (action:UIAlertAction!) -> Void in
            
            // 入力したテキストをコンソールに表示
            let textField = alert.textFields![0] as UITextField
            //self.sArray.append(textField.text!)
            self.table.reloadData()
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        // UIAlertControllerにtextFieldを追加
        alert.addTextField { (textField:UITextField!) -> Void in
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
}
