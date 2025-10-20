# Firebase Integration Setup Guide

This Flutter app is now integrated with Firebase Realtime Database. Follow the steps below to complete the setup and run the app.

## ✅ What's Already Done

1. ✅ Firebase dependencies added to `pubspec.yaml`
2. ✅ Firebase configuration files created
3. ✅ Android build.gradle files updated
4. ✅ Firebase initialized in `main.dart`
5. ✅ UI form created with TextFields for user input
6. ✅ Write functionality to Firebase Database implemented
7. ✅ Real-time read functionality with StreamBuilder implemented

## 🔧 Additional Setup Required

### For Android:

1. **Update google-services.json** (Important!)

   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Select your project: `madl-exp-9`
   - Go to Project Settings > Your Apps
   - Add an Android app if not already added
   - Package name: `com.example.madl_mini_project`
   - Download the actual `google-services.json` file
   - Replace the placeholder file at: `android/app/google-services.json`

2. **Update firebase_options.dart**
   - The current Android appId is a placeholder: `YOUR_APP_ID`
   - Get the actual Android App ID from Firebase Console
   - Update line 48 in `lib/firebase_options.dart`

### For iOS (if testing on iOS):

1. Download `GoogleService-Info.plist` from Firebase Console
2. Add it to `ios/Runner/` directory
3. Update the iOS appId in `firebase_options.dart` (line 59)

### Firebase Database Setup:

1. Go to Firebase Console > Realtime Database
2. Create a database if not already created
3. Choose a location (e.g., us-central1)
4. Start in **test mode** for development (remember to update rules for production!)
5. Your database URL should be: `https://madl-exp-9-default-rtdb.firebaseio.com/`

## 🚀 Running the App

### On Android:

```bash
flutter run
```

### On Web:

```bash
flutter run -d chrome
```

### On Windows:

```bash
flutter run -d windows
```

## 📱 Features Implemented

### 1. Write Data to Firebase

- Form with three fields: Name, Email, Age
- Submit button that saves data to Firebase
- Loading indicator while saving
- Success/error messages

### 2. Read Data from Firebase

- Real-time data streaming using StreamBuilder
- Displays all users in a scrollable list
- Updates automatically when data changes

### 3. Delete Data from Firebase

- Delete button for each user
- Removes data from Firebase instantly

## 🔍 Testing the App

1. **Add a User:**

   - Fill in the Name, Email, and Age fields
   - Click "Submit Data"
   - Check Firebase Console to see the data

2. **View Users:**

   - The list below the form shows all users in real-time
   - Add a user from another device/browser to see live updates

3. **Delete a User:**
   - Click the red delete icon next to any user
   - The user will be removed from the list and Firebase

## 📊 Firebase Database Structure

```
users/
  └── {auto-generated-id}/
      ├── name: "John Doe"
      ├── email: "john@example.com"
      ├── age: 25
      └── timestamp: 1697812345678
```

## 🔒 Security Rules (Important for Production!)

Current rules are set to test mode. Update them in Firebase Console:

```json
{
  "rules": {
    "users": {
      ".read": "auth != null",
      ".write": "auth != null"
    }
  }
}
```

## 🐛 Troubleshooting

### Issue: "FirebaseException: Firebase not initialized"

- Make sure you've downloaded the correct `google-services.json`
- Clean and rebuild: `flutter clean && flutter pub get`

### Issue: "Permission denied"

- Check Firebase Database rules
- Make sure test mode is enabled during development

### Issue: Build errors on Android

- Make sure minSdk is 21 or higher (already set)
- Sync gradle files: `cd android && ./gradlew clean`

## 📚 Key Files

- `lib/main.dart` - Main app with UI and Firebase logic
- `lib/firebase_options.dart` - Firebase configuration
- `android/app/google-services.json` - Android Firebase config
- `android/build.gradle.kts` - Root build file with Firebase plugin
- `android/app/build.gradle.kts` - App build file with Firebase plugin

## 🎯 Next Steps

1. Replace the placeholder `google-services.json` with the actual file
2. Update Firebase Database rules for security
3. Add Firebase Authentication for user management
4. Add data validation and error handling
5. Implement search and filter functionality
6. Add offline persistence

## 📞 Support

If you encounter any issues, check:

- Firebase Console for project configuration
- Flutter logs: `flutter logs`
- Firebase documentation: https://firebase.google.com/docs/flutter/setup

Happy coding! 🎉
