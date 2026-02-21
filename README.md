# ⚡ FluxDash — Professional Flutter Analytics Dashboard

> Real-time, interactive analytics dashboard with animated charts, draggable cards, and a sleek dark UI.

---

## 📸 Features

| Feature | Details |
|---|---|
| 🎨 Design | Dark futuristic theme with Orbitron + Space Grotesk typography |
| 📊 Charts | Line, Area, Bar, Pie — all animated with `fl_chart` |
| 🔄 Live Data | Auto-refreshes every 3 seconds with smooth transitions |
| 🃏 Card Gestures | Tap to expand, Long-press drag to reorder, Swipe to delete |
| 📱 Swipe Hero | Horizontal swipeable card stack for highlights |
| 🗂 Layouts | Grid and List views with animated toggle |
| 💾 Persistence | Card order + layout type saved to SharedPreferences |
| 📐 Detail Screen | Full expanded view with data table and stats |

---

## 📁 Project Structure

```
fluxdash/
├── lib/
│   ├── main.dart                          ← App entry point
│   ├── config/
│   │   └── routes.dart                    ← Named routes
│   ├── core/
│   │   ├── constants/app_constants.dart   ← App-wide constants
│   │   ├── theme/
│   │   │   ├── app_colors.dart            ← Color system
│   │   │   └── app_theme.dart             ← ThemeData
│   │   └── utils/data_generator.dart      ← Random data utilities
│   ├── data/
│   │   ├── models/dashboard_card_model.dart ← Core data model
│   │   └── services/local_storage_service.dart
│   └── presentation/
│       ├── providers/dashboard_provider.dart ← State management
│       ├── screens/
│       │   ├── dashboard_screen.dart        ← Main screen
│       │   ├── card_detail_screen.dart      ← Expanded card view
│       │   └── settings_screen.dart
│       └── widgets/
│           ├── cards/
│           │   ├── animated_dashboard_card.dart
│           │   ├── draggable_card.dart
│           │   └── swipeable_card.dart
│           ├── charts/
│           │   ├── animated_line_chart.dart
│           │   ├── animated_bar_chart.dart
│           │   └── animated_pie_chart.dart
│           ├── layout/
│           │   ├── dashboard_grid.dart
│           │   └── dashboard_list.dart
│           └── common/
│               ├── animated_counter.dart
│               ├── flux_app_bar.dart
│               ├── loading_shimmer.dart
│               └── summary_stats_bar.dart
```

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK ≥ 3.0.0
- Dart ≥ 3.0.0

### Installation

```bash
# 1. Navigate to project
cd fluxdash

# 2. Install dependencies
flutter pub get

# 3. Run app
flutter run
```

### Build Release APK

```bash
flutter build apk --release
```

---

## 🎨 Design System

### Color Palette
| Token | Hex | Usage |
|---|---|---|
| `primary` | `#00D4FF` | Accent, highlights |
| `secondary` | `#7C3AED` | Secondary accent |
| `accent` | `#00FFB3` | Success, mint |
| `warning` | `#FFB347` | Warning states |
| `danger` | `#FF4D6D` | Errors, delete |
| `bg00` | `#060912` | Deepest background |
| `bg01` | `#0C1120` | Main scaffold bg |
| `bg02` | `#111827` | Card backgrounds |

### Typography
- **Display / Headings**: `Orbitron` — Futuristic, technical feel
- **Body / UI**: `Space Grotesk` — Clean, modern, readable  
- **Code / Labels**: `JetBrains Mono` — Monospaced details

---

## 🧩 Key Components

### `DashboardCardModel`
Core data model for all cards. Each card has:
- `id`, `title`, `subtitle`, `type`, `accentColor`, `icon`
- `seriesData` — list of doubles for charting
- `currentValue`, `previousValue` — for trend calculation
- `isExpanded` — expansion state

### `DashboardProvider`
`ChangeNotifier` managing:
- Card list with live updates via `Timer.periodic`
- `toggleExpand(id)` — expand/collapse cards
- `reorderCards(from, to)` — drag & drop reorder
- `removeCard(id)` — dismiss cards
- `toggleLayout()` — grid ↔ list

### Chart Widgets
All charts use `fl_chart` with:
- `duration: Duration(milliseconds: 600)` for smooth data transitions
- `RepaintBoundary` for performance optimization
- Touch tooltips with styled overlays

---

## ⚡ Performance Tips

1. All charts wrapped in `RepaintBoundary`
2. Use `const` constructors everywhere possible
3. `AutomaticKeepAliveClientMixin` can be added to card states
4. `physics: NeverScrollableScrollPhysics()` on inner lists

---

## 📦 Dependencies

```yaml
fl_chart: ^0.68.0           # Charts
provider: ^6.1.1             # State management
shared_preferences: ^2.2.2   # Persistence
animate_do: ^3.3.4           # Entry animations
google_fonts: ^6.2.1         # Orbitron, Space Grotesk
shimmer: ^3.0.0              # Loading skeletons
card_swiper: ^3.0.1          # Swipeable cards
percent_indicator: ^4.2.3    # Progress indicators
intl: ^0.19.0                # Number formatting
uuid: ^4.3.3                 # Unique IDs
```

---

## 🔮 Future Enhancements

- [ ] Firebase Realtime Database integration
- [ ] Custom date range picker for charts
- [ ] Export to PDF / CSV
- [ ] Multiple dashboard tabs
- [ ] Widget customization bottom sheet
- [ ] Haptic feedback on all gestures
- [ ] Landscape layout support

---

**Built with ❤️ — FluxDash v1.0.0**
