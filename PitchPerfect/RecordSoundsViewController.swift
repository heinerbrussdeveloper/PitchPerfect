//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Heiner Bruß on 15.01.20.
//  Copyright © 2020 Heiner Bruß. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: -  Class that records Audio

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    // MARK: Outlets to the different Buttons and Labels
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    // MARK: Setting up all Buttons
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtons(recording: false)
    }
    
    // MARK: - Recording the Audio
    
    @IBAction func recordAudio(_ sender: UIButton) {
        setButtons(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: Stopping the Recording
    @IBAction func stopRecording(_ sender: UIButton) {
        setButtons(recording: false)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Performing Segue sending Audio File to SecondVC
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag { performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            recordingLabel.text = "Recording was not successful"
        }
    }
    
    // MARK: Preparing Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: Setting up all buttons in the Code
    
    func setButtons(recording: Bool) {
        if recording {
            stopRecordingButton.isEnabled = true
            recordingLabel.text = "Recording in Progress"
            recordButton.isEnabled = false
        } else {
            recordButton.isEnabled = true
            stopRecordingButton.isEnabled = false
            recordingLabel.text = "Tap to Record"
        }
    }
}

