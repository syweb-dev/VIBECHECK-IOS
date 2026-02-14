©SANYOU


# <a name="_ijtdsvfxq6ye"></a>**🛠️ Product Requirements Document (PRD): VibeCheck Finance**
## <a name="_hlbpdmrnfigz"></a>**1. Product Concept**
**VibeCheck Finance** is not just another boring accounting tool. It’s a high-saturation, emotionally-driven financial diary that explores the correlation between your wallet and your mental state. We track **"Return on Happiness"** instead of just ROI.

-----
## <a name="_1qqtimnyqt8u"></a>**2. Visual Identity & UI/UX**
- **Aesthetics:** High-saturation color blocking (Neo-Brutalism style).
- **Dynamic Theming:** Dark/Light mode support with high-contrast accents.
- **Interaction:** Fluid SwiftUI animations to make spending money feel... slightly less painful. 💸
-----
## <a name="_oc5rpbvdidjl"></a>**3. Core Feature Modules**
### <a name="_aolb1v8rmmmc"></a>**A. Dashboard (Home)**
- **Daily Feed:** A chronological list of transactions.
- **Visual Breakdown:** Each entry card displays the **Amount**, **Category**, and a prominent **Mood Icon**.
- **Quick Summary:** Header section showing "Today's Net Happiness" vs. "Today's Net Spending."
### <a name="_pdz37egjuu3d"></a>**B. Add Entry (The "Vibe" Input)**
- **Transaction Type:** Toggle between *Income* (+) and *Expense* (-).
- **Amount Entry:** Large, bold numeric keypad.
- **Recurrence:** Support for daily, weekly, or monthly automated entries.
- **Mood Selection:** A mandatory emoji-based picker (e.g., 🥳 Regretless Joy, 🤡 Impulse Tax, 😤 Revenge Spending).
- **Notes:** Optional text field for the "Why."
### <a name="_rln03mh4vckh"></a>**C. Annual Analytics (The Reality Check)**
- **Financial Overview:** Total Revenue, Total Burn, and Net Balance.
- **The "Happiness ROI" Matrix:** \* **Scatter Plot:** Mood level vs. Transaction amount.
  - **The Stupidity Tax Chart:** A pie chart showing how much money was wasted on "Bad Mood" impulses.
- **Monthly Trend Lines:** Multi-layered charts comparing spending habits with emotional stability.
### <a name="_w8gpnkxg6c0h"></a>**D. Settings & Personalization**
- **Localization:** Multi-language support (Simplified Chinese/English).
- **Data Management:** One-tap "Fresh Start" (Data Reset).
- **Display:** Toggle between Dark/Light/System themes.
-----
## <a name="_np97trhkuyn5"></a>**4. Technical Architecture (iOS)**

|**Layer**|**Technology Recommendation**|
| :- | :- |
|**Framework**|**SwiftUI** (For that modern, reactive UI)|
|**Database**|**SwiftData** or CoreData (Local-first privacy)|
|**Charts**|**Swift Charts** (Native, high-performance visualization)|
|**Architecture**|**MVVM** (To keep your logic clean and testable)|

-----
## <a name="_5brjzvjo5lh2"></a>**5. Next Steps for Development**
1. **Define Mood Categories:** Create an enum for moods and assign them "Value Scores."
1. **Logic Implementation:** Calculate the "Stupidity Tax" (Expenses where Mood < 3/5).
1. **UI Prototyping:** Design the high-saturation color palette in Figma or directly in SwiftUI Previews.


