# Appetize Deployment Workflow Architecture

## 🔄 Workflow Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     TRIGGER EVENT                                │
│  (Pull Request to master/main or Manual dispatch)               │
└────────────────────────┬────────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    SETUP ENVIRONMENT                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Checkout     │  │ Setup Java   │  │ Setup Flutter │         │
│  │ Repository   │→ │ JDK 17 (Zulu)│→ │ 3.35.6 Stable│         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RESTORE CACHES                                │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Flutter SDK  │  │ Pub Cache    │  │ Gradle Cache │         │
│  │ Cache        │  │              │  │              │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
│  Cache Hit?  YES → Fast Build (3-5 min)                        │
│              NO  → Full Build (10-15 min)                       │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                  FIREBASE CONFIGURATION                          │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Install      │→ │ Install      │→ │ Configure    │         │
│  │ Firebase CLI │  │ FlutterFire  │  │ Firebase     │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                              │                   │
│  Generates: firebase_options.dart, google-services.json, etc.   │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    BUILD PROCESS                                 │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ flutter      │→ │ flutter pub  │→ │ flutter      │         │
│  │ doctor -v    │  │ get          │  │ analyze      │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                              │                   │
│                                              ▼                   │
│                                    ┌──────────────┐             │
│                                    │ flutter build│             │
│                                    │ apk --release│             │
│                                    └──────────────┘             │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    POST-BUILD ACTIONS                            │
│  ┌──────────────┐  ┌──────────────┐                            │
│  │ Rename APK   │→ │ Upload as    │                            │
│  │ with Version │  │ Artifact     │                            │
│  └──────────────┘  └──────────────┘                            │
│                                                                  │
│  APK Name: hasper_ebook_admin-{VERSION}.apk (from pubspec.yaml) │
│  Retention: 30 days                                             │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                APPETIZE DEPLOYMENT LOGIC                         │
│                                                                  │
│  Check: Does APPETIZE_PUBLIC_KEY exist?                         │
│                                                                  │
│  ┌───────────────────────┐    ┌──────────────────────┐         │
│  │ NO (First Time)       │    │ YES (Update)         │         │
│  │                       │    │                      │         │
│  │ ┌─────────────────┐   │    │ ┌────────────────┐  │         │
│  │ │ POST /v1/apps   │   │    │ │ POST           │  │         │
│  │ │ (New Upload)    │   │    │ │ /v1/apps/{key} │  │         │
│  │ └────────┬────────┘   │    │ └────────┬───────┘  │         │
│  │          │            │    │          │          │         │
│  │          ▼            │    │          ▼          │         │
│  │ ┌─────────────────┐   │    │ ┌────────────────┐  │         │
│  │ │ Get Public Key  │   │    │ │ Update Existing│  │         │
│  │ │ Display Warning │   │    │ │ App            │  │         │
│  │ └─────────────────┘   │    │ └────────────────┘  │         │
│  └───────────────────────┘    └──────────────────────┘         │
└────────────────────────────┬────────────────────────────────────┘
                             │
                             ▼
┌─────────────────────────────────────────────────────────────────┐
│                    GENERATE OUTPUTS                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐         │
│  │ Workflow     │  │ PR Comment   │  │ Deployment   │         │
│  │ Summary      │  │ (if PR)      │  │ Info         │         │
│  └──────────────┘  └──────────────┘  └──────────────┘         │
│                                                                  │
│  Contains:                                                       │
│  • Build information                                            │
│  • APK download link                                            │
│  • Public key                                                   │
│  • App URL for testing                                          │
│  • Setup instructions (if first time)                           │
└─────────────────────────────────────────────────────────────────┘
```

## 📦 Caching Strategy

```
┌──────────────────────────────────────────────────────────────┐
│                      CACHE LAYERS                             │
└──────────────────────────────────────────────────────────────┘

Layer 1: Flutter SDK Cache
├── Location: ${{ runner.tool_cache }}/flutter
├── Key: flutter-:os:-:channel:-:version:-:arch:-:hash:
├── Size: ~800 MB
└── Saves: 2-3 minutes per build

Layer 2: Pub Dependencies Cache  
├── Location: ~/.pub-cache, .dart_tool
├── Key: ${{ runner.os }}-pub-${{ hashFiles('**/pubspec.lock') }}
├── Size: ~100-500 MB
└── Saves: 1-2 minutes per build

