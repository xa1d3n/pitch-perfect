//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aldin Fajic on 5/13/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    var audioPlayer : AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    var reverbPlayers:[AVAudioPlayer] = []
    let N:Int = 10
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        // initialize reverb players
        for i in 0...N {
            var temp = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
            reverbPlayers.append(temp)
        }
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* 
     Handle chipmunk/slow button
    */
    @IBAction func slow(sender: UIButton) {
        playAudio(0.5)
        
    }

    /*
     Handle rabbit/fast button
    */
    @IBAction func fast(sender: UIButton) {
        playAudio(1.5)
    }
    
    /*
        play audio
    */
    func playAudio(rate : Float) {
        // stop audio player and audio engine
        stopPlayers()
        audioEngine.stop()
        audioEngine.reset()
        
        // set rate and reset time
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    /*
        Handle stop sound button
    */
    @IBAction func stopSound(sender: UIButton) {
       stopPlayers()
    }
    
    func stopPlayers() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
        audioPlayer2.stop()
        audioPlayer2.currentTime = 0.0
        
        // stop reverb players
        for i in 0...reverbPlayers.count-1 {
            reverbPlayers[i].stop()
            reverbPlayers[i].currentTime = 0.0
        }
    }
    

    
    /*
        Handle echo sound effect. 
        http://sandmemory.blogspot.com/2014/12/how-would-you-add-reverbecho-to-audio.html
    */
    @IBAction func playEchoAudio(sender: UIButton) {
        playAudio(1.0)
        let delay:NSTimeInterval = 0.1
        var playTime:NSTimeInterval
        playTime = audioPlayer2.deviceCurrentTime + delay
        
        audioPlayer2.volume = 0.8
        audioPlayer2.playAtTime(playTime)
        
    }
    
    /*
        Handle reverb sound effect
    http://sandmemory.blogspot.com/2014/12/how-would-you-add-reverbecho-to-audio.html
    */
    @IBAction func playReverbAudio(sender: UIButton) {
        stopPlayers()
        let delay:NSTimeInterval = 0.02
        
        for i in 0...N {
            var currDelay:NSTimeInterval = delay*NSTimeInterval(i)
            var player:AVAudioPlayer = reverbPlayers[i]
            var exponent:Double = -Double(i)/Double(10/2)
            var volume = Float(pow(Double(M_E),exponent))
            player.volume = volume
            player.playAtTime(player.deviceCurrentTime+currDelay)
        }
    }
    
    func playAudioWithVariablePitch(pitch: Float) {
        // stop audio player and audio engine
        stopPlayers()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        // connect to output
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // set file to be played
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
