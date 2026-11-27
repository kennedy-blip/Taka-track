# TakaTrack

Offline-first waste collection, subscriber billing and recycling ledger built in **Dart + Flutter** for Android and Web.

## Features
- Pickup checklist with Collected, Gate locked and Missed statuses and route progress.
- Subscriber fees, partial payments, arrears and zone search.
- Recycling weigh-ins for PET, cardboard, scrap metal and glass with estimated buyer value.
- Manager / crew role switch, three display themes and CSV export.
- Local persistence using SharedPreferences; records remain available offline on the device.
- Responsive Flutter web and Android interfaces.

## Run and build
```bash
flutter pub get
flutter run
flutter build web --release --base-href /
flutter build apk --release
```

## Vercel
Set Build Command to `flutter pub get && flutter build web --release --base-href /` and Output Directory to `build/web`. Vercel build images do not all include Flutter; use a custom build environment or build the web output in GitHub Actions and deploy that artifact.

## Android APK
Every push builds an APK artifact in GitHub Actions. To publish a stable download, create a tag:
```bash
git tag v1.0.0
git push origin v1.0.0
```
The release workflow attaches the APK to [GitHub Releases](https://github.com/kennedy-blip/Taka-track/releases/latest).

## Production hardening
This is a single-device offline starter. Role switching is a local UI gate, not authentication. Before handling real customer/payment data, add authenticated identities, server-side authorization, encrypted local storage, audit trails, backups and a conflict-aware sync service.
