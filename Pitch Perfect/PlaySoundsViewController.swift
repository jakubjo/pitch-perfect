//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jakub on 12.06.15.
//  Copyright (c) 2015 Jakub Jozefek. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    
    var player:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var avAudioFile:AVAudioFile!
    
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var chipMunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        self.player.enableRate = true
        self.player.volume = 1.0
        self.player.delegate = self
        
        self.audioEngine = AVAudioEngine()
        self.avAudioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func stopAllAudio() {
        self.player.stop()
        self.audioEngine.stop()
    }
    
    func resetAllButtons() {
        self.snailButton.enabled = true
        self.rabbitButton.enabled = true
        //self.chipMunkButton.enabled = true
        //self.darthVaderButton.enabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.resetAllButtons()
    }
    
    func playAudio(fast:Bool = false) {
        self.stopAllAudio()
        self.player.rate = (fast) ? 2 : 0.5
        self.player.currentTime = 0
        self.player.play()
    }

    @IBAction func playSlowAction(sender: UIButton) {
        self.resetAllButtons()
        self.snailButton.enabled = false
        self.playAudio()
    }
    
    @IBAction func playFastAction(sender: UIButton) {
        self.resetAllButtons()
        self.rabbitButton.enabled = false
        self.playAudio(fast: true)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //self.chipMunkButton.enabled = false
        self.playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        //self.darthVaderButton.enabled = false
        self.playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        self.stopAllAudio()
        self.resetAllButtons()
        
        self.audioEngine.reset()
        
        var playerNode = AVAudioPlayerNode()
        self.audioEngine.attachNode(playerNode)
        
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        self.audioEngine.attachNode(timePitch)
        
        self.audioEngine.connect(playerNode, to: timePitch, format: nil)
        self.audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        self.audioEngine.startAndReturnError(nil)
        
        /*
            TODO: Implement a delegate method which should be invoked when AVAudioEngine or AVAudioPlayerNode finishes playing
                  Dear code reviewer, maybe you're aware of the desired completion handler or delegate?
        */
        
        playerNode.scheduleFile(self.avAudioFile, atTime: nil, completionHandler:{() -> Void in
            // This does not work as expected: this completion handler is obviously called when the file is successfuly queued.
            //self.resetAllButtons()
        })
        
        playerNode.play()
    }
    
    @IBAction func stopAllAudioAction(sender: UIButton) {
        self.stopAllAudio()
        self.resetAllButtons()
    }
}
