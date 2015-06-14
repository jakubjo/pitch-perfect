//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jakub on 09.06.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.stopButton.hidden = true;
        self.recordButton.enabled = true;
        self.alterUIForRecording(recording: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func alterUIForRecording(recording: Bool = true) {
        if (recording) {
            self.recordLabel.text = "Recording in progress, speak now"
            self.stopButton.hidden = false
            self.recordButton.enabled = false
        } else {
            self.recordLabel.text = "Tap to record"
            self.stopButton.hidden = true
            self.recordButton.enabled = true
        }
    }


    @IBAction func recordAudio(sender: UIButton) {
        self.alterUIForRecording(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let filePath = NSURL.fileURLWithPathComponents([dirPath, "recorded_audio.wav"])
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        self.audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        self.audioRecorder.delegate = self
        self.audioRecorder.meteringEnabled = true
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
    }
        
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            self.recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        } else {
            println("Recording was not successful")
        }
        
        self.alterUIForRecording(recording: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func stopButtonAction(sender: UIButton) {
        self.audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(false, error: nil)
    }
    
}


