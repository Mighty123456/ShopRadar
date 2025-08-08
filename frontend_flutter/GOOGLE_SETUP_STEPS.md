# Google Sign-In Setup Steps

## Your App Details:
- **Package Name**: `com.example.frontend_flutter`
- **SHA-1 Fingerprint**: `CD:0E:94:A4:A7:FE:D0:F2:9D:FB:86:BA:8F:61:ED:C4:6E:0B:4D:6E`

## Step-by-Step Configuration:

### 1. Create Google Cloud Project
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click "Select a project" > "New Project"
3. Name it "ShopRadar" and click "Create"

### 2. Enable Google Sign-In API
1. In your project, go to "APIs & Services" > "Library"
2. Search for "Google Sign-In API"
3. Click on it and press "Enable"

### 3. Configure OAuth Consent Screen
1. Go to "APIs & Services" > "OAuth consent screen"
2. Choose "External" user type
3. Fill in the required information:
   - **App name**: ShopRadar
   - **User support email**: [your email]
   - **Developer contact information**: [your email]
4. Click "Save and Continue"
5. On "Scopes" page, click "Save and Continue"
6. On "Test users" page, add your email address
7. Click "Save and Continue"

### 4. Create OAuth 2.0 Client ID
1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Choose "Android" as application type
4. Fill in:
   - **Package name**: `com.example.frontend_flutter`
   - **SHA-1 certificate fingerprint**: `CD:0E:94:A4:A7:FE:D0:F2:9D:FB:86:BA:8F:61:ED:C4:6E:0B:4D:6E`
5. Click "Create"

### 5. Download google-services.json
1. After creating the OAuth client ID, you'll see a download button
2. Click "Download" to get the `google-services.json` file
3. Place it in `frontend_flutter/android/app/google-services.json`
4. Replace the template file completely

### 6. Update google-services.json
Replace the placeholder values in the downloaded file with your actual values:
- `YOUR_PROJECT_NUMBER` → Your actual project number
- `your-project-id` → Your actual project ID
- `YOUR_CLIENT_ID` → Your actual client ID
- `YOUR_API_KEY` → Your actual API key

### 7. Test the Configuration
1. Run `flutter pub get` in your project
2. Run the app
3. Try the "Test Google Sign-In Config" button
4. Check the console for any error messages

## Common Issues:

### Issue: "Failed to get ID token"
- Make sure your SHA-1 fingerprint is correct
- Verify the package name matches exactly
- Check that Google Sign-In API is enabled
- Ensure you're using the correct google-services.json

### Issue: "Sign in cancelled"
- Add your email as a test user in OAuth consent screen
- Make sure the app is in testing mode

### Issue: "Network error"
- Check your internet connection
- Verify Google Play Services are up to date

## Verification:
After setup, the "Test Google Sign-In Config" button should show:
- ✅ "Google Sign-In is properly configured"
- ❌ If there's an error, it will show the specific issue

## Next Steps:
1. Complete the Google Cloud Console setup
2. Download and replace google-services.json
3. Test the configuration
4. Try signing in with Google 