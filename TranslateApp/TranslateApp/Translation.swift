//
//  Translation.swift
//  TranslateApp
//
//  Created by Abhijeet Cherungottil on 11/2/25.
//

import Foundation
import FirebaseFirestore

struct Translation: Identifiable, Codable {
    @DocumentID var id: String?
    var original: String
    var translated: String
    var sourceLang: String
    var targetLang: String
    var timestamp: Date = Date()
}
