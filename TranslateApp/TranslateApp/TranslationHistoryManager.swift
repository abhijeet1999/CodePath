//
//  TranslationHistoryManager.swift
//  TranslateApp
//
//  Created by Abhijeet Cherungottil on 11/2/25.
//

import Foundation
import FirebaseFirestore
import FirebaseCore
import Combine

final class TranslationHistoryManager: ObservableObject {
    private let db = Firestore.firestore()
    @Published var history: [Translation] = []
    private var listener: ListenerRegistration?

    init() {
        print("🔥 [TranslationHistoryManager] Initializing...")
        
        // Enable offline persistence (optional — Firestore enables by default in mobile SDK)
        print("💾 [TranslationHistoryManager] Configuring Firestore settings...")
        let settings = db.settings
        settings.isPersistenceEnabled = true
        db.settings = settings
        print("✅ [TranslationHistoryManager] Offline persistence enabled")
        
        // Verify Firebase is configured
        if FirebaseApp.app() == nil {
            print("❌ [TranslationHistoryManager] ERROR: Firebase is not configured!")
            return
        }
        
        let projectID = db.app.options.projectID ?? "unknown"
        print("🔥 [TranslationHistoryManager] Firestore initialized for project: \(projectID)")
        print("📁 [TranslationHistoryManager] Will use collection: 'translations'")
        
        startListening()
    }

    deinit {
        print("🔌 [TranslationHistoryManager] Deinitializing, removing listener...")
        listener?.remove()
        print("✅ [TranslationHistoryManager] Listener removed")
    }

    /// Save a translation to Firestore
    func saveTranslation(_ translation: Translation) {
        print("💾 [TranslationHistoryManager] Attempting to save translation...")
        print("📝 [TranslationHistoryManager] Translation details:")
        print("   - Original: '\(translation.original)'")
        print("   - Translated: '\(translation.translated)'")
        print("   - Source Lang: \(translation.sourceLang)")
        print("   - Target Lang: \(translation.targetLang)")
        print("   - Timestamp: \(translation.timestamp)")
        print("   - ID: \(translation.id ?? "nil")")
        
        do {
            let docRef = try db.collection("translations").addDocument(from: translation)
            print("✅ [TranslationHistoryManager] Translation saved successfully!")
            print("📄 [TranslationHistoryManager] Document ID: \(docRef.documentID)")
            print("📁 [TranslationHistoryManager] Collection path: translations/\(docRef.documentID)")
        } catch {
            print("❌ [TranslationHistoryManager] ERROR saving translation to Firestore")
            print("📋 [TranslationHistoryManager] Error: \(error.localizedDescription)")
            print("📋 [TranslationHistoryManager] Error details: \(error)")
            print("⚠️ [TranslationHistoryManager] Troubleshooting:")
            print("   1. Firestore database must be created in Firebase Console")
            print("   2. Security rules must allow write access")
            print("   3. Check Firebase project configuration")
        }
    }

    /// Remove all translation documents (simple approach: fetch & delete)
    func clearHistory(completion: ((Result<Void, Error>) -> Void)? = nil) {
        print("🗑️ [TranslationHistoryManager] Clearing history...")
        print("📊 [TranslationHistoryManager] Current history count: \(history.count)")
        
        db.collection("translations").getDocuments { snapshot, error in
            if let error = error {
                print("❌ [TranslationHistoryManager] ERROR fetching documents for clear: \(error.localizedDescription)")
                completion?(.failure(error))
                return
            }
            guard let docs = snapshot?.documents else {
                print("✅ [TranslationHistoryManager] No documents to delete")
                completion?(.success(()))
                return
            }
            
            print("📦 [TranslationHistoryManager] Found \(docs.count) documents to delete")
            let batch = self.db.batch()
            docs.forEach { doc in
                print("   - Deleting document: \(doc.documentID)")
                batch.deleteDocument(doc.reference)
            }
            
            print("💾 [TranslationHistoryManager] Committing batch delete...")
            batch.commit { err in
                if let err = err {
                    print("❌ [TranslationHistoryManager] ERROR committing batch delete: \(err.localizedDescription)")
                    completion?(.failure(err))
                } else {
                    print("✅ [TranslationHistoryManager] History cleared successfully (\(docs.count) documents)")
                    completion?(.success(()))
                }
            }
        }
    }

