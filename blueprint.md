# Project Blueprint: Text Translation App

## Overview

This document outlines the plan for creating a Flutter application that provides on-the-fly text translation from English to various Indian languages. The application will integrate with the Android `PROCESS_TEXT` feature and also offer a dedicated in-app translation screen.

## Style, Design, and Features

### Core Functionality
- **Translate on the Go:** Users can select text in any application, and a translation option will appear in the context menu.
- **In-App Translation:** A dedicated screen allows users to type or paste text for instant translation, similar to a keyboard translation feature.
- **Language Support:** The app will support translation from English to several Indian languages (e.g., Hindi, Bengali, Tamil, Telugu).
- **Overlay UI:** The `PROCESS_TEXT` translation is displayed in a clean, non-intrusive overlay.
- **Action Toolbar:** Both translation interfaces will include actions like "Copy" and "Clear."

### User Interface (UI)
- **Modern Aesthetics:** The UI will follow Material Design 3 principles, using modern components, clean spacing, and a visually balanced layout.
- **Theming:** The app will support both light and dark modes, with a theme toggle. A color scheme will be generated from a seed color (`Colors.deepPurple`).
- **Typography:** Custom fonts will be used via the `google_fonts` package to enhance readability and visual appeal.
- **Iconography:** Intuitive icons will be used for actions like copying text, clearing text, and navigating the app.

### Architecture
- **State Management:** `provider` will be used for managing the theme and other application-wide state.
- **Routing:** `go_router` will be used for navigation between the home screen, the `PROCESS_TEXT` translation screen, and the new in-app translation screen.
- **Platform Integration:** A custom Android Activity handles the `PROCESS_TEXT` intent, with a platform channel to communicate with the Flutter UI.
- **Translation Engine:** The `google_mlkit_translation` package will be used to perform the on-device translation.

## Current Plan

1.  **Create the In-App Translation Screen:**
    - Design and build a new screen in `lib/in_app_translation_screen.dart`.
    - This screen will feature:
        - A `TextField` for user input.
        - A real-time character counter.
        - A dropdown for selecting the target language.
        - An action toolbar with "Copy" and "Clear" buttons.
        - A display area for the translated text.
2.  **Update Navigation:**
    - Add a new route for the in-app translation screen in `go_router` in `lib/main.dart`.
    - Add a button or navigation element to the `HomeScreen` to allow users to access this new screen.
3.  **Refine and Test:**
    - Ensure the new screen is fully functional and visually consistent with the rest of the app.
    - Test both the in-app translation and the `PROCESS_TEXT` feature.
