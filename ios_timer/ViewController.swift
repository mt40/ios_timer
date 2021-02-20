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
  var maxSeconds = 60
  
  var alarmPlayer: AVAudioPlayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    do {
      let audioData = NSDataAsset(name: "maruko.mp3")!.data
      alarmPlayer = try AVAudioPlayer(data: audioData)
    } catch {
      print("cannot load alarm sound, error: \(error)")
    }
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
  
}

