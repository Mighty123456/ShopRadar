# USB Debugging Network Troubleshooting Guide

## 🚨 Socket Error When Running on Physical Device

### **Problem:**
When running your Flutter app on a physical device via USB debugging, you get socket errors when trying to connect to the backend server.

### **Root Cause:**
The main issue was a **space in the IP address URL**: `'http:// 10.67.3.145:3000'` (notice the space after `http://`)

## ✅ **Fixed Issues:**

### 1. **Corrected IP Address Format**
```dart
// ❌ Before (causing socket error)
static const String baseUrl = 'http:// 10.67.3.145:3000';

// ✅ After (fixed)
static const String baseUrl = 'http://10.67.3.145:3000';
```

### 2. **Added Network Error Handling**
- Added try-catch blocks around all HTTP requests
- Added timeout handling (10 seconds)
- Better error messages for debugging

### 3. **Created Network Configuration Helper**
- Easy switching between different environments
- Multiple IP address options for testing
- Centralized network configuration

## 🔧 **How to Fix Your Setup:**

### **Step 1: Check Your Computer's IP Address**
```bash
# On Windows
ipconfig

# On Mac/Linux
ifconfig
```

Look for your computer's IP address (usually starts with `192.168.x.x` or `10.x.x.x`)

### **Step 2: Update Network Configuration**
Edit `lib/services/network_config.dart`:

```dart
// Change this to your computer's actual IP address
static const String currentEnvironment = PHYSICAL_DEVICE;

// Update this IP to match your computer's IP
static const Map<String, String> baseUrls = {
  PHYSICAL_DEVICE: 'http://YOUR_COMPUTER_IP:3000', // Replace with your IP
};
```

### **Step 3: Ensure Backend Server is Running**
```bash
# Navigate to backend directory
cd backend_node

# Start the server
npm start
# or
node app.js
```

### **Step 4: Check Network Connectivity**
Make sure your phone and computer are on the **same WiFi network**.

## 🌐 **Alternative Network Setups:**

### **Option 1: Same WiFi Network**
```dart
// Use your computer's IP on the same WiFi
static const String baseUrl = 'http://192.168.1.100:3000';
```

### **Option 2: USB Port Forwarding**
```bash
# Forward port 3000 from device to computer
adb reverse tcp:3000 tcp:3000
```

Then use:
```dart
static const String baseUrl = 'http://localhost:3000';
```

### **Option 3: Hotspot Setup**
If using phone hotspot:
```dart
// Use the hotspot IP (usually 192.168.x.x)
static const String baseUrl = 'http://192.168.43.100:3000';
```

## 🔍 **Troubleshooting Steps:**

### **1. Test Network Connectivity**
```bash
# From your computer, test if the server is accessible
curl http://YOUR_IP:3000/api/health
```

### **2. Check Firewall Settings**
- Ensure port 3000 is not blocked
- Allow Node.js through firewall

### **3. Test Different IP Addresses**
Try these common IP patterns:
- `192.168.1.100`
- `192.168.0.100`
- `10.0.0.100`
- `172.20.10.100`

### **4. Use Network Debugging**
Add this to your app for debugging:
```dart
print('Network Info: ${NetworkConfig.getNetworkInfo()}');
```

## 📱 **Quick Fix for USB Debugging:**

### **Method 1: Port Forwarding (Recommended)**
```bash
# Run this command after connecting device
adb reverse tcp:3000 tcp:3000
```

Then change your baseUrl to:
```dart
static const String baseUrl = 'http://localhost:3000';
```

### **Method 2: Use Computer's IP**
1. Find your computer's IP: `ipconfig` (Windows) or `ifconfig` (Mac/Linux)
2. Update the IP in `network_config.dart`
3. Ensure both devices are on same WiFi

### **Method 3: Hotspot Setup**
1. Turn on phone hotspot
2. Connect computer to phone's hotspot
3. Use the hotspot IP address

## 🛠️ **Network Configuration Options:**

### **For Android Emulator:**
```dart
static const String baseUrl = 'http://10.0.2.2:3000';
```

### **For iOS Simulator:**
```dart
static const String baseUrl = 'http://localhost:3000';
```

### **For Physical Device (USB Debugging):**
```dart
// Option 1: Port forwarding
static const String baseUrl = 'http://localhost:3000';

// Option 2: Computer's IP
static const String baseUrl = 'http://192.168.1.100:3000';
```

## ✅ **Verification Steps:**

1. **Backend Server Running:**
   ```bash
   cd backend_node
   npm start
   ```

2. **Network Accessible:**
   ```bash
   curl http://YOUR_IP:3000
   ```

3. **Device Connected:**
   ```bash
   adb devices
   ```

4. **Port Forwarding (if using):**
   ```bash
   adb reverse tcp:3000 tcp:3000
   ```

## 🎯 **Quick Test:**

After making changes, test the connection:

```dart
// Add this to test network connectivity
Future<void> testConnection() async {
  try {
    final response = await http.get(Uri.parse('${ApiService.baseUrl}/api/health'));
    print('Connection successful: ${response.statusCode}');
  } catch (e) {
    print('Connection failed: $e');
  }
}
```

## 📞 **Common Issues & Solutions:**

| Issue | Solution |
|-------|----------|
| Socket timeout | Increase timeout duration or check network |
| Connection refused | Ensure backend server is running |
| Host unreachable | Check IP address and network |
| SSL errors | Use HTTP instead of HTTPS for local dev |

The main fix was removing the space from the IP address URL. Now your app should work properly with USB debugging! 🎉 