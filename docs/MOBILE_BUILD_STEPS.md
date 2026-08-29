# SocialStar mobile build steps

## AndroidIDE
1. Open the folder `SocialStar_v15_production` as the project root.
2. Make sure AndroidIDE has Flutter SDK configured.
3. If using the terminal from the project root, run:
   `./gradlew :app:assembleDebug`
4. If AndroidIDE's Gradle dialog is used, run the same task:
   `:app:assembleDebug`
5. Do not use `Generate Signed Bundle / APK` until the debug build succeeds.

## Important
The Android Gradle configuration requires Flutter's SDK path in `android/local.properties`.
AndroidIDE normally supplies this when Flutter is configured. If the build says `flutter.sdk not set`, configure the Flutter SDK in AndroidIDE and retry.
