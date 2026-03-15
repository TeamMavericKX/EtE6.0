# EASE THE ERROR 6.0 - DATA COMMAND CENTER

This is the primary data repository for Ease The Error 6.0 (EtE 6.0). It contains the technical audit data, team records, and mentor feedback for the final 31 teams.

## REPOSITORY STRUCTURE
- **main**: Primary data hub and source of truth for team rosters and reports. Now integrated with the sentinel-6 high-fidelity audit application.
- **sentinel-6**: High-fidelity multi-platform audit application (Flutter).
- **technical-audit**: Detailed visual evaluations and page-by-page scoring.

## CORE DATASETS
- **Team_Data.md**: Master list of final teams, leaders, and problem statements.
- **Team Analysis Files**: Individual markdown reports for each team, including technical logic audits and identified potential failure points.

---

# SENTINEL_6 - BRUTALIST AUDIT ENGINE

SENTINEL_6 is a high-fidelity mentor interface built for Ease The Error 6.0. It is designed for rapid technical auditing and evaluation of 31 engineering teams.

## UI ARCHITECTURE
- **Brutalist Design**: Pure high-contrast palette with thick borders and zero blur.
- **Identity Integration**: Dynamic GitHub handle capture for session initialization.
- **Elastic Interface**: Staggered list animations with scale-down entry physics.
- **Responsive Core**: Adaptive layout optimized for mobile and desktop split-pane views.

## MULTI-PLATFORM DISTRIBUTION
This repository includes a CI/CD pipeline configured for the following targets:
- **Web**: Deployed via Vercel at https://ete60.vercel.app
- **Android**: APK release.
- **Linux**: Desktop bundle.
- **Windows**: Executable runner.

## TECH STACK
- **Framework**: Flutter (Stable)
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Authentication**: GitHub Identity (Pure Web Implementation)
- **Deployment**: Vercel + GitHub Actions

## OPERATIONAL GUIDE
1. **SIGN IN**: Authenticate with your GitHub handle to start the session.
2. **AUDIT LOG**: Access the system index to view the 31 teams.
3. **FAILURE TRACKER**: Toggle identified failures as teams resolve them during the hackathon.
4. **COMMIT LOG**: Log technical remarks in the terminal panel. All history is scrollable and persistent.

Developed by princetheprogrammerbtw.
OFFICIAL REPOSITORY FOR EASE THE ERROR 6.0.
