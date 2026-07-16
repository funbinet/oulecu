# OULECU - Offline Image Card Generator

<p align="center">
  <img src="assets/images/logo.png" width="120" alt="OULECU Logo">
</p>

<p align="center">
  <b>Create stunning image cards offline with extensive customization</b>
</p>

<p align="center">
  <a href="#features">Features</a> |
  <a href="#screenshots">Screenshots</a> |
  <a href="#installation">Installation</a> |
  <a href="#building">Building</a> |
  <a href="#signing">Signing</a> |
  <a href="#publishing">Publishing</a>
</p>

---

## Overview

**OULECU** is a powerful offline image card generator built with Flutter. It features a sleek black and gold AMOLED theme with a hacker monospace aesthetic, allowing you to create beautiful, customized image cards completely offline.

**Creator**: OULEC  
**Version**: 1.0.0  
**License**: MIT

---

## Features

### Core Features
- **Offline-first** - No internet connection required, all processing happens on-device
- **Complete content creation** with topic, subtopic, and rich text content
- **Image integration** - Insert images from gallery or camera into your cards, which seamlessly scale into your design
- **30 built-in templates** across 8 categories (Nature, Tech, Finance, Creative, Bible, Luxury, Academic, Other)
- **Dynamic template rendering** - The generated image respects the full color palette and styling of your chosen template
- **Full customization** - Background, text, colors, borders, shadows, corners, dimensions, and precise logo placements
- **Export formats** - PNG, JPG, JPEG, WebP with adjustable quality
- **Hashtag management** - Preloaded with 50 tags, add your own, max 10 per card
- **Link attachment** - Add clickable links to your cards
- **Live preview** - See changes in real-time as you design

### Design Features
- **Dark Mode & AMOLED toggles** - Switch between a standard sleek Dark Theme or a true Pitch Black AMOLED mode
- **7 monospace fonts** - JetBrains Mono, Fira Code, Source Code Pro, Hack, Ubuntu Mono, and more
- **9 corner styles** - None, Rounded, Beveled, Scalloped, Inverted, Zigzag, Hexagon, Star, Wave
- **Full color control** - Custom color picker with hex input for all elements
- **Border & shadow** - Customizable width, color, style, and shadow effects
- **Gradient backgrounds** - Optional gradient end color for stunning effects

### App Features
- **4 main tabs** - Home, My Content, Settings, Profile
- **Persistent storage** - SQLite database for card metadata, SharedPreferences for settings
- **Storage management** - Easily clear temporary cache to free up device space
- **Content gallery** - Browse, view, share, and delete generated cards
- **Statistics tracking** - Cards generated, tags used, days active
- **Customizable profile** - Avatar, name, handle
- **Presets & Configurations** - Save and load design configurations, and globally apply preferences
- **Undo/Redo** - Full undo/redo support in content editing

---

## Screenshots

| Home Screen | Hashtag Screen | Design Screen |
|:---:|:---:|:---:|
| Create content | Add hashtags & links | Customize every detail |

| Template Screen | Preview Screen | Profile Screen |
|:---:|:---:|:---:|
| Choose from 30 templates | Preview before generating | Stats & creator info |

---

## Tech Stack

- **Framework**: Flutter 3.16+ (Dart 3.0+)
- **State Management**: Provider
- **Image Processing**: `dart:ui` canvas rendering, `image` package
- **Local Storage**: SQLite (sqflite), SharedPreferences
- **File Management**: path_provider, permission_handler
- **Image Picker**: image_picker, image_cropper
- **Sharing**: share_plus

---

## Project Structure

