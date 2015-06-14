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
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stopButton.hidden = true;
        recordButton.enabled = true;
        alterUIForRecording(recording: false)
    }
    
    func alterUIForRecording(recording: Bool = true) {
        if (recording) {
            recordLabel.text = "Recording in progress, speak now"
            stopButton.hidden = false
            recordButton.enabled = false
        } else {
            recordLabel.text = "Tap to record"
            stopButton.hidden = true
            recordButton.enabled = true
        }
    }


    @IBAction func recordAudio(sender: UIButton) {
        alterUIForRecording(recording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let filePath = NSURL.fileURLWithPathComponents([dirPath, "recorded_audio.wav"])
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
        
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            recordedAudio = RecordedAudio(url: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        } else {
            println("Recording was not successful")
        }
        
        alterUIForRecording(recording: false)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    
    
    @IBAction func stopButtonAction(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayback, error: nil)
        audioSession.setActive(false, error: nil)
    }
    
}


