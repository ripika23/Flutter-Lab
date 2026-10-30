# 💧 Hydration Tracker – Flutter Application

A simple and user-friendly Flutter mobile application that helps users record their daily water intake and monitor their progress toward a daily hydration goal.

## 📌 Project Overview

Many people forget to drink enough water throughout the day. The **Hydration Tracker** application provides a simple way to record water consumption, set a daily hydration target, and monitor progress visually.

The application is designed using Flutter and demonstrates fundamental mobile application development concepts such as widgets, state management, navigation, forms, input validation, and progress tracking.

## 🎯 Objective

The main objective of this project is to develop a simple Flutter mobile application that:

* Allows users to record their daily water intake.
* Provides a customizable daily hydration goal.
* Displays progress toward the daily goal.
* Allows users to quickly add common water quantities.
* Allows users to enter a custom water quantity.
* Provides a reset option for daily progress.
* Provides a simple and user-friendly interface.

## ✨ Features

### 💧 Water Intake Tracking

Users can record the amount of water they drink throughout the day.

### 🎯 Daily Hydration Goal

Users can set and customize their daily water consumption goal.

### ➕ Quick Add

The application provides quick buttons for:

* 250 ml
* 500 ml
* 750 ml

### ✏️ Custom Water Entry

Users can enter any valid water quantity using the custom input form.

### 📊 Progress Monitoring

A visual progress bar displays the user's progress toward the daily hydration goal.

The application also displays:

* Total water consumed
* Daily target
* Percentage completed
* Remaining water amount

### 🔄 Reset Progress

Users can reset their recorded water intake for the current session.

### ⚙️ Settings

The Settings screen allows users to:

* Change the daily hydration goal.
* Reset their progress.
* View information about the application.

### 🧭 Navigation

The application uses bottom navigation to switch between:

* Home
* Settings

### ✅ Input Validation

The application validates custom water amounts and hydration goals before accepting them.

## 🛠️ Technologies Used

* **Flutter**
* **Dart**
* **Material Design**
* **Flutter Widgets**
* **Stateful Widgets**
* **Navigation**
* **Forms and Text Fields**
* **Progress Indicators**

## 📱 Application Screens

### Home Screen

The Home screen displays the user's current water intake, daily goal, progress percentage, and progress bar.

### Quick Add Water

Users can quickly record 250 ml, 500 ml, or 750 ml of water.

### Custom Water Entry

Users can enter a custom amount of water using a form.

### Settings Screen

Users can modify their daily hydration goal and reset their progress.

## 📂 Project Structure

```text
hydration-tracker-flutter/
│
├── android/
├── ios/
├── web/
├── lib/
│   └── main.dart
│
├── pubspec.yaml
├── analysis_options.yaml
└── README.md
```

## ▶️ How to Run

### Prerequisites

Install Flutter and ensure that Flutter is properly configured on your system.

### Steps

1. Clone this repository.

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

2. Open the project directory.

```bash
cd hydration-tracker-flutter
```

3. Get the required Flutter packages.

```bash
flutter pub get
```

4. Run the application.

```bash
flutter run
```

The application can also be opened and executed using an online Flutter development environment such as FlutLab.

## 🧠 Concepts Demonstrated

This project demonstrates the following Flutter concepts:

* `MaterialApp`
* `Scaffold`
* `AppBar`
* `Column`
* `Row`
* `Container`
* `Card`
* `Text`
* `Icon`
* `ElevatedButton`
* `OutlinedButton`
* `TextField`
* `AlertDialog`
* `SnackBar`
* `NavigationBar`
* `LinearProgressIndicator`
* `StatefulWidget`
* `setState()`
* Input validation
* Basic navigation

## 🎓 Academic Relevance

This project demonstrates the practical implementation of fundamental Flutter concepts in a real-world application.

It can be used as a mini-project or academic demonstration for learning:

* Mobile application development
* Flutter UI development
* Dart programming
* User input handling
* Navigation
* State management
* Form validation

## 🚀 Future Enhancements

The application can be extended with additional features such as:

* Persistent local storage
* Daily history
* Water intake reminders
* Notification support
* Weekly and monthly statistics
* User profiles
* Dark mode
* Cloud synchronization
* Hydration charts
* Personalized hydration recommendations

## 👩‍💻 Developed Using

**Flutter + Dart**

---

### 📄 Project Status

**Completed – Basic Hydration Tracking Application**

---

## ⚠️ Note

The current implementation maintains the hydration data during the active application session. Persistent storage can be added as a future enhancement using a local storage solution such as SharedPreferences.
