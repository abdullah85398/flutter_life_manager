# CI/CD Setup

This directory contains GitHub Actions workflows for automated building, testing, and deployment.

## Workflows

### Flutter CI (`flutter_ci.yml`)
- **Triggers**: Push/PR to `main` or `develop` branches
- **Jobs**:
  - **Test**: Runs formatting checks, static analysis, and unit tests
  - **Build**: Creates APK and Web builds, uploads as artifacts

### Firebase Functions CI/CD (`firebase_functions_ci.yml`)
- **Triggers**: Push/PR to `main` or `develop` branches with changes in `functions/` directory
- **Jobs**:
  - **Lint and Test**: Runs ESLint and Jest tests on Cloud Functions
  - **Deploy**: Deploys functions to Firebase (only on `main` branch pushes)

## Setup Requirements

### For Flutter CI
- No additional setup required
- Uses Flutter 3.24.0 stable channel

### For Firebase Functions CI/CD
1. **Firebase Token**: Add `FIREBASE_TOKEN` to repository secrets
   ```bash
   firebase login:ci
   ```
   Copy the generated token and add it to GitHub repository secrets

2. **Project Configuration**: Ensure `firebase.json` is properly configured

3. **Functions Dependencies**: The workflow expects:
   - `functions/package.json` with proper scripts
   - `functions/tsconfig.json` for TypeScript compilation
   - `functions/.eslintrc.js` for linting configuration

## Local Development

### Functions
```bash
cd functions
npm install
npm run build
npm test
npm run lint
```

### Flutter
```bash
flutter pub get
flutter analyze
flutter test
flutter build apk
flutter build web
```

## Deployment

- **Flutter**: Builds are created as artifacts on every push
- **Functions**: Automatic deployment to Firebase on `main` branch pushes
- **Manual deployment**: Use `firebase deploy --only functions`