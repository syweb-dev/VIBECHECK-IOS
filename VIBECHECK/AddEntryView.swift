import SwiftUI

struct AddEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var localizationManager: LocalizationManager
    
    @State private var amountString: String = "0"
    @State private var selectedType: TransactionType = .expense
    @State private var selectedMood: Mood?
    @State private var category: String = "General" 
    @State private var note: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var showCategoryPicker = false
    
    // Define available categories keys for localization
    let categoryKeys = ["category_food", "category_transport", "category_shopping", "category_entertainment", "category_other"]
    
    var body: some View {
        ZStack {
            NeoColors.yellow.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                ZStack {
                    Color.black.ignoresSafeArea(edges: .top)
                        .frame(height: 60)
                    
                    HStack {
                        Button(action: { dismiss() }) {
                             Image(systemName: "xmark")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                        }
                        Spacer()
                        Text(localizationManager.localize("app_name_full"))
                            .font(.system(size: 20, weight: .black))
                            .foregroundColor(.white)
                        Spacer()
                        // Invisible spacer to balance the close button
                        Image(systemName: "xmark")
                           .font(.system(size: 20, weight: .bold))
                           .foregroundColor(.clear)
                           .padding()
                    }
                    .padding(.top, 0)
                }
                
                ScrollView {
                    VStack(spacing: 16) {
                        // Section Header: Add Entry
                        Text(localizationManager.localize("add_entry"))
                            .neoText(size: 20, color: .white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(NeoColors.blue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        // Toggle
                        HStack(spacing: 0) {
                            Button(action: { selectedType = .income }) {
                                Text(localizationManager.localize("income"))
                                    .neoText(size: 18, color: .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedType == .income ? NeoColors.green : Color.gray)
                            }
                            
                            Button(action: { selectedType = .expense }) {
                                Text(localizationManager.localize("expense"))
                                    .neoText(size: 18, color: .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(selectedType == .expense ? Color.red : Color.gray)
                            }
                        }
                        .cornerRadius(25)
                        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.black, lineWidth: 3))
                        .padding(.horizontal)
                        
                        // Amount Display
                        Text("$ \(amountString)")
                            .font(.system(size: 48, weight: .black))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .background(NeoColors.yellow)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2).padding(4))
                            .padding(.horizontal)
                        
                        // Category Selector
                        Button(action: { showCategoryPicker = true }) {
                            HStack {
                                Image(systemName: "folder.fill")
                                Text(category == "General" ? localizationManager.localize("select_category") : (localizationManager.localize(category) == category ? category : localizationManager.localize(category)))
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .neoText(size: 18, color: .white)
                            .padding()
                            .background(NeoColors.blue)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            .padding(.horizontal)
                        }
                        .confirmationDialog(localizationManager.localize("select_category"), isPresented: $showCategoryPicker, titleVisibility: .visible) {
                            ForEach(categoryKeys, id: \.self) { key in
                                Button(localizationManager.localize(key)) {
                                    category = key
                                }
                            }
                            Button(localizationManager.localize("cancel"), role: .cancel) {}
                        }
                        
                        // Note Input
                        HStack {
                            Image(systemName: "pencil")
                                .foregroundColor(.black)
                            TextField(localizationManager.localize("note_placeholder"), text: $note)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                        .padding(.horizontal)
                        
                        // Mood Selector
                        VStack(spacing: 8) {
                            Text(localizationManager.localize("pick_mood"))
                                .neoText(size: 18, color: .white)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 4)
                                .background(NeoColors.blue)
                                .cornerRadius(12)
                            
                            HStack(spacing: 12) {
                                MoodCard(mood: .regretlessJoy, selected: selectedMood == .regretlessJoy) {
                                    selectedMood = .regretlessJoy
                                }
                                MoodCard(mood: .impulseTax, selected: selectedMood == .impulseTax) {
                                    selectedMood = .impulseTax
                                }
                                MoodCard(mood: .revengeSpending, selected: selectedMood == .revengeSpending) {
                                    selectedMood = .revengeSpending
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Keypad
                        VStack(spacing: 12) {
                            ForEach(0..<3) { row in
                                HStack(spacing: 12) {
                                    ForEach(1..<4) { col in
                                        let num = row * 3 + col
                                        KeypadButton(text: "\(num)") {
                                            appendNumber("\(num)")
                                        }
                                    }
                                }
                            }
                            HStack(spacing: 12) {
                                KeypadButton(text: "0") {
                                    appendNumber("0")
                                }
                                KeypadButton(text: ".") {
                                    appendNumber(".")
                                }
                                Button(action: {
                                    removeLastDigit()
                                }) {
                                    ZStack {
                                        Color.gray
                                        Image(systemName: "delete.left.fill")
                                            .font(.title)
                                            .foregroundColor(.white)
                                    }
                                    .cornerRadius(8)
                                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 3))
                                    .shadow(color: .black, radius: 0, x: 0, y: 4)
                                }
                            }
                        }
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Save Button
                        Button(action: saveTransaction) {
                            Text(localizationManager.localize("save"))
                                .font(.system(size: 30, weight: .black))
                                .foregroundColor(NeoColors.yellow)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(Color.black)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white, lineWidth: 2).padding(2))
                                .shadow(color: .black, radius: 0, x: 4, y: 4)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(localizationManager.localize("missing_info")), message: Text(alertMessage), dismissButton: .default(Text(localizationManager.localize("ok"))))
        }
        .onAppear {
            // Default to expense
            selectedType = .expense
        }
    }
    
    func appendNumber(_ char: String) {
        if amountString == "0" && char != "." {
            amountString = char
        } else {
            amountString += char
        }
    }
    
    func removeLastDigit() {
        if amountString.count > 1 {
            amountString.removeLast()
        } else {
            amountString = "0"
        }
    }
    
    func saveTransaction() {
        let normalizedAmount = amountString.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let amountDecimal = Decimal(string: normalizedAmount, locale: Locale(identifier: "en_US_POSIX")), amountDecimal > 0 else {
            alertMessage = localizationManager.localize("enter_valid_amount")
            showAlert = true
            return
        }
        
        guard let mood = selectedMood else {
            alertMessage = localizationManager.localize("pick_mood_alert")
            showAlert = true
            return
        }
        
        // Use localized category string as value or key? 
        // Ideally store key, but for simple app display, we might store localized string or key.
        // Let's store the localized string for now so it displays nicely in list, 
        // OR store key and localize on display. 
        // Storing key is better practice but requires migration if we change keys.
        // Given the current setup, let's store the localized string to match previous behavior of "General".
        // actually, let's store the localized string for simplicity in display, 
        // OR better: store the key if it's a known category, else custom string.
        // Here we only have fixed categories.
        let typeToSave: AccountingRecordType = (selectedType == .income) ? .income : .expense
        let categoryDisplay = category == "General" ? "" : localizationManager.localize(category)
        let combinedNote: String = {
            let trimmedNote = note.trimmingCharacters(in: .whitespacesAndNewlines)
            if categoryDisplay.isEmpty { return trimmedNote }
            if trimmedNote.isEmpty { return "[\(categoryDisplay)]" }
            return "[\(categoryDisplay)] \(trimmedNote)"
        }()
        
        do {
            try AccountingFileStore.shared.appendRecord(
                timestamp: Date(),
                type: typeToSave,
                price: amountDecimal,
                note: combinedNote,
                moodEmoji: mood.emoji
            )
        } catch {
            alertMessage = error.localizedDescription
            showAlert = true
            return
        }
        
        // Explicitly dismiss
        dismiss()
    }
}

struct MoodCard: View {
    let mood: Mood
    let selected: Bool
    let action: () -> Void
    @EnvironmentObject var localizationManager: LocalizationManager
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(mood.emoji)
                    .font(.system(size: 40))
                Text(localizationManager.localize("mood_\(mood.rawValue)"))
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(mood == .impulseTax ? .white : .black)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color(hex: mood.colorHex))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selected ? Color.white : Color.black, lineWidth: selected ? 5 : 3)
            )
            .shadow(color: .black, radius: 0, x: selected ? 2 : 4, y: selected ? 2 : 4)
            .offset(x: selected ? 2 : 0, y: selected ? 2 : 0)
        }
    }
}

struct KeypadButton: View {
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.system(size: 32, weight: .black))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 3))
                .shadow(color: .black, radius: 0, x: 0, y: 4)
        }
    }
}
