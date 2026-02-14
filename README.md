<div align="center">

# VibeCheck Finance (iOS)

[English](#english) · [中文](#中文) · [한국어](#한국어)

</div>

---

## English

VibeCheck Finance is a fully local-first, emotion-driven accounting app. It records not only income/expense, but also the mood behind each transaction — helping you explore the relationship between your wallet and your mental state.

### Highlights

- Local-first: all data is stored in a single local text file (no cloud)
- Clear record format: one line per record, easy to backup and migrate
- Neo-brutalism UI: high-saturation color blocks with bold black borders
- UI languages: English / 简体中文 / 繁體中文 / 日本語 / 한국어

### Local Storage

The app creates a dedicated folder in the app sandbox Documents directory and appends all records to the same text file:

- Folder: `Documents/MyAccounting/`
- File: `accounting_records.txt`
- Header: `timestamp|type|amount|note|mood`
- Line format: `YYYY-MM-DD HH:MM:SS|expense/income|12.34|note text|😀`

### Features

- Add entry: auto timestamp, type (expense/income), amount, note, mood emoji
- Home: show latest 10 records and today’s quick stats
- Analytics: scatter / pie / trend charts (based on the local file)
- Settings: language switch, reset local data file (keeps header only)

### File Tree

```text
VIBECHECK-IOS/
├─ VIBECHECK/
│  ├─ AccountingFileStore.swift
│  ├─ AddEntryView.swift
│  ├─ AnalyticsView.swift
│  ├─ ContentView.swift
│  ├─ DashboardView.swift
│  ├─ DesignSystem.swift
│  ├─ LocalizationManager.swift
│  ├─ SettingsView.swift
│  ├─ Transaction.swift
│  ├─ VIBECHECKApp.swift
│  └─ Assets.xcassets/
├─ VIBECHECK.xcodeproj/
├─ README.md
└─ LICENSE
```

### License

This project is licensed under the MIT License.

See [LICENSE](LICENSE).

---

## 中文

VibeCheck Finance 是一款完全本地化（Local-first）的情绪驱动记账应用：不仅记录「支出/收入」，还记录每笔交易背后的心情，用“Return on Happiness”来观察钱包与情绪之间的关系。

### 亮点

- 完全本地存储：所有数据写入本地文本文件，不依赖云端
- 记录格式清晰：每条记录一行，便于备份与迁移
- 霓虹新野兽派 UI：高饱和色块 + 黑色粗描边
- 多语言 UI：支持 English / 简体中文 / 繁體中文 / 日本語 / 한국어

### 本地存储机制

应用会在沙盒的 Documents 目录下创建专用文件夹，并把所有记账记录追加写入同一个文本文件：

- 目录：`Documents/MyAccounting/`
- 文件：`accounting_records.txt`
- 表头：`时间|类型|价格|备注|心情`
- 每条记录格式：`YYYY-MM-DD HH:MM:SS|支出/收入|12.34|备注文本|😀`

### 主要功能

- 记账：时间自动填充、类型选择（支出/收入）、金额输入、备注输入、心情 Emoji 选择
- 首页：显示最近 10 条记录，并展示当日简要统计
- 统计：散点图/饼图/趋势图（基于本地文件数据）
- 设置：语言切换、数据重置（重置本地文件，仅保留表头）

### 文件树

```text
VIBECHECK-IOS/
├─ VIBECHECK/
│  ├─ AccountingFileStore.swift
│  ├─ AddEntryView.swift
│  ├─ AnalyticsView.swift
│  ├─ ContentView.swift
│  ├─ DashboardView.swift
│  ├─ DesignSystem.swift
│  ├─ LocalizationManager.swift
│  ├─ SettingsView.swift
│  ├─ Transaction.swift
│  ├─ VIBECHECKApp.swift
│  └─ Assets.xcassets/
├─ VIBECHECK.xcodeproj/
├─ README.md
└─ LICENSE
```

### 许可证

本项目使用 MIT License。

详见 [LICENSE](LICENSE)。

---

## 한국어

VibeCheck Finance는 완전 로컬(Local-first) 기반의 감정 중심 가계부 앱입니다. 수입/지출뿐 아니라 각 거래의 감정(이모지)까지 함께 기록하여 지갑과 기분의 상관관계를 확인할 수 있습니다.

### 주요 특징

- 로컬 우선: 모든 데이터는 단일 로컬 텍스트 파일에 저장(클라우드 없음)
- 명확한 포맷: 한 줄에 한 기록, 백업/이동이 쉬움
- 네오-브루탈리즘 UI: 고채도 컬러 블록 + 굵은 검정 테두리
- UI 언어: English / 中文 / 한국어 포함(앱 내 다국어 지원)

### 로컬 저장 방식

앱은 샌드박스 Documents 경로에 전용 폴더를 만들고 동일한 텍스트 파일에 계속 추가 저장합니다:

- 폴더: `Documents/MyAccounting/`
- 파일: `accounting_records.txt`
- 헤더: `시간|유형|금액|메모|기분`
- 한 줄 포맷: `YYYY-MM-DD HH:MM:SS|지출/수입|12.34|메모|😀`

### 기능

- 기록 추가: 자동 시간, 타입(수입/지출), 금액, 메모, 기분 이모지
- 홈: 최근 10개 기록 표시 + 오늘 요약
- 통계: 산점도/원형/추세 차트(로컬 파일 기반)
- 설정: 언어 변경, 로컬 데이터 파일 초기화(헤더만 유지)

### 파일 트리

```text
VIBECHECK-IOS/
├─ VIBECHECK/
│  ├─ AccountingFileStore.swift
│  ├─ AddEntryView.swift
│  ├─ AnalyticsView.swift
│  ├─ ContentView.swift
│  ├─ DashboardView.swift
│  ├─ DesignSystem.swift
│  ├─ LocalizationManager.swift
│  ├─ SettingsView.swift
│  ├─ Transaction.swift
│  ├─ VIBECHECKApp.swift
│  └─ Assets.xcassets/
├─ VIBECHECK.xcodeproj/
├─ README.md
└─ LICENSE
```

### 라이선스

이 프로젝트는 MIT License로 배포됩니다.

자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
