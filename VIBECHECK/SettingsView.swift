import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var localizationManager: LocalizationManager
    @State private var showResetAlert = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            NeoColors.blue.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Text(localizationManager.localize("settings"))
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding()
                .background(Color.black)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Storage Info
                        VStack(alignment: .leading, spacing: 10) {
                            Text("File")
                                .neoText(size: 20, color: .black)
                                .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(filePathText())
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .foregroundColor(.black)
                                    .textSelection(.enabled)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // Language Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text(localizationManager.localize("language"))
                                .neoText(size: 20, color: .black)
                                .padding(.horizontal)
                            
                            VStack(spacing: 0) {
                                ForEach(Language.allCases) { language in
                                    Button(action: {
                                        localizationManager.language = language
                                    }) {
                                        HStack {
                                            Text(language.displayName)
                                                .font(.system(size: 18, weight: .bold))
                                                .foregroundColor(.black)
                                            Spacer()
                                            if localizationManager.language == language {
                                                Image(systemName: "checkmark.circle.fill")
                                                    .foregroundColor(NeoColors.green)
                                                    .font(.title2)
                                            }
                                        }
                                        .padding()
                                        .background(Color.white)
                                        .overlay(
                                            Rectangle()
                                                .frame(height: 1)
                                                .foregroundColor(.black),
                                            alignment: .bottom
                                        )
                                    }
                                }
                            }
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                            .padding(.horizontal)
                        }
                        .padding(.top, 20)
                        
                        // Data Management
                        VStack(alignment: .leading, spacing: 10) {
                            Text(localizationManager.localize("fresh_start"))
                                .neoText(size: 20, color: .black)
                                .padding(.horizontal)
                            
                            Button(action: {
                                showResetAlert = true
                            }) {
                                HStack {
                                    Text(localizationManager.localize("fresh_start"))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.black, lineWidth: 3))
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
        }
        .alert(isPresented: $showResetAlert) {
            Alert(
                title: Text(localizationManager.localize("fresh_start")),
                message: Text(localizationManager.localize("reset_data_confirm")),
                primaryButton: .destructive(Text(localizationManager.localize("delete"))) {
                    deleteAllData()
                },
                secondaryButton: .cancel(Text(localizationManager.localize("cancel")))
            )
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text(localizationManager.localize("missing_info")), message: Text(errorMessage), dismissButton: .default(Text(localizationManager.localize("ok"))))
        }
    }
    
    func deleteAllData() {
        do {
            try AccountingFileStore.shared.resetFile()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }

    func filePathText() -> String {
        (try? AccountingFileStore.shared.fileURL().path) ?? "(unavailable)"
    }
}
