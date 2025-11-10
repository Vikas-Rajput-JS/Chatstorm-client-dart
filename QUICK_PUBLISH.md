# Quick Publishing Guide

## ✅ Pre-Publish Checklist

Your package is ready! The dry-run passed with **0 warnings**.

## 🚀 Quick Publish Steps

### 1. Authenticate (First time only)

```bash
# Option 1: Browser authentication (recommended)
flutter pub publish
# This will open your browser for authentication

# Option 2: Token authentication
dart pub token add https://pub.dartlang.org
# Paste your token from https://pub.dev (Account Settings > Uploaders)
```

### 2. Publish

```bash
cd /home/esfera/Development/Packages/chatstorm-client-dart
flutter pub publish
```

Type `y` when prompted to confirm.

### 3. Verify

Visit: https://pub.dev/packages/chatstorm_client

---

## 📝 Before Publishing

1. **Check package name availability**: https://pub.dev/packages/chatstorm_client
2. **Update version** if needed in `pubspec.yaml`
3. **Update CHANGELOG.md** with changes
4. **Verify GitHub repository** URL is correct in `pubspec.yaml`

## 🔄 For Updates

1. Update version in `pubspec.yaml`:
   ```yaml
   version: 1.0.1  # Increment version
   ```

2. Update CHANGELOG.md

3. Publish:
   ```bash
   flutter pub publish
   ```

---

## 📚 Full Guide

See `PUBLISHING.md` for detailed instructions.

