# Test Braindump on Your Own iPhone

These steps assume you are on macOS with Xcode installed. iOS builds cannot be produced on Linux or Windows because Apple signing and device deployment require Xcode.

## 1. Install required tools

1. Install the latest stable Flutter SDK from <https://docs.flutter.dev/get-started/install/macos/mobile-ios>.
2. Install Xcode from the Mac App Store.
3. Open Xcode once and accept the license.
4. Install CocoaPods if Flutter reports it missing:

```sh
sudo gem install cocoapods
```

5. Verify your setup:

```sh
flutter doctor
```

Fix any iOS-related issues before continuing.

## 2. Prepare the project

From the repository root, fetch dependencies and run checks:

```sh
flutter pub get
flutter analyze
flutter test
```

## 3. Connect and trust your iPhone

1. Connect your iPhone by USB.
2. Unlock the iPhone and tap **Trust This Computer** if prompted.
3. Enable Developer Mode on the iPhone if iOS asks for it:
   - Settings → Privacy & Security → Developer Mode → On.
4. Confirm Flutter sees the device:

```sh
flutter devices
```

## 4. Configure signing in Xcode

1. Open the iOS workspace:

```sh
open ios/Runner.xcworkspace
```

2. Select **Runner** in the project navigator.
3. Select the **Runner** target.
4. Open **Signing & Capabilities**.
5. Choose your Apple developer team.
6. Change the bundle identifier from `app.braindump.mvp` to a unique value, for example `com.yourname.braindump`.

A free Apple ID can deploy to your own iPhone for development. A paid Apple Developer Program membership is only needed for TestFlight/App Store distribution or some advanced capabilities.

## 5. Run on the iPhone

You can run from Flutter:

```sh
flutter run -d <device-id>
```

Or from Xcode:

1. Select your iPhone as the run destination.
2. Press **Run**.

## 6. Manual smoke test

After the app starts on the phone:

1. Tap **Write**.
2. Enter a short thought.
3. Tap **Save thought**.
4. Confirm the thought appears in the feed.
5. Open the status chip and change the status to `done`, `dropped`, or `archived`.
6. Tap the book icon in the app bar to generate a local weekly review.
7. Confirm the review screen opens and contains sections for main themes, patterns, open loops, next steps, and drops.

## Current MVP test notes

- Text capture, Markdown persistence, status changes, and deterministic local weekly-review generation are implemented.
- The voice button currently shows a placeholder. The local transcript persistence and temporary audio deletion service is covered by tests, but microphone recording and `whisper.cpp` native integration are the next implementation step.
- The iOS project includes microphone and speech-recognition usage descriptions so the next voice capture phase can request permissions cleanly.
