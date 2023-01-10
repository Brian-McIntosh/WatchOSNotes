//
//  Note.swift
//  WatchOSNotes Watch App
//
//  Created by Brian McIntosh on 1/9/23.
//

import Foundation

struct Note: Identifiable, Codable {
    let id: UUID
    let text: String
}
