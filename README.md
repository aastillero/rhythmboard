# Rythmboard 🩰

A real-time dance competition monitoring board for event halls. Displays completed, current, and upcoming dance heats with participant listings and ad support. Designed for Android devices connected to large-screen monitors.

---

## ✨ Features
- **Live Dance Heat Updates**: Track completed, current, and upcoming heats in real time.
- **On-Deck Participants**: View the list of competitors for the next heat.
- **Ad Support**: Display ads alongside live heat status for event sponsors.
- **WebSocket Integration**: Real-time updates via a local Java backend server.

---

## 📸 Screenshots
| Current Heat | On-Deck Participants | Ad Display |
|--------------|-----------------------|------------|
| <img src="assets/screenshots/current_heat.png" width="300"> | <img src="assets/screenshots/on_deck.png" width="300"> | <img src="assets/screenshots/ads.png" width="300"> |

**To add screenshots**:
1. Create an `assets/screenshots/` folder.
2. Save your screenshots with the names `current_heat.png`, `on_deck.png`, and `ads.png`.
3. Update the table above if your filenames differ.

---

## 🛠️ Installation
```bash
# 1. Clone the repository
git clone https://github.com/[your-username]/rythmboard.git

# 2. Install dependencies
flutter pub get

# 3. Run the app (ensure your Android device/emulator is connected)
flutter run
```

⚠️ **Prerequisite**: Ensure your local Java backend server is running. The app relies on it for WebSocket/HTTP communication.

---

## 🔧 Dependencies
- [`stomp_dart_client`](https://pub.dev/packages/stomp_dart_client): Real-time WebSocket communication.
- [`http`](https://pub.dev/packages/http): Fetch data via HTTP requests.
- [`path_provider`](https://pub.dev/packages/path_provider): Access device filesystem for configurations.

---

## 📄 License
MIT License - See [LICENSE](LICENSE) for details.
