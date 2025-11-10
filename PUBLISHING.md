# Publishing Guide for ChatStorm Client Dart Package

This guide will walk you through the process of publishing the `chatstorm_client` package to [pub.dev](https://pub.dev).

## 📋 Prerequisites

1. **Dart SDK**: Make sure you have Dart SDK installed (comes with Flutter)
   ```bash
   dart --version
   ```

2. **pub.dev Account**: Create an account at [pub.dev](https://pub.dev)
   - Go to https://pub.dev
   - Sign in with Google account
   - Verify your email

3. **Google Account**: You need a Google account to publish packages

## 🔍 Pre-Publishing Checklist

Before publishing, make sure:

- [ ] Package name is available on pub.dev (check at https://pub.dev/packages/chatstorm_client)
- [ ] All code is properly documented
- [ ] README.md is complete and accurate
- [ ] CHANGELOG.md is updated
- [ ] LICENSE file is present
- [ ] pubspec.yaml is correctly configured
- [ ] Package passes all checks

## 📝 Step-by-Step Publishing Process

### Step 1: Verify Package Name Availability

Check if the package name `chatstorm_client` is available:

```bash
# Visit https://pub.dev/packages/chatstorm_client
# Or use the pub.dev search
```

If the name is taken, you'll need to change it in `pubspec.yaml`:
```yaml
name: chatstorm_client  # Change this if needed
```

### Step 2: Update pubspec.yaml

Make sure your `pubspec.yaml` has all required fields:

```yaml
name: chatstorm_client
description: A real-time chat client built using Socket.IO for Flutter applications...
version: 1.0.0
homepage: https://github.com/Vikas-Rajput-JS/Chatstorm-client-dart
repository: https://github.com/Vikas-Rajput-JS/Chatstorm-client-dart  # Add this
```

**Important fields:**
- `name`: Must be lowercase with underscores
- `description`: Should be clear and descriptive (max 60 characters recommended)
- `version`: Follow semantic versioning (major.minor.patch)
- `homepage`: Your GitHub repository URL
- `repository`: (Optional but recommended) GitHub repository URL

### Step 3: Run Pre-Publish Checks

Navigate to your package directory:

```bash
cd /home/esfera/Development/Packages/chatstorm-client-dart
```

Run the following commands to verify your package:

#### 3.1. Analyze the code
```bash
flutter analyze
```

#### 3.2. Run tests (if you have any)
```bash
flutter test
```

#### 3.3. Format the code
```bash
dart format lib/
```

#### 3.4. Dry run publish (VERY IMPORTANT)
```bash
flutter pub publish --dry-run
```

This will check for:
- ✅ Package structure
- ✅ pubspec.yaml validity
- ✅ File size limits
- ✅ Required files presence
- ✅ Documentation completeness

**Fix any issues reported before proceeding!**

### Step 4: Authenticate with pub.dev

#### 4.1. Get your authentication token

1. Go to https://pub.dev
2. Sign in with your Google account
3. Go to your account settings
4. Click on "Create token" or "Uploaders" tab
5. Copy the token (you'll only see it once!)

#### 4.2. Authenticate locally

```bash
dart pub token add https://pub.dartlang.org
```

When prompted, paste your token from step 4.1.

**Alternative method:**
```bash
flutter pub publish
```
This will prompt you to authenticate via browser if not already authenticated.

### Step 5: Publish the Package

Once all checks pass, publish:

```bash
flutter pub publish
```

You'll be asked to confirm:
```
Publishing chatstorm_client 1.0.0 to https://pub.dartlang.org:
|-- CHANGELOG.md
|-- LICENSE
|-- README.md
|-- lib/
|   |-- chatstorm_client.dart
|   |-- src/
|       |-- chat_socket.dart
|       |-- models.dart
|-- pubspec.yaml

Looks good! Are you ready to upload? (y/N):
```

Type `y` and press Enter.

### Step 6: Verify Publication

After publishing:

1. Visit https://pub.dev/packages/chatstorm_client
2. Your package should appear within a few minutes
3. Check that all files are correctly displayed

## 🔄 Updating the Package

When you need to publish an update:

1. **Update version** in `pubspec.yaml`:
   ```yaml
   version: 1.0.1  # Increment based on changes
   ```

2. **Update CHANGELOG.md** with new changes

3. **Run checks again**:
   ```bash
   flutter pub publish --dry-run
   ```

4. **Publish**:
   ```bash
   flutter pub publish
   ```

### Version Numbering

Follow [Semantic Versioning](https://semver.org/):
- **MAJOR** (1.0.0 → 2.0.0): Breaking changes
- **MINOR** (1.0.0 → 1.1.0): New features, backward compatible
- **PATCH** (1.0.0 → 1.0.1): Bug fixes, backward compatible

## 🐛 Common Issues and Solutions

### Issue: "Package name already taken"
**Solution**: Change the name in `pubspec.yaml` to something unique

### Issue: "Package too large"
**Solution**: 
- Remove unnecessary files
- Add them to `.gitignore` or `.pubignore`
- Maximum package size is 100MB

### Issue: "Missing required files"
**Solution**: Ensure you have:
- ✅ README.md
- ✅ CHANGELOG.md
- ✅ LICENSE
- ✅ lib/ directory with Dart files

### Issue: "Analysis errors"
**Solution**: 
```bash
flutter analyze
# Fix all errors and warnings
dart fix --apply  # Auto-fix some issues
```

### Issue: "Authentication failed"
**Solution**:
```bash
# Remove old token
dart pub token remove https://pub.dartlang.org

# Add new token
dart pub token add https://pub.dartlang.org
```

## 📦 Creating .pubignore File (Optional)

Create a `.pubignore` file to exclude files from publishing:

```
# Example .pubignore
example/
test/
.git/
.gitignore
*.md
!README.md
!CHANGELOG.md
```

## ✅ Post-Publishing

After successful publication:

1. **Share the package**: 
   ```yaml
   dependencies:
     chatstorm_client: ^1.0.0
   ```

2. **Add badges** to your README.md:
   ```markdown
   [![pub package](https://img.shields.io/pub/v/chatstorm_client.svg)](https://pub.dev/packages/chatstorm_client)
   ```

3. **Update documentation** with pub.dev link

4. **Monitor**: Check pub.dev for any issues or user feedback

## 🔗 Useful Links

- [pub.dev](https://pub.dev)
- [Pub Package Layout Conventions](https://dart.dev/tools/pub/package-layout)
- [Pubspec Format](https://dart.dev/tools/pub/pubspec)
- [Semantic Versioning](https://semver.org/)

## 📞 Support

If you encounter issues during publishing:
- Check [pub.dev help](https://pub.dev/help)
- Review [Dart documentation](https://dart.dev/tools/pub/publishing)
- Check package validation errors carefully

---

**Good luck with your publication! 🚀**

