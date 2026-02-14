import SwiftUI
import Combine

enum Language: String, CaseIterable, Identifiable {
    case english = "en"
    case simplifiedChinese = "zh-Hans"
    case traditionalChinese = "zh-Hant"
    case japanese = "ja"
    case korean = "ko"
    
    var displayName: String {
        switch self {
        case .english: return "English"
        case .simplifiedChinese: return "简体中文"
        case .traditionalChinese: return "繁體中文"
        case .japanese: return "日本語"
        case .korean: return "한국어"
        }
    }
    
    var id: String { rawValue }
}

class LocalizationManager: ObservableObject {
    @Published var language: Language {
        didSet {
            UserDefaults.standard.set(language.rawValue, forKey: "selectedLanguage")
        }
    }
    
    init() {
        let savedLang = UserDefaults.standard.string(forKey: "selectedLanguage")
        self.language = Language(rawValue: savedLang ?? "en") ?? .english
    }
    
    func localize(_ key: String) -> String {
        let lang = language
        
        switch key {
        // App Titles
        case "app_name":
            return "VibeCheck"
        case "app_name_full":
            return "VibeCheck Finance"
            
        // Dashboard
        case "net_happiness":
            switch lang {
            case .simplifiedChinese: return "今日快乐净值"
            case .traditionalChinese: return "今日快樂淨值"
            case .japanese: return "今日の幸福度"
            case .korean: return "오늘의 행복 순가치"
            default: return "Today's Net Happiness"
            }
        case "net_spending":
            switch lang {
            case .simplifiedChinese: return "今日净支出"
            case .traditionalChinese: return "今日淨支出"
            case .japanese: return "今日の純支出"
            case .korean: return "오늘의 순지출"
            default: return "Today's Net Spending"
            }
        case "recent_transactions":
            switch lang {
            case .simplifiedChinese: return "近期交易"
            case .traditionalChinese: return "近期交易"
            case .japanese: return "最近の取引"
            case .korean: return "최근 거래"
            default: return "Recent Transactions"
            }
            
        // Add Entry
        case "add_entry":
            switch lang {
            case .simplifiedChinese: return "记一笔"
            case .traditionalChinese: return "記一筆"
            case .japanese: return "追加"
            case .korean: return "추가하기"
            default: return "Add Entry"
            }
        case "income":
            switch lang {
            case .simplifiedChinese: return "收入"
            case .traditionalChinese: return "收入"
            case .japanese: return "収入"
            case .korean: return "수입"
            default: return "Income"
            }
        case "expense":
            switch lang {
            case .simplifiedChinese: return "支出"
            case .traditionalChinese: return "支出"
            case .japanese: return "支出"
            case .korean: return "지출"
            default: return "Expense"
            }
        case "select_category":
            switch lang {
            case .simplifiedChinese: return "选择分类"
            case .traditionalChinese: return "選擇分類"
            case .japanese: return "カテゴリー選択"
            case .korean: return "카테고리 선택"
            default: return "Select Category"
            }
        case "pick_mood":
            switch lang {
            case .simplifiedChinese: return "选个心情:"
            case .traditionalChinese: return "選個心情:"
            case .japanese: return "気分を選択:"
            case .korean: return "기분을 선택하세요:"
            default: return "Pick Your Mood:"
            }
        case "save":
            switch lang {
            case .simplifiedChinese: return "保存"
            case .traditionalChinese: return "保存"
            case .japanese: return "保存"
            case .korean: return "저장"
            default: return "SAVE"
            }
            
        // Alerts
        case "missing_info":
            switch lang {
            case .simplifiedChinese: return "信息缺失"
            case .traditionalChinese: return "信息缺失"
            case .japanese: return "情報不足"
            case .korean: return "정보 누락"
            default: return "Missing Info"
            }
        case "enter_valid_amount":
            switch lang {
            case .simplifiedChinese: return "请输入有效金额"
            case .traditionalChinese: return "請輸入有效金額"
            case .japanese: return "有効な金額を入力してください"
            case .korean: return "유효한 금액을 입력하세요"
            default: return "Please enter a valid amount"
            }
        case "pick_mood_alert":
            switch lang {
            case .simplifiedChinese: return "请选择一个心情！"
            case .traditionalChinese: return "請選擇一個心情！"
            case .japanese: return "気分を選んでください！"
            case .korean: return "기분을 선택해주세요!"
            default: return "Please pick a mood!"
            }
        case "ok":
            switch lang {
            case .simplifiedChinese: return "好的"
            case .traditionalChinese: return "好的"
            case .japanese: return "OK"
            case .korean: return "확인"
            default: return "OK"
            }
            
        // Analytics
        case "happiness_roi":
            switch lang {
            case .simplifiedChinese: return "快乐回报率 (ROI)"
            case .traditionalChinese: return "快樂回報率 (ROI)"
            case .japanese: return "幸福のROI"
            case .korean: return "행복 ROI"
            default: return "Happiness ROI"
            }
        case "stupidity_tax":
            switch lang {
            case .simplifiedChinese: return "智商税"
            case .traditionalChinese: return "智商稅"
            case .japanese: return "衝動買い税"
            case .korean: return "멍청 비용"
            default: return "Stupidity Tax"
            }
        case "spending_vs_stability":
            switch lang {
            case .simplifiedChinese: return "支出 vs 情绪稳定性"
            case .traditionalChinese: return "支出 vs 情緒穩定性"
            case .japanese: return "支出と安定性"
            case .korean: return "지출 대 안정성"
            default: return "Spending vs. Stability"
            }
        case "good_vibes":
            switch lang {
            case .simplifiedChinese: return "良好氛围"
            case .traditionalChinese: return "良好氛圍"
            case .japanese: return "良いバイブス"
            case .korean: return "좋은 기분"
            default: return "Good Vibes"
            }
        case "spending":
            switch lang {
            case .simplifiedChinese: return "支出"
            case .traditionalChinese: return "支出"
            case .japanese: return "支出"
            case .korean: return "지출"
            default: return "Spending"
            }
        case "emotional_stability":
            switch lang {
            case .simplifiedChinese: return "情绪稳定性"
            case .traditionalChinese: return "情緒穩定性"
            case .japanese: return "感情の安定"
            case .korean: return "정서적 안정"
            default: return "Emotional Stability"
            }
        case "return_on_investment":
            switch lang {
            case .simplifiedChinese: return "投资回报"
            case .traditionalChinese: return "投資回報"
            case .japanese: return "投資収益率"
            case .korean: return "투자 수익"
            default: return "Return on Investment"
            }
        case "high":
            switch lang {
            case .simplifiedChinese: return "高"
            case .traditionalChinese: return "高"
            case .japanese: return "高"
            case .korean: return "높음"
            default: return "High"
            }
        case "low":
            switch lang {
            case .simplifiedChinese: return "低"
            case .traditionalChinese: return "低"
            case .japanese: return "低"
            case .korean: return "낮음"
            default: return "Low"
            }
        case "losses":
            switch lang {
            case .simplifiedChinese: return "亏损"
            case .traditionalChinese: return "虧損"
            case .japanese: return "損失"
            case .korean: return "손실"
            default: return "Losses"
            }
        case "pie_chart_ios17":
            switch lang {
            case .simplifiedChinese: return "饼图需要 iOS 17"
            case .traditionalChinese: return "餅圖需要 iOS 17"
            case .japanese: return "円グラフには iOS 17 が必要です"
            case .korean: return "원형 차트는 iOS 17이 필요합니다"
            default: return "Pie Chart requires iOS 17"
            }
            
        case "category_food":
            switch lang {
            case .simplifiedChinese: return "餐饮"
            case .traditionalChinese: return "餐飲"
            case .japanese: return "食事"
            case .korean: return "식비"
            default: return "Food"
            }
        case "category_transport":
            switch lang {
            case .simplifiedChinese: return "交通"
            case .traditionalChinese: return "交通"
            case .japanese: return "交通費"
            case .korean: return "교통"
            default: return "Transport"
            }
        case "category_shopping":
            switch lang {
            case .simplifiedChinese: return "购物"
            case .traditionalChinese: return "購物"
            case .japanese: return "買い物"
            case .korean: return "쇼핑"
            default: return "Shopping"
            }
        case "category_entertainment":
            switch lang {
            case .simplifiedChinese: return "娱乐"
            case .traditionalChinese: return "娛樂"
            case .japanese: return "娯楽"
            case .korean: return "엔터테인먼트"
            default: return "Entertainment"
            }
        case "category_other":
            switch lang {
            case .simplifiedChinese: return "其他"
            case .traditionalChinese: return "其他"
            case .japanese: return "その他"
            case .korean: return "기타"
            default: return "Other"
            }
        case "note":
            switch lang {
            case .simplifiedChinese: return "备注"
            case .traditionalChinese: return "備註"
            case .japanese: return "メモ"
            case .korean: return "메모"
            default: return "Note"
            }
        case "note_placeholder":
            switch lang {
            case .simplifiedChinese: return "写点什么..."
            case .traditionalChinese: return "寫點什麼..."
            case .japanese: return "メモを入力..."
            case .korean: return "메모 입력..."
            default: return "Enter note..."
            }
            
        // Moods
        case "mood_regretlessJoy":
            switch lang {
            case .simplifiedChinese: return "千金难买我乐意"
            case .traditionalChinese: return "千金難買我樂意"
            case .japanese: return "後悔のない喜び"
            case .korean: return "후회 없는 기쁨"
            default: return "Regretless Joy"
            }
        case "mood_impulseTax":
            switch lang {
            case .simplifiedChinese: return "冲动是魔鬼"
            case .traditionalChinese: return "衝動是魔鬼"
            case .japanese: return "衝動税"
            case .korean: return "충동 비용"
            default: return "Impulse Tax"
            }
        case "mood_revengeSpending":
            switch lang {
            case .simplifiedChinese: return "报复性消费"
            case .traditionalChinese: return "報復性消費"
            case .japanese: return "リベンジ消費"
            case .korean: return "보복 소비"
            default: return "Revenge Spending"
            }
        case "mood_sad":
            switch lang {
            case .simplifiedChinese: return "悲伤消费"
            case .traditionalChinese: return "悲傷消費"
            case .japanese: return "悲しみの出費"
            case .korean: return "슬픔 비용"
            default: return "Sad Spending"
            }
        case "mood_neutral":
            switch lang {
            case .simplifiedChinese: return "无感"
            case .traditionalChinese: return "無感"
            case .japanese: return "普通"
            case .korean: return "그저 그럼"
            default: return "Meh"
            }
        case "mood_happy":
            switch lang {
            case .simplifiedChinese: return "开心"
            case .traditionalChinese: return "開心"
            case .japanese: return "幸せ"
            case .korean: return "행복"
            default: return "Happy"
            }
            
        // Settings
        case "settings":
            switch lang {
            case .simplifiedChinese: return "设置"
            case .traditionalChinese: return "設置"
            case .japanese: return "設定"
            case .korean: return "설정"
            default: return "Settings"
            }
        case "language":
            switch lang {
            case .simplifiedChinese: return "语言"
            case .traditionalChinese: return "語言"
            case .japanese: return "言語"
            case .korean: return "언어"
            default: return "Language"
            }
        case "fresh_start":
            switch lang {
            case .simplifiedChinese: return "重新开始"
            case .traditionalChinese: return "重新開始"
            case .japanese: return "リセット"
            case .korean: return "초기화"
            default: return "Fresh Start"
            }
        case "reset_data_confirm":
            switch lang {
            case .simplifiedChinese: return "确定要删除所有数据吗？此操作不可撤销。"
            case .traditionalChinese: return "確定要刪除所有數據嗎？此操作不可撤銷。"
            case .japanese: return "すべてのデータを削除しますか？この操作は取り消せません。"
            case .korean: return "모든 데이터를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다."
            default: return "Are you sure you want to delete all data? This cannot be undone."
            }
        case "delete":
            switch lang {
            case .simplifiedChinese: return "删除"
            case .traditionalChinese: return "刪除"
            case .japanese: return "削除"
            case .korean: return "삭제"
            default: return "Delete"
            }
        case "cancel":
            switch lang {
            case .simplifiedChinese: return "取消"
            case .traditionalChinese: return "取消"
            case .japanese: return "キャンセル"
            case .korean: return "취소"
            default: return "Cancel"
            }
            
        default:
            return key
        }
    }
}
