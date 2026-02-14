import Foundation
import SwiftData
import SwiftUI

enum TransactionType: String, Codable, CaseIterable {
    case income
    case expense
}

enum Mood: String, Codable, CaseIterable {
    case regretlessJoy
    case impulseTax
    case revengeSpending
    case sad // Adding a few generic ones for completeness if needed
    case neutral
    case happy
    
    var title: String {
        switch self {
        case .regretlessJoy: return "Regretless Joy"
        case .impulseTax: return "Impulse Tax"
        case .revengeSpending: return "Revenge Spending"
        case .sad: return "Sad Spending"
        case .neutral: return "Meh"
        case .happy: return "Happy"
        }
    }
    
    var emoji: String {
        switch self {
        case .regretlessJoy: return "🥳"
        case .impulseTax: return "🤡"
        case .revengeSpending: return "😤"
        case .sad: return "😢"
        case .neutral: return "😐"
        case .happy: return "😀"
        }
    }
    
    var colorHex: String {
        switch self {
        case .regretlessJoy: return "FFE600" // Yellow
        case .impulseTax: return "A020F0" // Purple
        case .revengeSpending: return "FF0000" // Red
        case .sad: return "0000FF"
        case .neutral: return "808080"
        case .happy: return "00FF00"
        }
    }
    
    // Score for "Happiness ROI" (1-5)
    var score: Int {
        switch self {
        case .regretlessJoy: return 5
        case .happy: return 4
        case .neutral: return 3
        case .impulseTax: return 2
        case .revengeSpending: return 1
        case .sad: return 1
        }
    }
}

@Model
final class Transaction {
    var id: UUID
    var amount: Double
    var typeRawValue: String
    var category: String
    var moodRawValue: String
    var date: Date
    var note: String
    
    @Transient
    var type: TransactionType {
        get { TransactionType(rawValue: typeRawValue) ?? .expense }
        set { typeRawValue = newValue.rawValue }
    }
    
    @Transient
    var mood: Mood {
        get { Mood(rawValue: moodRawValue) ?? .neutral }
        set { moodRawValue = newValue.rawValue }
    }
    
    init(amount: Double, type: TransactionType, category: String, mood: Mood, date: Date = Date(), note: String = "") {
        self.id = UUID()
        self.amount = amount
        self.typeRawValue = type.rawValue
        self.category = category
        self.moodRawValue = mood.rawValue
        self.date = date
        self.note = note
    }
}
