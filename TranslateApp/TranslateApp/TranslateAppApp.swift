//
//  TranslateAppApp.swift
//  TranslateApp
//
//  Created by Abhijeet Cherungottil on 11/2/25.
//

import SwiftUI
import FirebaseCore

@main
struct TranslateAppApp: App {
    init() {
        print("🚀 [TranslateAppApp] App initializing...")
        print("🔥 [TranslateAppApp] Configuring Firebase...")
        FirebaseApp.configure()
        
        if let app = FirebaseApp.app() {
            print("✅ [TranslateAppApp] Firebase configured successfully")
            print("📋 [TranslateAppApp] Project ID: \(app.options.projectID ?? "unknown")")
            print("📋 [TranslateAppApp] Bundle ID: \(app.options.bundleID ?? "unknown")")
        } else {
            print("❌ [TranslateAppApp] ERROR: Firebase configuration failed!")
        }
        
        print("✅ [TranslateAppApp] App initialization complete")
    }
    
    var body: some Scene {
        let _ = print("🖼️ [TranslateAppApp] Creating window group scene...")
        return WindowGroup {
            ContentView()
        }
    }
}
