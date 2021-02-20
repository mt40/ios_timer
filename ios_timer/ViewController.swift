//
//  ViewController.swift
//  ios_timer
//
//  Created by Thai Minh on 20/02/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
  @IBOutlet var timeLabel: UILabel!
  
  var timer: Timer?
  var elapsedSeconds = 0
  var maxSeconds: Int = 60
  
  var alarmPlayer: AVAudioPlayer?
  let notificationId = UUID().uuidString
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      let audioData = NSDataAsset(name: "maruko.mp3")!.data
      alarmPlayer = try AVAudioPlayer(data: audioData)
    } catch {
      print("cannot load alarm sound, error: \(error)")
    }
    
    let center = UNUserNotificationCenter.current()
    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
      
      if let error = error {
        print(error)
      }
    }
    print("noti id: \(notificationId)")
  }
  
  @objc func timerCallback() {
    elapsedSeconds += 1
    updateUI()
    
    if elapsedSeconds >= maxSeconds {
      timer?.invalidate()
      playSound()
    }
  }
  
  @IBAction func startTimer10sBtnClicked(_ sender: UIButton) {
    startTimerFor(seconds: 10)
  }
  
  @IBAction func startTimer1mBtnClicked(_ sender: UIButton) {
    startTimerFor(seconds: 60)
  }
  
  @IBAction func startTimer5mBtnClicked(_ sender: UIButton) {
    startTimerFor(seconds: 5 * 60)
  }
  
  @IBAction func startTimer15mBtnClicked(_ sender: UIButton) {
    startTimerFor(seconds: 5 * 60)
  }
  
  @IBAction func stopTimerBtnClicked(_ sender: UIButton) {
    print("stop timer")
    resetTimer()
  }
  
  func startTimerFor(seconds: Int) {
    maxSeconds = seconds
    print("start timer for \(maxSeconds) seconds")
    
    resetTimer()
    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.timerCallback), userInfo: nil, repeats: true)
    createNotification()
  }
  
  func updateUI() {
    timeLabel.text = "\(elapsedSeconds)"
  }
  
  func resetTimer() {
    elapsedSeconds = 0
    updateUI()
    timer?.invalidate()
    alarmPlayer?.stop()
  }
  
  func playSound() {
    alarmPlayer?.currentTime = 0
    alarmPlayer?.play()
  }
  
  func createNotification() {
    let currentDate = Date()
    
    let content = UNMutableNotificationContent()
    content.title = "Time up!"
    content.body = "\(maxSeconds) seconds have passed since \(currentDate.description(with: Locale.current))"
    // for simplicity, we play the default sound but we can actually
    // use any sound here
    content.sound = UNNotificationSound.default
    
    let triggerDate = currentDate.addingTimeInterval( TimeInterval(maxSeconds))
    var dateComps = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)
    dateComps.timeZone = Calendar.current.timeZone
    print("will notify user at \(dateComps)")
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComps, repeats: false)

    // Create the request
    let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)

    // Schedule the request with the system.
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.add(request) { (error) in
      if error != nil {
        // Handle any errors.
        print("cannot add notification")
      }
    }
  }
  
}

