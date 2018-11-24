//
//  AudioHelper.swift
//  talkingSauna
//
//  Created by Kirill Averyanov on 11/24/18.
//  Copyright © 2018 Kirill Averyanov. All rights reserved.
//

import AVFoundation

class AudioHelper {
  static func playText(string: String) {
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                      mode: .default)
    }
    catch {
    }
    let utterance = AVSpeechUtterance(string: string)
    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
    
    let synth = AVSpeechSynthesizer()
    synth.speak(utterance)
  }
}