```
oulecu/
├── android/                          # Android platform files
│   └── app/
│       └── src/
│           └── main/
│               ├── AndroidManifest.xml
│               ├── kotlin/           # Kotlin main activity
│               └── res/              # App icons & resources
├── assets/
│   ├── fonts/                        # Monospace fonts (JetBrains, Fira, etc.)
│   ├── icons/                        # App icon variants (5 options)
│   ├── images/                       # Logo & branding images
│   └── templates/                    # Template assets by category
│       ├── nature/
│       ├── tech/
│       ├── finance/
│       ├── creative/
│       ├── bible/
│       ├── luxury/
│       ├── academic/
│       └── other/
├── lib/
│   ├── main.dart                     # App entry point
│   ├── screens/                      # All UI screens
│   │   ├── main_screen.dart          # Main container with bottom nav
│   │   ├── home_screen.dart          # Content creation
│   │   ├── hashtag_screen.dart       # Hashtag & link selection
│   │   ├── edit_screen.dart          # Profile & display editing
│   │   ├── design_screen.dart        # Card design customization
│   │   ├── template_screen.dart      # Template selection (30 templates)
│   │   ├── preview_screen.dart       # Card preview & export format
│   │   ├── generation_screen.dart    # Loading & generation
│   │   ├── content_screen.dart       # Gallery of generated cards
│   │   ├── settings_screen.dart      # App settings
│   │   └── profile_screen.dart       # User profile & stats
│   ├── widgets/                      # Reusable UI components
│   │   ├── bottom_nav.dart           # Bottom navigation bar
│   │   ├── gold_input.dart           # Themed text inputs
│   │   ├── text_editor_tools.dart    # Bold, italic, align toolbar
│   │   ├── loading_animation.dart    # Hacker-style loading
│   │   ├── custom_button.dart        # Gold themed buttons
│   │   ├── template_card.dart        # Template grid card
│   │   └── color_picker.dart         # Color picker widget
│   ├── models/                       # Data models
│   │   ├── card_config.dart          # Card configuration
│   │   ├── template.dart             # Template model
│   │   ├── preset.dart               # Saved preset model
│   │   └── user_profile.dart         # User profile model
│   ├── services/                     # Business logic
│   │   ├── render_service.dart       # Image rendering engine
│   │   ├── storage_service.dart      # File & database operations
│   │   ├── settings_service.dart     # SharedPreferences wrapper
│   │   ├── template_service.dart     # 30 template definitions
│   │   └── hashtag_service.dart      # Hashtag management
│   ├── providers/                    # State management
│   │   ├── app_state_provider.dart   # App workflow state
│   │   └── theme_provider.dart       # Theme state
│   ├── theme/
│   │   └── app_theme.dart            # Black & gold theme definition
│   └── utils/
│       └── constants.dart            # App constants & defaults
├── pubspec.yaml                      # Dependencies
├── analysis_options.yaml             # Lint rules
└── README.md                         # This file
```

---

## Installation

### Prerequisites

- **Flutter SDK** 3.16 or higher
- **Dart SDK** 3.0 or higher
- **Android Studio** or **VS Code** with Flutter extension
- **JDK** 17 or higher
- **Git**

### Setup

1. **Clone the repository**

```bash
git clone https://github.com/funbinet/oulecu.git
cd oulecu
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Add font files** (Optional - for custom fonts)

Place your monospace font files (`.ttf`) in `assets/fonts/`:
- JetBrainsMono-Regular.ttf, JetBrainsMono-Bold.ttf
- FiraCode-Regular.ttf, FiraCode-Bold.ttf
- SourceCodePro-Regular.ttf, SourceCodePro-Bold.ttf
- Hack-Regular.ttf, Hack-Bold.ttf
- UbuntuMono-Regular.ttf, UbuntuMono-Bold.ttf

4. **Run the app**

```bash
flutter run
```

---

## Building

### Debug Build

```bash
flutter build apk --debug
```

### Release Build (Unsigned)

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### App Bundle (for Google Play)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### Build for Specific ABI

```bash
# ARM64 only (recommended for modern devices)
flutter build apk --release --target-platform android-arm64

# All ABIs (larger file size)
flutter build apk --release --split-per-abi
```

---

## Signing

### Step 1: Generate a Keystore

Create a Java keystore file for signing your APK:

```bash
keytool -genkey -v -keystore ~/oulecu-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias oulecu
```

You will be prompted for:
- **Keystore password** - Choose a strong password
- **Key password** - Can be same as keystore password
- **Your name, organization, city, state, country** - Fill in your details
- **Confirm** - Type "yes"

> **IMPORTANT**: Keep your `oulecu-release-key.jks` file and passwords safe. You cannot update your app on Google Play without the same keystore.

### Step 2: Create key.properties

Create `android/key.properties`:

```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=oulecu
storeFile=/home/YOUR_USERNAME/oulecu-release-key.jks
```

**Windows users**:
```properties
storePassword=YOUR_KEYSTORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=oulecu
storeFile=C:/Users/YOUR_USERNAME/oulecu-release-key.jks
```

> **WARNING**: Add `android/key.properties` to your `.gitignore`. Never commit this file.

### Step 3: Configure build.gradle

Open `android/app/build.gradle` and add:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    // ... existing config ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            shrinkResources true
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }
}
```

### Step 4: Build Signed APK

```bash
flutter build apk --release
```

The signed APK will be at:
`build/app/outputs/flutter-apk/app-release.apk`

### Step 5: Verify Signature

```bash
cd android
./gradlew verifyReleaseResources
```

Or check the APK:
```bash
jarsigner -verify -verbose -certs build/app/outputs/flutter-apk/app-release.apk
```

---

## Publishing

### Method 1: Direct APK Distribution

1. **Rename the APK**
   ```bash
   mv build/app/outputs/flutter-apk/app-release.apk OULECU-v1.0.0.apk
   ```