Layer 3: Gradle Dependencies Cache
├── Location: ~/.gradle/caches, ~/.gradle/wrapper, ~/.android/build-cache
├── Key: ${{ runner.os }}-gradle-${{ hashFiles('**/*.gradle*', 'gradle-wrapper.properties') }}
├── Size: ~500 MB - 1 GB
└── Saves: 3-5 minutes per build

Layer 4: Java Distribution Cache
├── Location: Managed by setup-java action
├── Key: Auto-managed
├── Size: ~200 MB
└── Saves: 30-60 seconds per build

Total Time Saved: 7-11 minutes on subsequent builds!
```

## 🔐 Secret Management

```
┌──────────────────────────────────────────────────────────────┐
│                    GITHUB SECRETS                             │
└──────────────────────────────────────────────────────────────┘

Required Secrets:
┌─────────────────────────┐
│ FIREBASE_TOKEN          │  ← Required for Firebase config
│                         │    (Get via: firebase login:ci)
│ FIREBASE_PROJECT_ID     │  ← Your Firebase project ID
│                         │    (e.g., hasper-ebook)
│ APPETIZE_API_TOKEN      │  ← Required for Appetize deploy
│                         │    (Get from Appetize.io)
└─────────────────────────┘

Optional (After First Deployment):
┌─────────────────────────┐
│ APPETIZE_PUBLIC_KEY     │  ← Add after first successful run
│                         │    (Provided in workflow output)
└─────────────────────────┘

Secret Usage Flow:
1. Workflow authenticates with Firebase using FIREBASE_TOKEN
2. Configures Firebase for all platforms using FIREBASE_PROJECT_ID
3. Reads APPETIZE_API_TOKEN for Appetize authentication
4. Checks if APPETIZE_PUBLIC_KEY exists
   ├── NO  → Creates new app, returns public key
   └── YES → Updates existing app using public key
```

## 🎯 Decision Tree

```
                    Start Workflow
                         │
                         ▼
        ┌────────────────────────────────┐
        │  Is FIREBASE_TOKEN set?        │
        └────────────┬───────────────────┘
                     │
          ┌──────────┴──────────┐
          │ NO                  │ YES
          ▼                     ▼
    ┌──────────┐         ┌──────────┐
    │ Error    │         │ Continue │
    │ Exit     │         │          │
    └──────────┘         └────┬─────┘
                              │
                              ▼
        ┌────────────────────────────────┐
        │  Build APK successful?         │
        └────────────┬───────────────────┘
                     │
          ┌──────────┴──────────┐
          │ NO                  │ YES
          ▼                     ▼
    ┌──────────┐         ┌──────────┐
    │ Error    │         │ Upload   │
    │ Exit     │         │ Artifact │
    └──────────┘         └────┬─────┘
                              │
                              ▼
        ┌────────────────────────────────┐
        │  Does APPETIZE_PUBLIC_KEY      │
        │  exist in secrets?             │
        └────────────┬───────────────────┘
                     │
          ┌──────────┴──────────┐
          │ NO                  │ YES
          ▼                     ▼
    ┌──────────┐         ┌──────────┐
    │ Create   │         │ Update   │
    │ New App  │         │ Existing │
    └────┬─────┘         └────┬─────┘
         │                    │
         └────────┬───────────┘
                  │
                  ▼
        ┌──────────────┐
        │ Generate     │
        │ Summary &    │
        │ PR Comment   │
        └──────────────┘
```

## 📊 Build Timeline Comparison

```
First Build (No Cache):
┌────────────────────────────────────────────────────────────┐
│ Checkout           ████ 30s                                │
│ Setup Java         ██████████ 60s                          │
│ Setup Flutter      ████████████████████ 120s               │
│ Firebase Config    ████████████ 75s                        │
│ Flutter Doctor     ████ 20s                                │
│ Pub Get            ████████████ 80s                        │
│ Analyze            ████ 30s                                │
│ Gradle Build       ████████████████████████████ 180s       │
│ Flutter Build      ████████████████████████████████ 200s   │
│ Appetize Upload    ████████ 45s                            │
└────────────────────────────────────────────────────────────┘
Total: ~14 minutes

Subsequent Build (With Cache):
┌────────────────────────────────────────────────────────────┐
│ Checkout           ████ 30s                                │
│ Setup Java         ██ 15s (cached)                         │
│ Setup Flutter      ████ 25s (cached)                       │
│ Firebase Config    ██████ 35s                              │
│ Flutter Doctor     ██ 10s                                  │
│ Pub Get            ██ 15s (cached)                         │
│ Analyze            ██ 10s                                  │
│ Gradle Build       ████████ 45s (cached)                   │
│ Flutter Build      ████████████████ 90s                    │
│ Appetize Upload    ████████ 45s                            │
└────────────────────────────────────────────────────────────┘
Total: ~5.5 minutes

