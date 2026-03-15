# SENTINEL_6 - BRUTALIST AUDIT ENGINE

SENTINEL_6 is a high-fidelity mentor interface built for Ease The Error 6.0. It is designed for rapid technical auditing and evaluation of 31 engineering teams.

## UI ARCHITECTURE
- Brutalist Design: Pure high-contrast palette with thick borders and zero blur.
- Identity Integration: Dynamic GitHub handle capture for session initialization.
- Elastic Interface: Staggered list animations with scale-down entry physics.
- Responsive Core: Adaptive layout optimized for mobile and desktop split-pane views.

## MULTI-PLATFORM DISTRIBUTION
This repository includes a CI/CD pipeline configured for the following targets:
- Web: Deployed via Vercel.
- Android: APK release.
- Linux: Desktop bundle.
- Windows: Executable runner.

## TECH STACK
- Framework: Flutter (Stable)
- State Management: Riverpod
- Navigation: GoRouter
- Authentication: GitHub Identity (Pure Web Implementation)
- Deployment: Vercel + GitHub Actions

## OPERATIONAL GUIDE
1. SIGN IN: Authenticate with your GitHub handle to start the session.
2. AUDIT LOG: Access the system index to view the 31 teams.
3. FAILURE TRACKER: Toggle identified failures as teams resolve them during the hackathon.
4. COMMIT LOG: Log technical remarks in the terminal panel. All history is scrollable and persistent.

Developed by princetheprogrammerbtw.
PROPRIETARY TO EASE THE ERROR 6.0.