2. **Upload to distribution platforms**
   - GitHub Releases
   - Codeberg Releases
   - Your website
   - File sharing services

3. **Users install by**
   - Downloading the APK
   - Enabling "Install from Unknown Sources" in Settings > Security
   - Opening the APK file
   - Following installation prompts

### Method 2: Google Play Store

1. **Create a Google Play Developer account** at [play.google.com/console](https://play.google.com/console) ($25 one-time fee)

2. **Prepare store listing**
   - App name: OULECU
   - Short description: Offline image card generator with black & gold theme
   - Full description: (See below)
   - Screenshots (phone & tablet)
   - Feature graphic (1024x500)
   - App icon (512x512)

3. **Build App Bundle**
   ```bash
   flutter build appbundle --release
   ```

4. **Upload to Play Console**
   - Create new app
   - Upload `app-release.aab`
   - Fill in store listing
   - Set pricing (Free)
   - Select content rating
   - Publish

### Method 3: Alternative App Stores

- **F-Droid**: Submit via [f-droid.org/en/contribute](https://f-droid.org/en/contribute/)
- **Amazon Appstore**: [developer.amazon.com](https://developer.amazon.com/)
- **APKPure**, **Aptoide**: Direct upload

### Method 4: GitHub & Codeberg Releases

1. **Create a release on GitHub**
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```
   Then create release at `github.com/funbinet/oulecu/releases`

2. **Create a release on Codeberg**
   ```bash
   git push codeberg v1.0.0
   ```
   Then create release at `codeberg.org/funbinet/oulecu/releases`

3. **Attach the signed APK** to both releases

---

## Store Listing Description

### Short Description (80 chars)
Offline image card generator with black & gold AMOLED theme. No internet needed!

### Full Description
```
OULECU - The Ultimate Offline Image Card Generator

Create stunning, customized image cards completely offline. No internet connection required - all processing happens on your device for maximum privacy.

FEATURES:
- 30 professional templates across 8 categories
- Full customization: colors, fonts, borders, shadows, corners
- Rich text editing with bold, italic, alignment
- Image insertion from gallery or camera
- Hashtag management with 50+ preloaded tags
- Link attachment support
- Live preview before generating
- Export to PNG, JPG, JPEG, or WebP
- Black & gold AMOLED theme
- 7 monospace font options
- Gallery with share and delete options

PERFECT FOR:
- Social media content creators
- Developers sharing code snippets
- Designers showcasing work
- Anyone who needs beautiful image cards

PRIVACY:
- 100% offline - no data leaves your device
- No internet permissions required
- No data collection or tracking

CONTACT:
- Email: funbinet@gmail.com
- GitHub: github.com/funbinet
- Codeberg: codeberg.org/funbinet

Built with Flutter. Open source.
```

---

## Configuration

### Minimum Requirements
- Android 8.0 (API 26) or higher
- 150MB free storage
- 2GB RAM recommended

### Supported Screen Sizes
- Phones: 4.0" - 7.0"
- Tablets: 7.0" - 12.0"

---

## Development

### Running Tests
```bash
flutter test
```

### Code Analysis
```bash
flutter analyze
```

### Format Code
```bash
dart format .
```

### Hot Reload
```bash
# In terminal while app is running
r  # hot reload
R  # hot restart
```

---

## Contributing

We welcome contributions! Here's how to get started:

1. Fork the repository on GitHub or Codeberg
2. Create a feature branch: `git checkout -b feature-name`
3. Make your changes
4. Commit: `git commit -am 'Add new feature'`
5. Push: `git push origin feature-name`
6. Create a Pull Request

### Reporting Issues
- GitHub Issues: [github.com/funbinet/oulecu/issues](https://github.com/funbinet/oulecu/issues)
- Codeberg Issues: [codeberg.org/funbinet/oulecu/issues](https://codeberg.org/funbinet/oulecu/issues)
- Email: funbinet@gmail.com

---

## Roadmap

- [ ] iOS version
- [ ] Cloud backup of presets
- [ ] Social media direct sharing
- [ ] QR code generation
- [ ] Video card generation
- [ ] AI-powered background suggestions
- [ ] More template categories
- [ ] Custom font import
- [ ] Batch export
- [ ] Watermark options

---

## Contact & Feedback

| Platform | Link |
|----------|------|
| Email | funbinet@gmail.com |
| GitHub | [github.com/funbinet](https://github.com/funbinet) |
| Codeberg | [codeberg.org/funbinet](https://codeberg.org/funbinet) |

---

## Acknowledgments

- Built with [Flutter](https://flutter.dev)
- Fonts: JetBrains Mono, Fira Code, Source Code Pro, Hack, Ubuntu Mono
- Icons: Material Design Icons

---

<p align="center">
  <b>Made with passion by OULEC</b>
</p>
