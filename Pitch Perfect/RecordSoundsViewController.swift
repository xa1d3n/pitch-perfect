//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Aldin Fajic on 5/12/15.
//  Copyright (c) 2015 Aldin Fajic. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    @IBAction func recordAudio(sender: UIButton) {
        // set hide/enable settings for buttons
        recordLabel.hidden = true
        recordButton.enabled = false
        stopButton.hidden = false
        resumeButton.hidden = false
        pauseButton.hidden = false
        resumeButton.enabled = false
        pauseButton.enabled = true
        
        // get directory path
        if let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as?  String {
            // get current date time
            let currentDateTime = NSDate()
            // format date time
            let formatter = NSDateFormatter()
            formatter.dateFormat = "ddMMyyyy-HHmmss"
            // set name of audio recording
            let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
            // array containing directory path and name of recording
            let pathArray = [dirPath, recordingName]
            // set file path
            let filePath = NSURL.fileURLWithPathComponents(pathArray)
            println(filePath)
            
            // setup audio session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            // intialize and prepare the recorder
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            // set delegate
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        else {
            println("could not locate directory path")
        }
        
        
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        // check if successfully recorded
        if (flag) {
            recordedAudio = RecordedAudio(filePathUrl: recorder.url, title: recorder.url.lastPathComponent!)
            
            // pass data to next view
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // check identifier of view
        if (segue.identifier == "stopRecording") {
            // destinatino segue
            if let playSoundsVS:PlaySoundsViewController = segue.destinationViewController as? PlaySoundsViewController {
                // data being passed
                if let data = sender as? RecordedAudio {
                    // pass the data
                    playSoundsVS.receivedAudio = data
                }
                else {
                    println("failed to get recorded data")
                }
            }
            else {
                println("failed to segue")
            }
            
            
        }
    }
    
    /*
        Handle stop recording button
    */
    @IBAction func stop(sender: UIButton) {
        recordLabel.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
     
    }
    
    /*
        Handle pause recording button
    */
    @IBAction func pauseRecording(sender: UIButton) {
        sender.enabled = false
        resumeButton.enabled = true
        audioRecorder.pause()
    }
    
    /*
    Handle resume recording button
    */
    @IBAction func resumeRecording(sender: UIButton) {
        sender.enabled = false
        pauseButton.enabled = true
        audioRecorder.record()
    }
    
    @IBOutlet var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        recordLabel.hidden = false
        stopButton.hidden = true
        recordButton.enabled = true
        resumeButton.hidden = true
        pauseButton.hidden = true
        
    }


}

