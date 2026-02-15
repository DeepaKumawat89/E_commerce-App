# 🛍️ Flutter E-Commerce Mobile Application

A modern, cross-platform mobile e-commerce application built with Flutter and Firebase, offering a seamless shopping experience with real-time data synchronization and secure transactions.

[![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)](https://firebase.google.com)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)

## 📱 About The Project

This project delivers a comprehensive mobile-first e-commerce solution that redefines online shopping through intuitive design and powerful features. Built with Flutter's cross-platform capabilities and Firebase's robust backend infrastructure, the app provides users with a fast, secure, and engaging shopping experience.

### ✨ Key Highlights

- *Cross-Platform*: Single codebase running smoothly on both Android and iOS
- *Real-Time Sync*: Instant data updates across all user sessions
- *Secure Authentication*: Firebase-powered login with session management
- *Modern UI/UX*: Clean, responsive interface with smooth animations
- *Scalable Architecture*: Modular design ready for future expansion

## 🎯 Features

### 🔐 Authentication & User Management
- Email/password registration and login
- Google Sign-In integration (optional)
- Password reset and email verification
- Persistent session management
- Secure user data protection

### 🏪 Product Browsing & Discovery
- Dynamic product catalog with real-time updates
- Grid and list view layouts
- Category-based filtering
- Advanced search functionality with tags
- Pull-to-refresh for latest products
- Detailed product pages with images, pricing, and specifications

### 🛒 Shopping Cart & Checkout
- Add, remove, and update product quantities
- Real-time cart total calculation
- Order summary with itemized details
- Address entry with validation
- Secure checkout process
- Order placement with status tracking

### 👤 Profile Management
- View and edit personal information
- Update contact details and addresses
- Order history tracking
- Real-time profile synchronization

### 📊 Additional Features
- Push notifications for order updates
- Firebase Analytics integration
- Admin dashboard for product management (optional)
- Order status tracking (pending, shipped, delivered)
- Cloud-based image storage

## 🏗️ System Architecture

The application follows a modular architecture with clear separation of concerns:

![System Architecture](screenshots/image1.png)

## 🛠️ Technology Stack

### Frontend
- *Framework*: Flutter SDK
- *Language*: Dart
- *State Management*: Provider / BLoC (specify your choice)
- *UI Components*: Material Design widgets

### Backend & Services
- *Authentication*: Firebase Authentication
- *Database*: Cloud Firestore (NoSQL)
- *Storage*: Firebase Storage
- *Cloud Functions*: Firebase Cloud Functions
- *Analytics*: Firebase Analytics
- *Notifications*: Firebase Cloud Messaging (FCM)

### Key Dependencies
yaml
dependencies:
  firebase_core: ^latest
  firebase_auth: ^latest
  cloud_firestore: ^latest
  firebase_storage: ^latest
  google_sign_in: ^latest
  cached_network_image: ^latest
  flutter_secure_storage: ^latest


## 📸 App Preview

<p align="center">
  <img src="E-Commerce App.png" width="850" alt="App Preview"/>
</p>


## 🚀 Getting Started

### Prerequisites

- Flutter SDK (version 3.0 or higher)
- Dart SDK (version 2.17 or higher)
- Android Studio / VS Code with Flutter extensions
- Firebase account and project setup
- Git

### Installation

1. *Clone the repository*
   bash
   git clone https://github.com/DeepaKumawat89/E_commerce-App.git
   cd E_commerce-App
   

2. *Install dependencies*
   bash
   flutter pub get
   

3. *Firebase Setup*
   - Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com)
   - Add Android and iOS apps to your Firebase project
   - Download google-services.json (Android) and place it in android/app/
   - Download GoogleService-Info.plist (iOS) and place it in ios/Runner/
   - Enable Authentication methods in Firebase Console
   - Create Firestore database and set up security rules
   - Enable Firebase Storage

4. *Configure Firebase*
   bash
   flutter pub global activate flutterfire_cli
   flutterfire configure
   

5. *Run the app*
   bash
   flutter run
   

## 📱 Build & Release

### Android
bash
flutter build apk --release
# or
flutter build appbundle --release


### iOS
bash
flutter build ios --release


## 🤝 Contributing

Contributions are what make the open-source community amazing! Any contributions you make are *greatly appreciated*.

1. Fork the Project
2. Create your Feature Branch (git checkout -b feature/AmazingFeature)
3. Commit your Changes (git commit -m 'Add some AmazingFeature')
4. Push to the Branch (git push origin feature/AmazingFeature)
5. Open a Pull Request

## 📧 Contact

Deepa Kumawat - [@DeepaKumawat89](https://github.com/DeepaKumawat89)

Project Link: [https://github.com/DeepaKumawat89/E_commerce-App](https://github.com/DeepaKumawat89/E_commerce-App)

## 🙏 Acknowledgments

- [Flutter Documentation](https://flutter.dev/docs)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Material Design Guidelines](https://material.io/design)
- [Stack Overflow Community](https://stackoverflow.com/)
- [Medium Flutter Articles](https://medium.com/flutter)

## 📊 Project Status

🚀 *Active Development* - This project is actively maintained and open for contributions.

---

<p align="center">Made with ❤️ using Flutter and Firebase</p>
