//
//  StatusMenuController.swift
//  SleepTimer
//
//  Created by Radomyr Sidenko on 31.12.2021.
//

import Cocoa

class StatusMenuController: NSObject {
    @IBOutlet weak var statusMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    var isShutdownAction = true
    var isRestartAction = false
    var isSleepAction = false
    
    override func awakeFromNib() {
        let icon = NSImage(named: "NSTouchBarAlarmTemplate")//statusIcon
        icon?.isTemplate = true // best for dark mode
        statusItem.image = icon
        statusItem.highlightMode = true
        statusItem.menu = statusMenu
        
    }
    
    @IBAction func about(_ sender: NSMenuItem) {
        print("Shutdown Timer Mac App\nDavid Brüggemann\n2017")
        self.showNotification(txt: "Shutdown Timer Mac App\nDavid Brüggemann\n© 2017")
    }
    
    // ###########################
    // Status menu action buttons
    // ###########################
    @IBAction func quitClicked(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    internal func showNotification(txt: String) -> Void {
        
        let notification = NSUserNotification.init()
        notification.title = "Shutdown Timer"
        notification.contentImage = NSImage(named: "NSTouchBarAlarmTemplate")
        notification.informativeText = txt
        notification.soundName = nil//NSUserNotificationDefaultSoundName
 
        NSUserNotificationCenter.default.deliver(notification)
        
    }
    
    // ###########################
    // Action settings
    // ###########################
    @IBAction func setSleepAsAction(_ sender: NSMenuItem) {
        isShutdownAction = false
        isRestartAction = false
        isSleepAction = true
        actionCommonToShutdownActionMenus(sender)
    }
    
    @IBAction func setShutdownAsAction(_ sender: NSMenuItem) {
        isShutdownAction = true
        isRestartAction = false
        isSleepAction = false
        actionCommonToShutdownActionMenus(sender)
    }
    
    @IBAction func setRestartAsAction(_ sender: NSMenuItem) {
        isShutdownAction = false
        isRestartAction = true
        isSleepAction = false
        actionCommonToShutdownActionMenus(sender)
    }
    
    @IBOutlet weak var actionSelectMenu: NSMenu!
    
    internal func actionCommonToShutdownActionMenus(_ current: NSMenuItem) {
        // Loops over the array of menu items
//        for menuItem in actionSelectMenu.items {
//            // Switches off the first (and unique) 'on' item
//            if menuItem.state == .off {
//                menuItem.state = NSOffState
//                break
//            }
//        }
        // Previous 'on' item is now 'off', time to set the current item to 'on'
//        current.state = NSOnState
    }
    
    // ###########################
    // Timer settings
    // ###########################
    @IBOutlet weak var timerMenu: NSMenu!
    
    internal func actionCommonToTimerMenus(_ current: NSMenuItem) {
        // Loops over the array of menu items
//        for menuItem in timerMenu.items {
//            // Switches off the first (and unique) 'on' item
//            if menuItem.state == NSOnState {
//                menuItem.state = NSOffState
//                break
//            }
//        }
//        // Previous 'on' item is now 'off', time to set the current item to 'on'
//        current.state = NSOnState
    }
    
    var startCounter = 60
    
    @IBAction func oneMinute(_ sender: NSMenuItem) {
        startCounter = 10
        prepareForNewTime()
        actionCommonToTimerMenus(sender)
    }
    
    @IBAction func threeMinutes(_ sender: NSMenuItem) {
        startCounter = 180
        prepareForNewTime()
        actionCommonToTimerMenus(sender)
    }
    
    @IBAction func fiveMinutes(_ sender: NSMenuItem) {
        startCounter = 300
        prepareForNewTime()
        actionCommonToTimerMenus(sender)
    }
    
    @IBAction func tenMinutes(_ sender: NSMenuItem) {
        startCounter = 600
        prepareForNewTime()
        actionCommonToTimerMenus(sender)
    }
    
    @IBAction func fifteenMinutes(_ sender: NSMenuItem) {
        startCounter = 900
        prepareForNewTime()
        actionCommonToTimerMenus(sender)
    }
    
    @IBAction func thirtyMinutes(_ sender: NSMenuItem) {
        startCounter = 1800
        prepareForNewTime()
        actionCommonToTimerMenus(sender)
    }
    
    @IBAction func oneHour(_ sender: NSMenuItem) {
        startCounter = 3600
        prepareForNewTime()
        actionCommonToTimerMenus(sender)
    }
    
    internal func prepareForNewTime(){
        timerMenuButton.title = "Start Timer"
        timer?.invalidate()
        timer = nil
        resetCounter()
    }
    
    // ###########################
    // Timer functionality
    // ###########################
    
    @IBOutlet weak var timerLable: NSMenuItem!
    @IBOutlet weak var timerMenuButton: NSMenuItem!
    
    var timer: Timer?
    var counter = 60
    
    @IBAction func startTimer(_ sender: NSMenuItem) {
        
        if timer == nil {
            timerMenuButton.title = "Stop Timer"
            
            timer = Timer.scheduledTimer(timeInterval: 1,
                                         target: self,
                                         selector: #selector(runTimedCode),
                                         userInfo: nil,
                                         repeats: true)
            RunLoop.current.add(timer!, forMode: RunLoop.Mode.common) // update Menu during timer
        } else {
            timerMenuButton.title = "Start Timer"
            timer?.invalidate()
            timer = nil
            resetCounter()
        }
        
    }
    
    @objc internal func runTimedCode() {
        counter-=1
        
        timerLable.title=String(format:"%02d:%02d:%02d", (counter/3600), (counter/60)%60, counter%60)
        
        if counter <= 0
        {
            timer?.invalidate()
            triggerShutdownAction()
        }
        
    }
    
    internal func resetCounter(){
        counter=startCounter
        
        timerLable.title=String(format:"%02d:%02d:%02d", (counter/3600), (counter/60)%60, counter%60)
    }
    // ###########################
    
    internal func triggerShutdownAction(){
        let _ = dialogOKCancel(question: "Ok?", text: "")
    }
    
    @objc func testShutdownAction() {
        var source: String?
//        playPause()
        if(isShutdownAction){
            print("isShutdownAction")
            self.showNotification(txt: "Mac shut down triggered")
            source = "tell application \"Finder\"\nshut down\nend tell"

        }
        if(isRestartAction){
            print("isRestartAction")
            self.showNotification(txt: "Mac restart triggered")
            source = "tell application \"Finder\"\nrestart\nend tell"
        }
        if(isSleepAction){
            print("isSleepAction")
            self.showNotification(txt: "Mac sleep triggered")
            source = "tell application \"Finder\"\nsleep\nend tell"
        }

        let script = NSAppleScript(source: source!)
        script?.executeAndReturnError(nil)
    }
    
//    func playPause() {
//        print("playPause")
//        let PlayPauseScript = "tell application \"Spotify\"\n playpause\n end tell"
//        if let scriptObject = NSAppleScript(source: PlayPauseScript) {
//            scriptObject.executeAndReturnError(nil)
//            print("scriptObject")
//        }
//    }
    
    func setTimer() {
        counter = 10

        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(test),
                                     userInfo: nil,
                                     repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)

        
    }
    
    @objc func test() {
        counter-=1
        
        timerLable.title=String(format:"%02d:%02d:%02d", (counter/3600), (counter/60)%60, counter%60)
        
        if counter <= 0
        {
            timer?.invalidate()
            testShutdownAction()
//            NSApplication.shared.terminate(self)
        }
    }
    
    
    func dialogOKCancel(question: String, text: String) -> Bool {
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = text
        alert.alertStyle = .warning
        
        
        alert.addButton(withTitle: "Cancel")
        setTimer()
        
        let modalResult = alert.runModal()
        switch modalResult {
        case .alertFirstButtonReturn: // NSApplication.ModalResponse.alertFirstButtonReturn
            timer?.invalidate()
            timer = nil
            resetCounter()
        default:
            print("Fourth button clicked")
        }
        
        return modalResult == .alertFirstButtonReturn
    }
}
