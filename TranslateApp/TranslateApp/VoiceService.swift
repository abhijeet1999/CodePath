//
//  VoiceService.swift
//  TranslateApp
//
//  Created by Abhijeet Cherungottil on 11/2/25.
//

import Foundation
import AVFoundation

final class VoiceService: NSObject, ObservableObject {
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    @Published var currentUtterance: AVSpeechUtterance?
    @Published var currentSpeakingText: String? // Track the text being spoken
    
    override init() {
        super.init()
        synthesizer.delegate = self
        print("🔊 [VoiceService] Initialized")
    }
    
    /// Speak the given text in the specified language
    func speak(_ text: String, language: String) {
        print("🔊 [VoiceService] Speaking text: '\(text)'")
        print("🌍 [VoiceService] Language: \(language)")
        
        // Stop any current speech
        if synthesizer.isSpeaking {
            print("⏹️ [VoiceService] Stopping current speech")
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        
        // Map language codes to AVSpeechSynthesisVoice language codes
        let voiceLanguage = mapLanguageCode(language)
        utterance.voice = AVSpeechSynthesisVoice(language: voiceLanguage)
        
        // Configure speech rate and pitch
        utterance.rate = 0.5 // Normal speaking rate (0.0 to 1.0)
        utterance.pitchMultiplier = 1.0 // Normal pitch
        utterance.volume = 1.0 // Maximum volume
        
        print("🔊 [VoiceService] Using voice language: \(voiceLanguage)")
        print("🔊 [VoiceService] Available voices: \(AVSpeechSynthesisVoice.speechVoices().map { $0.language })")
        
        currentUtterance = utterance
        currentSpeakingText = text
        synthesizer.speak(utterance)
        isSpeaking = true
        
        print("✅ [VoiceService] Speech started")
    }
    
    /// Stop speaking
    func stop() {
        print("⏹️ [VoiceService] Stopping speech")
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
        currentSpeakingText = nil
    }
    
    /// Map our language codes to AVSpeechSynthesisVoice language codes
    private func mapLanguageCode(_ code: String) -> String {
        let mapping: [String: String] = [
            "en": "en-US",
            "es": "es-ES",
            "fr": "fr-FR",
            "de": "de-DE",
            "it": "it-IT",
            "hi": "hi-IN",
            "zh": "zh-CN",
            "pt": "pt-BR",
            "auto": "en-US" // Default to English if auto
        ]
        
        return mapping[code] ?? code
    }
}

// MARK: - AVSpeechSynthesizerDelegate
extension VoiceService: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        print("▶️ [VoiceService] Speech started")
        DispatchQueue.main.async {
            self.isSpeaking = true
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        print("✅ [VoiceService] Speech finished")
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentUtterance = nil
            self.currentSpeakingText = nil
        }
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        print("⏹️ [VoiceService] Speech cancelled")
        DispatchQueue.main.async {
            self.isSpeaking = false
            self.currentUtterance = nil
            self.currentSpeakingText = nil
        }
    }
}