⚡ Speed Improvement: ~2.5x faster!
```

## 🔄 Continuous Deployment Flow

```
Developer                GitHub Actions              Appetize.io
    │                          │                         │
    │  Push/PR                 │                         │
    ├─────────────────────────>│                         │
    │                          │                         │
    │                          │  Checkout Code          │
    │                          ├──────────┐              │
    │                          │          │              │
    │                          │<─────────┘              │
    │                          │                         │
    │                          │  Setup Environment      │
    │                          ├──────────┐              │
    │                          │          │              │
    │                          │<─────────┘              │
    │                          │                         │
    │                          │  Build APK              │
    │                          ├──────────┐              │
    │                          │          │              │
    │                          │<─────────┘              │
    │                          │                         │
    │                          │  Upload/Update App      │
    │                          ├─────────────────────────>│
    │                          │                         │
    │                          │  Return App URL         │
    │                          │<─────────────────────────┤
    │                          │                         │
    │  Summary & PR Comment    │                         │
    │<─────────────────────────┤                         │
    │                          │                         │
    │  Test App                │                         │
    ├──────────────────────────┴─────────────────────────>│
    │                                                    │
```

## 🏗️ Project Context

### Application Architecture

**Hasper eBook Admin** is a Flutter-based administrative panel for managing the digital library using Firebase backend:

- **Frontend:** Flutter with Material Design
- **State Management:** Provider pattern
- **Database:** Cloud Firestore (book catalog and metadata management)
- **Storage:** Firebase Storage (PDF file uploads and management)
- **PDF Viewing:** Syncfusion Flutter PDF Viewer
- **Platforms:** Android, iOS, Web

### Key Features Tested

The Appetize deployment allows testing of:

- ✅ Book management (add, edit, delete)
- ✅ PDF file upload and preview
- ✅ Book metadata editing
- ✅ Image picker for cover photos
- ✅ File picker for PDF selection
- ✅ Real-time Firestore data synchronization
- ✅ Infinite scroll pagination
- ✅ Responsive layouts across devices

### Firebase Integration

The workflow builds an APK that connects to Firebase services:

- **Firestore:** Manages book catalog, metadata, and administrative operations
- **Storage:** Hosts PDF files and cover images
- **Security Rules:** Configured for admin-level access

### Dependencies

**Core Packages:**
- `cloud_firestore: ^5.6.12` - Firestore database integration
- `firebase_core: ^3.9.0` - Firebase initialization
- `firebase_storage: ^12.4.0` - File storage management
- `provider: ^6.1.2` - State management
- `syncfusion_flutter_pdfviewer: ^28.1.36` - PDF rendering
- `infinite_scroll_pagination: ^4.1.0` - Paginated lists
- `flutter_svg: ^2.0.16` - SVG asset support
- `file_picker: ^8.1.6` - PDF file selection
- `image_picker: ^1.1.2` - Cover image selection
- `connectivity_plus: ^6.1.1` - Network connectivity monitoring

## 📝 Setup Instructions

### Step 1: Get Firebase CI Token

1. Install Firebase CLI locally:
   ```bash
   npm install -g firebase-tools
   # or
   curl -sL https://firebase.tools | bash
   ```

2. Login and get CI token:
   ```bash
   firebase login:ci
   ```

3. Copy the token that appears

### Step 2: Get Appetize API Token

1. Go to [Appetize.io](https://appetize.io/)
2. Create an account or sign in
3. Navigate to Account Settings → API Token
4. Copy your API token

### Step 3: Add GitHub Secrets

1. Go to your repository: `Settings → Secrets and variables → Actions`
2. Click **New repository secret**
3. Add the following secrets:

   **FIREBASE_TOKEN**
   - **Name:** `FIREBASE_TOKEN`
   - **Value:** Your Firebase CI token from Step 1

   **FIREBASE_PROJECT_ID**
   - **Name:** `FIREBASE_PROJECT_ID`
   - **Value:** `hasper-ebook` (or your Firebase project ID)

   **APPETIZE_API_TOKEN**
   - **Name:** `APPETIZE_API_TOKEN`
   - **Value:** Your Appetize API token from Step 2

### Step 4: First Workflow Run

1. Create a Pull Request to the `master` or `main` branch
2. Or manually trigger the workflow: `Actions → Build Flutter APK and Deploy to Appetize → Run workflow`
3. Wait for the workflow to complete
4. Check the workflow summary for the public key

### Step 5: Save Public Key (First Time Only)

After the first successful run:

1. Copy the public key from the workflow summary
2. Go to `Settings → Secrets and variables → Actions`
3. Click **New repository secret**
4. Add:
   - **Name:** `APPETIZE_PUBLIC_KEY`
   - **Value:** The public key from step 1

### Step 6: Subsequent Runs

For all future runs:

- The workflow will automatically update the existing Appetize app
- No need to update the public key again
- Each build will be available at the same URL

## 🔍 Troubleshooting

### Build Failures

**Issue:** Gradle build fails
- **Solution:** Check `android/app/build.gradle` for correct SDK versions
- **Solution:** Verify Firebase secrets (`FIREBASE_TOKEN` and `FIREBASE_PROJECT_ID`) are set correctly
- **Note:** Project uses compileSdk 36 and targetSdk 36

**Issue:** Firebase configuration fails
- **Solution:** Ensure `FIREBASE_TOKEN` and `FIREBASE_PROJECT_ID` secrets are set in GitHub
- **Solution:** Verify Firebase project ID is correct (default: `hasper-ebook`)
- **Solution:** Check Firebase CLI authentication by reviewing workflow logs
- **Solution:** Ensure all Firebase app IDs are correctly configured

**Issue:** Flutter analyze fails
- **Solution:** Run `flutter analyze` locally to see specific issues
- **Note:** This step is set to `continue-on-error: true` so it won't fail the build

**Issue:** APK upload to Appetize fails
- **Solution:** Verify `APPETIZE_API_TOKEN` is valid
- **Solution:** Check Appetize account has sufficient quota
- **Solution:** Ensure APK size is within Appetize limits (typically < 100 MB)

### Cache Issues

**Issue:** Slow builds even with caching enabled
- **Solution:** Check cache hit rates in workflow logs
- **Solution:** Clear caches manually in GitHub Actions settings
- **Solution:** Update cache keys if dependencies change frequently

**Issue:** Build fails after dependency updates
- **Solution:** Clear pub cache: Delete `.dart_tool` and run `flutter pub get`
- **Solution:** Clear Gradle cache: Run `./gradlew clean` in `android/` directory
- **Solution:** Invalidate caches by changing cache key in workflow file

### Firebase Issues

**Issue:** `google-services.json` not found
- **Solution:** Ensure Firebase project has Android app registered
- **Solution:** Download `google-services.json` from Firebase Console
- **Solution:** Place it in `android/app/` directory and commit to repository

**Issue:** FlutterFire configure hangs
- **Solution:** Check that app IDs match Firebase project configuration
- **Solution:** Verify FIREBASE_TOKEN has correct permissions
- **Solution:** Manually configure using `flutterfire configure` locally first

### Appetize Issues

**Issue:** App doesn't appear on Appetize after upload
- **Solution:** Check workflow logs for upload response
- **Solution:** Verify public key is saved correctly in secrets
- **Solution:** Try accessing app directly via returned URL

**Issue:** App URL returns 404
- **Solution:** Check if APPETIZE_PUBLIC_KEY matches the actual public key
- **Solution:** Verify Appetize account is active
- **Solution:** Try creating a new app by removing APPETIZE_PUBLIC_KEY secret

## 📚 Additional Resources

- [Flutter CI/CD Documentation](https://docs.flutter.dev/deployment/cd)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)
- [Appetize.io API Documentation](https://docs.appetize.io/api/overview)
- [FlutterFire Documentation](https://firebase.flutter.dev/)

## 🎯 Best Practices

1. **Version Management**
   - Always update version in `pubspec.yaml` before creating PR
   - Follow semantic versioning (MAJOR.MINOR.PATCH+BUILD)
   - Document changes in commit messages

2. **Secret Security**
   - Never commit secrets to repository
   - Rotate tokens periodically
   - Use repository secrets, not environment variables in code

3. **Testing**
   - Test locally before pushing
   - Use Appetize for stakeholder reviews
   - Download APK artifact for device testing

4. **Performance**
   - Monitor cache hit rates
   - Optimize dependency tree
   - Keep workflow logs clean and readable

5. **Maintenance**
   - Update Flutter and dependencies regularly
   - Review and update workflow on major releases
   - Monitor build times and optimize as needed

---

<div align="center">

**Built with ❤️ for Hasper eBook Admin**

</div>
