# Quick Firebase Console Setup Steps

## 1. Set Up Firebase Realtime Database

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select project: **madl-exp-9**
3. Click on **"Realtime Database"** in the left sidebar
4. Click **"Create Database"**
5. Choose location (e.g., **United States (us-central1)**)
6. Select **"Start in test mode"** for development
7. Click **"Enable"**

Your database URL will be: `https://madl-exp-9-default-rtdb.firebaseio.com/`

## 2. Configure Database Rules (For Testing)

In the Realtime Database section:

1. Go to the **"Rules"** tab
2. Replace with these test rules:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

3. Click **"Publish"**

⚠️ **Important:** These rules allow anyone to read/write. Only use for testing!

## 3. Get Android Configuration (If testing on Android)

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll to **"Your apps"** section
3. If no Android app exists:
   - Click **"Add app"** > Select **Android**
   - Package name: `com.example.madl_mini_project`
   - App nickname: `MADL Mini Project`
   - Click **"Register app"**
4. Download **google-services.json**
5. Replace the file in: `android/app/google-services.json`
6. Copy the Android App ID and update in `lib/firebase_options.dart` line 48

## 4. Test the Connection

### Option A: Run on Web (Easiest)

```bash
flutter run -d chrome
```

### Option B: Run on Android

```bash
flutter run
```

### Option C: Run on Windows

```bash
flutter run -d windows
```

## 5. Verify Data in Firebase

1. Open Firebase Console > Realtime Database
2. Run your Flutter app
3. Add a user through the form
4. You should see the data appear in Firebase Console under `users/`

## Expected Database Structure

```
madl-exp-9-default-rtdb
└── users
    ├── -Nxxx1xxxxx (auto-generated key)
    │   ├── name: "John Doe"
    │   ├── email: "john@example.com"
    │   ├── age: 25
    │   └── timestamp: 1697812345678
    └── -Nxxx2xxxxx
        ├── name: "Jane Smith"
        ├── email: "jane@example.com"
        ├── age: 30
        └── timestamp: 1697812456789
```

## Troubleshooting

### "Permission denied" error

- Make sure database rules are set to test mode (see step 2)
- Check that the database is created and enabled

### "Firebase app not initialized" error

- Verify `firebase_options.dart` has correct configuration
- Run `flutter clean && flutter pub get`
- Restart the app

### Data not appearing in Firebase

- Check database URL in `firebase_options.dart`
- Verify internet connection
- Check Firebase Console for any errors

## Security Rules for Production

Before deploying to production, update rules:

```json
{
  "rules": {
    "users": {
      ".read": "auth != null",
      ".write": "auth != null",
      "$userId": {
        ".validate": "newData.hasChildren(['name', 'email', 'age'])",
        "name": {
          ".validate": "newData.isString() && newData.val().length > 0"
        },
        "email": {
          ".validate": "newData.isString() && newData.val().matches(/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$/i)"
        },
        "age": {
          ".validate": "newData.isNumber() && newData.val() >= 0 && newData.val() <= 150"
        },
        "timestamp": {
          ".validate": "newData.isNumber()"
        }
      }
    }
  }
}
```

This requires authentication and validates data structure.
