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
        
        player = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        player.enableRate = true
        player.volume = 1.0
        player.delegate = self
        
        audioEngine = AVAudioEngine()
        avAudioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }
 
    func stopAllAudio() {
        player.stop()
        audioEngine.stop()
    }
    
    func resetAllButtons() {
        snailButton.enabled = true
        rabbitButton.enabled = true
        //chipMunkButton.enabled = true
        //darthVaderButton.enabled = true
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        resetAllButtons()
    }
    
    func playAudio(fast:Bool = false) {
        stopAllAudio()
        player.rate = (fast) ? 2 : 0.5
        player.currentTime = 0
        player.play()
    }

    @IBAction func playSlowAction(sender: UIButton) {
        resetAllButtons()
        snailButton.enabled = false
        playAudio()
    }
    
    @IBAction func playFastAction(sender: UIButton) {
        resetAllButtons()
        rabbitButton.enabled = false
        playAudio(fast: true)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        //chipMunkButton.enabled = false
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        //darthVaderButton.enabled = false
        playAudioWithVariablePitch(-1000)
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        stopAllAudio()
        resetAllButtons()
        
        audioEngine.reset()
        
        var playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        var timePitch = AVAudioUnitTimePitch()
        timePitch.pitch = pitch
        audioEngine.attachNode(timePitch)
        
        audioEngine.connect(playerNode, to: timePitch, format: nil)
        audioEngine.connect(timePitch, to: audioEngine.outputNode, format: nil)
        
        audioEngine.startAndReturnError(nil)
        
        /*
            TODO: Implement a delegate method which should be invoked when AVAudioEngine or AVAudioPlayerNode finishes playing
                  Dear code reviewer, maybe you're aware of the desired completion handler or delegate?
        */
        
        playerNode.scheduleFile(avAudioFile, atTime: nil, completionHandler:{() -> Void in
            // This does not work as expected: this completion handler is obviously called when the file is successfuly queued.
            //self.resetAllButtons()
        })
        
        playerNode.play()
    }
    
    @IBAction func stopAllAudioAction(sender: UIButton) {
        stopAllAudio()
        resetAllButtons()
    }
}
