# Google Sign-In Setup Guide

## Prerequisites
1. A Google Cloud Project
2. Google Sign-In API enabled
3. OAuth 2.0 client credentials

## Step 1: Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the Google Sign-In API:
   - Go to "APIs & Services" > "Library"
   - Search for "Google Sign-In API"
   - Click "Enable"

## Step 2: Configure OAuth Consent Screen

1. Go to "APIs & Services" > "OAuth consent screen"
2. Choose "External" user type
3. Fill in the required information:
   - App name: "ShopRadar"
   - User support email: your email
   - Developer contact information: your email
4. Add scopes:
   - `email`
   - `profile`
   - `openid`
5. Add test users (your email addresses)

## Step 3: Create OAuth 2.0 Client ID

1. Go to "APIs & Services" > "Credentials"
2. Click "Create Credentials" > "OAuth client ID"
3. Choose "Android" as application type
4. Fill in the details:
   - Package name: `com.example.frontend_flutter`
   - SHA-1 certificate fingerprint: (see below for how to get this)

## Step 4: Get SHA-1 Certificate Fingerprint

### For Debug Build:
```bash
cd frontend_flutter/android
./gradlew signingReport
```

Look for the SHA-1 value in the debug variant.

### For Release Build:
You'll need to generate a keystore and get its SHA-1.

## Step 5: Download google-services.json

1. After creating the OAuth client ID, download the `google-services.json` file
2. Place it in `frontend_flutter/android/app/google-services.json`
3. Replace the template values in the file with your actual values

## Step 6: Update google-services.json

Replace the placeholder values in `google-services.json`:

```json
{
  "project_info": {
    "project_number": "123456789012", // Your actual project number
    "project_id": "your-actual-project-id",
    "storage_bucket": "your-actual-project-id.appspot.com"
  },
  "client": [
    {
      "client_info": {
        "mobilesdk_app_id": "1:123456789012:android:abcdef123456",
        "android_client_info": {
          "package_name": "com.example.frontend_flutter"
        }
      },
      "oauth_client": [
        {
          "client_id": "your-actual-client-id.apps.googleusercontent.com",
          "client_type": 3
        }
      ],
      "api_key": [
        {
          "current_key": "your-actual-api-key"
        }
      ],
      "services": {
        "appinvite_service": {
          "other_platform_oauth_client": [
            {
              "client_id": "your-actual-web-client-id.apps.googleusercontent.com",
              "client_type": 3
            }
          ]
        }
      }
    }
  ],
  "configuration_version": "1"
}
```

## Step 7: Test the Configuration

1. Run the app
2. Try the Google Sign-In button
3. Check the console for any error messages

## Common Issues and Solutions

### Issue: "Failed to get token"
**Solution:**
- Verify your `google-services.json` is correctly placed
- Check that the package name matches your app
- Ensure the SHA-1 fingerprint is correct
- Make sure the Google Sign-In API is enabled

### Issue: "Sign in cancelled"
**Solution:**
- Check that your test users are added to the OAuth consent screen
- Verify the app is in testing mode or published

### Issue: "Network error"
**Solution:**
- Check your internet connection
- Verify the Google Play Services are up to date on the device

## Testing

You can test the Google Sign-In configuration by calling:

```dart
final result = await GoogleAuthService.testGoogleSignIn();
print(result);
```

## Backend Integration

Make sure your backend endpoint `/api/auth/google-signin` is set up to:
1. Verify the ID token with Google
2. Create or update user in your database
3. Return a JWT token for your app

## Security Notes

- Never commit your actual `google-services.json` to version control
- Use environment variables for sensitive data
- Regularly rotate your API keys
- Monitor your Google Cloud Console for unusual activity 