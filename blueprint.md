# Project Blueprint: Text Translation App

## Overview

This document outlines the plan for creating a Flutter application that provides on-the-fly text translation from English to various Indian languages. The application will integrate with the Android `PROCESS_TEXT` feature, allowing users to select text in any app and get a translation in an overlay.

## Style, Design, and Features

### Core Functionality
- **Translate on the Go:** Users can select text in any application, and a translation option will appear in the context menu.
- **Language Support:** The app will support translation from English to several Indian languages (e.g., Hindi, Bengali, Tamil, Telugu).
- **Overlay UI:** The translation will be displayed in a clean, non-intrusive overlay (likely a bottom sheet) on top of the current application.
- **Copy Translation:** Users can easily copy the translated text to their clipboard.

### User Interface (UI)
- **Modern Aesthetics:** The UI will follow Material Design 3 principles, using modern components, clean spacing, and a visually balanced layout.
- **Theming:** The app will support both light and dark modes, with a theme toggle. A color scheme will be generated from a seed color (`Colors.deepPurple`).
- **Typography:** Custom fonts will be used via the `google_fonts` package to enhance readability and visual appeal.
- **Iconography:** Intuitive icons will be used for actions like copying text and changing themes.

### Architecture
- **State Management:** `provider` will be used for managing the theme and other application-wide state.
- **Routing:** `go_router` will be used for navigation, which is ideal for handling the initial route when the app is launched from the `PROCESS_TEXT` intent.
- **Platform Integration:** A custom Android Activity will be created to handle the `PROCESS_TEXT` intent. A platform channel will be used to pass the selected text from the native Android side to the Flutter UI.
- **Translation Engine:** The `google_mlkit_translation` package will be used to perform the on-device translation.

## Current Plan

1.  **Setup Dependencies:** Add `google_mlkit_translation`, `provider`, `go_router`, and `google_fonts` to `pubspec.yaml`.
2.  **Android Configuration:**
    - Create a custom `ProcessTextActivity.kt` to handle the `PROCESS_TEXT` intent.
    - Register this activity in `AndroidManifest.xml`.
    - Implement a platform channel in `ProcessTextActivity.kt` to send the selected text to Flutter.
3.  **Flutter Implementation:**
    - **Routing:** Configure `go_router` with two routes: a home screen (`/`) and a translation screen (`/translate`).
    - **Theming:** Implement a `ThemeProvider` and define light and dark themes in `lib/main.dart`.
    - **Home Screen:** Create a simple home screen that explains how to use the app.
    - **Translation Screen:**
        - This screen will be launched when the app is triggered by the `PROCESS_TEXT` intent.
        - It will receive the selected text via the platform channel.
        - It will feature a dropdown to select the target language.
        - It will display the original and translated text.
        - A "Copy" button will be included.
    - **Translation Service:** Create a service class to manage the `google_mlkit_translation` logic, including model downloads.
4.  **Iterative Development:** After each major step, check for errors, format the code, and ensure the app remains in a runnable state.
