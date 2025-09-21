# kartngo
This is a demo Flutter app built as part of a coding assignment.
It reproduces the provided design using Flutter, Provider, and SQLite (sqflite + sqflite_common_ffi_web)

## Screenshots
can be found in /Docs folder

### How to Run
* used device preview to run on chrome
  1- Clone the repo
  git clone https://github.com/<your-username>/kartngo.git
  cd kartngo
  2- Install dependencies
  flutter pub get
  3- Run on device or web
  flutter run -d chrome   # for web
  flutter run -d ios      # for iOS
  flutter run -d android  # for Android

#### Demo Data
The app uses SQLite to store items.
Demo items are inserted automatically on the first run
rerun app again to auto-insert demo data

##### ProxyAI Interaction Log
1-ViewModel Creation
Prompt:
“Create a ViewModel for this screen that loads items from SQLite and exposes them to the UI using ChangeNotifier.”

ProxyAI Response (used):
Suggested an ItemViewModel with:
_items list of Item objects
loadItems() calling DatabaseHelper.fetchItems()
notifyListeners() to refresh the UI

Integration:
Implemented in viewmodels/item_viewmodel.dart and injected via MultiProvider in main.dart.

2- Data Model Class
Prompt:
“Generate Firestore data-model classes for Item with fromMap and toMap methods.”

ProxyAI Response (used):
Suggested an Item model class

Integration:
Used in models/item.dart for both SQLite persistence and UI display.

######
Project Structure:
lib/
├── models/
│    └── item.dart
├── viewmodels/
│    ├── item_viewmodel.dart
│    └── cart_viewmodel.dart
├── ui/screens/
│    └── target_screen.dart
├── data/
│    └── database_helper.dart
├── app_colors.dart
└── main.dart