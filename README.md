
Drive link https://drive.google.com/drive/folders/1-wKGFhxm4nUYo2k6YtGYvuwczL4o4sfi



### Assignment — Flutter (Android | iOS | Web)

#### Overview
- This app demonstrates a modular Flutter architecture (GetX bindings/controllers/views) with Firebase integration, including Phone Authentication for Web and Mobile.
- The repository is structured for clarity and testability, separating services, controllers, models, and views under `lib/`.
- This README provides copy-paste-ready commands and code snippets to set up, run, and build the project, plus instructions to upload builds to Google Drive and share a public link.

---

## Tech Stack
- **Flutter**: UI framework for Android, iOS, Web, desktop.
- **Dart**: Programming language.
- **GetX**: State management, routing, and dependency injection.
- **Firebase**: Core and Authentication (Phone Auth for Web + Mobile).

---

## Project Structure (key folders)
- `lib/main.dart` — App entry point and Firebase initialization.
- `lib/config/theme/` — App theme configuration.
- `lib/modules/` — Feature modules (authentication, splash, home, etc.).
- `lib/services/` — Shared services (Firebase Auth, REST, Storage).
- `lib/routes/` — Centralized app routing.
- `test/` — Unit tests for controllers.

---

## Prerequisites
- Flutter SDK installed and on PATH.
- Android Studio/Xcode for native builds; Chrome for web.
- Firebase Project with Phone Sign-in enabled.
- Logged in with Firebase CLI.

---

## Dependencies (pubspec.yaml)
Copy-paste into your `pubspec.yaml` under `dependencies` and run `flutter pub get`.

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Firebase
  firebase_core: ^3.4.0
  firebase_auth: ^5.2.0

  # State management
  get: ^4.6.6

  # Optional helpers
  connectivity_plus: ^6.0.5
  intl: ^0.19.0
```

---

## Firebase Setup (Copy-Paste Steps)
1) Install CLI and login
```bash
dart pub global activate flutterfire_cli
firebase login
```

2) Configure this app (from project root)
```bash
flutterfire configure --project <your-firebase-project-id>
```

3) Initialize Firebase in `lib/main.dart`
```dart
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

4) Enable Phone provider in Firebase Console → Authentication → Sign-in method.

---

## Platform Notes
### Android
- Add SHA-1 and SHA-256 fingerprints (debug and release) in Firebase Console → Project Settings → Android app.
- Ensure Google services plugin is applied (usually auto by FlutterFire).
- Recommended `minSdkVersion`: 23+

### iOS
- For auto-retrieval, upload APNs key and enable Push Notifications capability (manual entry works without it).
- Test on a real device for reliable behavior.

### Web
- Add `localhost`, `127.0.0.1`, and your production domain in Firebase Console → Authentication → Settings → Authorized domains.
- Add a reCAPTCHA container in `web/index.html` if you use visible mode:
```html
<div id="recaptcha-container"></div>
```

---

## Phone Auth — Mobile (Android/iOS)
```dart
import 'package:firebase_auth/firebase_auth.dart';

class MobilePhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;
  int? _resendToken;

  Future<void> sendCode({required String phoneNumber}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: _resendToken,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        throw e;
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        _resendToken = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> confirmCode({required String smsCode}) async {
    if (_verificationId == null) {
      throw FirebaseAuthException(code: 'missing-verification-id', message: 'Start verification first.');
    }
    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );
    await _auth.signInWithCredential(credential);
  }
}
```

---

## Phone Auth — Web
```dart
import 'dart:html' as html; // Only for web builds
import 'package:firebase_auth/firebase_auth.dart';

class WebPhoneAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  ConfirmationResult? _confirmationResult;

  Future<void> sendCode({required String phoneNumber}) async {
    final verifier = RecaptchaVerifier(
      container: 'recaptcha-container',
      size: RecaptchaVerifierSize.invisible, // or compact
      theme: RecaptchaVerifierTheme.light,
    );
    _confirmationResult = await _auth.signInWithPhoneNumber(phoneNumber, verifier);
  }

  Future<void> confirmCode({required String smsCode}) async {
    final result = _confirmationResult;
    if (result == null) {
      throw FirebaseAuthException(code: 'missing-confirmation', message: 'Start verification first.');
    }
    await result.confirm(smsCode);
  }
}
```

---

## Run & Build (Copy-Paste)
```bash
# Get dependencies
flutter pub get

# Run
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS (macOS + Xcode required)

# Build artifacts
flutter build web
flutter build apk --release
flutter build appbundle --release
flutter build ios --release        # on macOS
```

---

## Testing
- Unit tests are under `test/modules/home/controllers/`.
- Run tests:
```bash
flutter test
```

---

## Limitations
- SMS-based auth offers lower assurance than MFA; consider adding a second factor for sensitive actions.
- Auto-retrieval may vary by carrier/device; always support manual OTP entry.
- On web, reCAPTCHA and browser privacy settings can affect reliability.

---

## Future Improvements
- Add Multi-Factor Authentication (MFA) or TOTP.
- Link phone with Google/Apple/Email for better recovery.
- Improve UX: OTP auto-paste, country detection, localization, offline handling.

---
Drive link https://drive.google.com/drive/folders/1-wKGFhxm4nUYo2k6YtGYvuwczL4o4sfi
