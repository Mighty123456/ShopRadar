# Error Troubleshooting Guide

## 🔍 **Common Error Scenarios & Solutions**

### **1. Import/Compilation Errors**

#### **Issue: "The method 'post' isn't defined for the class 'ApiService'"**
**Solution:** Fixed by using direct HTTP calls instead of ApiService

#### **Issue: "The getter 'isSignedIn' was called on null"**
**Solution:** Ensure Google Sign-In is properly configured

### **2. Network/Connection Errors**

#### **Issue: Socket timeout or connection refused**
**Solutions:**
- Check if backend server is running: `cd backend_node && npm start`
- Verify network configuration in `network_config.dart`
- Test network connectivity using debug button

#### **Issue: "Failed to get ID token from Google"**
**Solutions:**
- Check Google Sign-In configuration
- Ensure proper SHA-1 fingerprint is added to Google Console
- Verify Google Services configuration

### **3. Runtime Errors**

#### **Issue: "UserModel.fromJson" errors**
**Solution:** Ensure backend returns proper JSON structure

#### **Issue: "SharedPreferences" errors**
**Solution:** Check if shared_preferences package is properly added

### **4. Debugging Steps**

#### **Step 1: Check Console Output**
```bash
flutter run --verbose
```

#### **Step 2: Test Network Connection**
Use the debug button to test network connectivity

#### **Step 3: Check Backend Logs**
Look for errors in the Node.js server console

#### **Step 4: Verify Dependencies**
```bash
flutter pub get
flutter clean
flutter pub get
```

### **5. Common Fixes Applied**

#### **✅ Fixed Import Conflicts**
- Removed conflicting ApiService import
- Used direct HTTP calls for Google auth
- Added proper error handling

#### **✅ Fixed Network Configuration**
- Updated IP addresses
- Added timeout handling
- Improved error messages

#### **✅ Fixed Code Quality Issues**
- Replaced print with debugPrint
- Removed unused variables
- Fixed deprecated method calls

### **6. How to Report Errors**

When reporting an error, please include:

1. **Error Message** - Copy the exact error text
2. **Error Location** - Which file/line caused the error
3. **Steps to Reproduce** - What you were doing when the error occurred
4. **Console Output** - Any relevant console messages
5. **Device/Platform** - Android/iOS, emulator/physical device

### **7. Quick Error Check**

Run these commands to identify issues:

```bash
# Check for compilation errors
flutter analyze

# Check for runtime errors
flutter run

# Test network connectivity
# Use the debug button in the app
```

### **8. Emergency Fixes**

If you're still getting errors:

1. **Restart the backend server:**
   ```bash
   cd backend_node
   npm start
   ```

2. **Clear Flutter cache:**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Check network configuration:**
   - Verify IP address in `network_config.dart`
   - Ensure both devices are on same network

4. **Test with different network setup:**
   - Try port forwarding: `adb reverse tcp:3000 tcp:3000`
   - Use localhost: `http://localhost:3000`

### **9. Error Categories**

| Error Type | Common Cause | Solution |
|------------|--------------|----------|
| Compilation | Missing imports | Add required imports |
| Runtime | Network issues | Check server and network |
| Google Auth | Configuration | Verify Google Console setup |
| Database | Connection | Check MongoDB connection |

### **10. Still Having Issues?**

If you're still experiencing errors:

1. **Share the exact error message**
2. **Include the error stack trace**
3. **Mention what you were doing when it occurred**
4. **Specify your device/platform**

This will help provide a more targeted solution! 🎯 