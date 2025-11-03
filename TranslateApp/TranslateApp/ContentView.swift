//
//  ContentView.swift
//  TranslateApp
//
//  Created by Abhijeet Cherungottil on 11/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var historyManager = TranslationHistoryManager()
    @StateObject private var voiceService = VoiceService()
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var sourceLang: String = "en"
    @State private var targetLang: String = "es"
    @State private var isTranslating = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    private let translationService = TranslationService()

    // A small list of languages for the picker (expand as needed)
    private let languages: [(code: String, name: String)] = [
        ("auto", "Auto Detect"), // MyMemory doesn't support auto detect in pairs; keep for UI
        ("en", "English"),
        ("es", "Spanish"),
        ("fr", "French"),
        ("de", "German"),
        ("it", "Italian"),
        ("hi", "Hindi"),
        ("zh", "Chinese"),
        ("pt", "Portuguese")
    ]

    var body: some View {
        let _ = print("🖼️ [ContentView] Rendering body")
        let _ = print("📊 [ContentView] State - inputText: '\(inputText)', translatedText: '\(translatedText)'")
        let _ = print("🌍 [ContentView] State - sourceLang: \(sourceLang), targetLang: \(targetLang)")
        let _ = print("⏳ [ContentView] State - isTranslating: \(isTranslating)")
        let _ = print("📚 [ContentView] History count: \(historyManager.history.count)")
        
        return NavigationView {
            VStack(spacing: 12) {
                // Input
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        TextEditor(text: $inputText)
                            .frame(height: 100)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.secondary.opacity(0.3)))
                        if !inputText.isEmpty {
                            Button {
                                voiceService.speak(inputText, language: sourceLang)
                            } label: {
                                Image(systemName: voiceService.isSpeaking && voiceService.currentSpeakingText == inputText ? "stop.circle.fill" : "speaker.wave.2.fill")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                            .padding(.leading, 4)
                        }
                    }
                }
                .padding(.horizontal)
                .onChange(of: inputText) { oldValue, newValue in
                    print("📝 [ContentView] Input text changed: '\(oldValue)' → '\(newValue)' (length: \(newValue.count))")
                }

                // Language pickers
                HStack {
                    VStack(alignment: .leading) {
                        Text("From")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Picker("From", selection: $sourceLang) {
                            ForEach(languages, id: \.code) { lang in
                                Text(lang.name).tag(lang.code)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: sourceLang) { oldValue, newValue in
                            print("🌍 [ContentView] Source language changed: \(oldValue) → \(newValue)")
                        }
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("To")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Picker("To", selection: $targetLang) {
                            ForEach(languages.filter {$0.code != "auto"}, id: \.code) { lang in
                                Text(lang.name).tag(lang.code)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .onChange(of: targetLang) { oldValue, newValue in
                            print("🌍 [ContentView] Target language changed: \(oldValue) → \(newValue)")
                        }
                    }
                }
                .padding(.horizontal)

                // Translate button
                Button {
                    translateTapped()
                } label: {
                    HStack {
                        if isTranslating {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                        }
                        Text(isTranslating ? "Translating…" : "Translate")
                            .bold()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                }
                .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isTranslating)
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)

                // Result
                GroupBox {
                    HStack(alignment: .top, spacing: 8) {
                        VStack(alignment: .leading, spacing: 8) {
                            if translatedText.isEmpty {
                                Text("Translated text will appear here")
                                    .foregroundColor(.secondary)
                            } else {
                                Text(translatedText)
                                    .font(.body)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        Spacer()
                        if !translatedText.isEmpty {
                            Button {
                                if voiceService.isSpeaking && voiceService.currentSpeakingText == translatedText {
                                    voiceService.stop()
                                } else {
                                    voiceService.speak(translatedText, language: targetLang)
                                }
                            } label: {
                                Image(systemName: voiceService.isSpeaking && voiceService.currentSpeakingText == translatedText ? "stop.circle.fill" : "speaker.wave.2.fill")
                                    .foregroundColor(.blue)
                                    .font(.title2)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                .padding(.horizontal)

                // History header
                HStack {
                    Text("History")
                        .font(.headline)
                    Spacer()
                    Button(role: .destructive) {
                        print("🗑️ [ContentView] Clear history button tapped")
                        historyManager.clearHistory { result in
                            switch result {
                            case .success():
                                print("✅ [ContentView] History cleared successfully")
                            case .failure(let err):
                                print("❌ [ContentView] Failed to clear history: \(err.localizedDescription)")
                                errorMessage = "Could not clear history: \(err.localizedDescription)"
                                showErrorAlert = true
                            }
                        }
                    } label: {
                        Text("Clear")
                    }
                }
                .padding(.horizontal)

                // History list
                ScrollView {
                    LazyVStack(spacing: 10) {
                        if historyManager.history.isEmpty {
                            Text("No history yet. Your translations will appear here.")
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity)
                        } else {
                            ForEach(historyManager.history) { item in
                                HistoryRow(item: item, voiceService: voiceService)
                                    .contextMenu {
                                        Button("Copy Original") {
                                            UIPasteboard.general.string = item.original
                                        }
                                        Button("Copy Translation") {
                                            UIPasteboard.general.string = item.translated
                                        }
                                        Button("Speak Translation") {
                                            voiceService.speak(item.translated, language: item.targetLang)
                                        }
                                    }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .frame(minHeight: 0)
            }
            .navigationTitle("TranslationMe")
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }

    private func translateTapped() {
        print("🔘 [ContentView] Translate button tapped")
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        print("📝 [ContentView] Trimmed input: '\(trimmed)' (length: \(trimmed.count))")
        
        guard !trimmed.isEmpty else {
            print("⚠️ [ContentView] Input is empty, ignoring translation request")
            return
        }
        
        // MyMemory wants explicit language pairs; avoid "auto" for source
        let src = sourceLang == "auto" ? "en" : sourceLang
        print("🌍 [ContentView] Using source language: \(src) (original selection: \(sourceLang))")
        print("🌍 [ContentView] Target language: \(targetLang)")
        
        isTranslating = true
        print("⏳ [ContentView] Translation started, setting isTranslating = true")
        
        Task {
            print("🚀 [ContentView] Translation task started")
            do {
                let result = try await translationService.translate(text: trimmed, from: src, to: targetLang)
                print("✅ [ContentView] Translation result received: '\(result)'")
                
                await MainActor.run {
                    print("🔄 [ContentView] Updating UI on main actor...")
                    translatedText = result
                    print("📝 [ContentView] Setting translatedText to: '\(translatedText)'")
                    
                    let saved = Translation(original: trimmed,
                                            translated: result,
                                            sourceLang: src,
                                            targetLang: targetLang,
                                            timestamp: Date())
                    print("💾 [ContentView] Creating Translation object:")
                    print("   - Original: '\(saved.original)'")
                    print("   - Translated: '\(saved.translated)'")
                    print("   - Source: \(saved.sourceLang) → Target: \(saved.targetLang)")
                    print("   - Timestamp: \(saved.timestamp)")
                    
                    print("💾 [ContentView] Saving translation to history...")
                    historyManager.saveTranslation(saved)
                    
                    isTranslating = false
                    print("✅ [ContentView] Translation complete, setting isTranslating = false")
                }
            } catch {
                print("❌ [ContentView] Translation failed with error")
                print("📋 [ContentView] Error: \(error.localizedDescription)")
                print("📋 [ContentView] Error details: \(error)")
                
                await MainActor.run {
                    errorMessage = "Translation failed: \(error.localizedDescription)"
                    showErrorAlert = true
                    isTranslating = false
                    print("⚠️ [ContentView] Error alert will be shown to user")
                }
            }
        }
    }
}

struct HistoryRow: View {
    let item: Translation
    @ObservedObject var voiceService: VoiceService
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(item.original)
                    .font(.body)
                    .lineLimit(nil)
                Spacer()
                Text(shortDate(item.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            HStack {
                Image(systemName: "arrow.right.circle")
                Text(item.translated)
                    .foregroundColor(.primary)
                Spacer()
                Button {
                    if voiceService.isSpeaking && voiceService.currentSpeakingText == item.translated {
                        voiceService.stop()
                    } else {
                        voiceService.speak(item.translated, language: item.targetLang)
                    }
                } label: {
                    Image(systemName: voiceService.isSpeaking && voiceService.currentSpeakingText == item.translated ? "stop.circle.fill" : "speaker.wave.2.fill")
                        .foregroundColor(.blue)
                        .font(.caption)
                }
                Text("\(item.sourceLang.uppercased())→\(item.targetLang.uppercased())")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(10)
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(8)
    }

    private func shortDate(_ date: Date) -> String {
        let f = DateFormatter()
        f.dateStyle = .short
        f.timeStyle = .short
        return f.string(from: date)
    }
}


#Preview {
    ContentView()
}