    /// Start listening to Firestore collection and keep `history` updated
    private func startListening() {
        print("👂 [TranslationHistoryManager] Starting Firestore listener...")
        print("📁 [TranslationHistoryManager] Listening to collection: 'translations'")
        print("📊 [TranslationHistoryManager] Ordering by: timestamp (descending)")
        
        listener = db.collection("translations")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else {
                    print("⚠️ [TranslationHistoryManager] Self is nil in listener callback")
                    return
                }
                
                if let error = error {
                    let nsError = error as NSError
                    print("❌ [TranslationHistoryManager] Listener error: \(error.localizedDescription)")
                    print("📋 [TranslationHistoryManager] Error domain: \(nsError.domain)")
                    print("📋 [TranslationHistoryManager] Error code: \(nsError.code)")
                    
                    // Check for permission errors specifically
                    if nsError.domain == "FIRFirestoreErrorDomain" && nsError.code == 7 {
                        print("⚠️ [TranslationHistoryManager] PERMISSION ERROR DETECTED!")
                        print("📝 [TranslationHistoryManager] Update Firestore security rules in Firebase Console")
                        print("🔗 [TranslationHistoryManager] Go to: Firestore Database → Rules")
                        print("📋 [TranslationHistoryManager] Add rule: allow read, write: if true; (for development)")
                    }
                    
                    print("💾 [TranslationHistoryManager] Attempting to fetch from cache...")
                    self.fetchFromCache()
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("📭 [TranslationHistoryManager] Snapshot has no documents, clearing history")
                    self.history = []
                    return
                }
                
                print("📦 [TranslationHistoryManager] Received \(documents.count) documents from listener")
                print("🔄 [TranslationHistoryManager] Updating history...")
                
                let previousCount = self.history.count
                self.history = documents.compactMap { doc in
                    do {
                        let translation = try doc.data(as: Translation.self)
                        print("   ✓ Parsed document: \(doc.documentID) - '\(translation.original)' → '\(translation.translated)'")
                        return translation
                    } catch {
                        print("   ✗ Failed to parse document \(doc.documentID): \(error)")
                        return nil
                    }
                }
                
                print("✅ [TranslationHistoryManager] History updated: \(previousCount) → \(self.history.count) items")
            }
        
        print("✅ [TranslationHistoryManager] Listener started successfully")
    }
    
    /// Fetch translations from cache as fallback
    private func fetchFromCache() {
        print("💾 [TranslationHistoryManager] Fetching from cache...")
        db.collection("translations")
            .order(by: "timestamp", descending: true)
            .getDocuments(source: .cache) { [weak self] snapshot, error in
                guard let self = self else {
                    print("⚠️ [TranslationHistoryManager] Self is nil in cache fetch callback")
                    return
                }
                
                if let error = error {
                    print("❌ [TranslationHistoryManager] Cache fetch error: \(error.localizedDescription)")
                    print("📋 [TranslationHistoryManager] Cache fetch error details: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("📭 [TranslationHistoryManager] Cache has no documents, clearing history")
                    self.history = []
                    return
                }
                
                print("💾 [TranslationHistoryManager] Cache fetch successful: \(documents.count) documents")
                let previousCount = self.history.count
                
                self.history = documents.compactMap { doc in
                    do {
                        return try doc.data(as: Translation.self)
                    } catch {
                        print("   ✗ Failed to parse cached document \(doc.documentID): \(error)")
                        return nil
                    }
                }
                
                print("✅ [TranslationHistoryManager] Cache loaded: \(previousCount) → \(self.history.count) items")
            }
    }
}
