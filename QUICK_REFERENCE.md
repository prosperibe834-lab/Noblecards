# NobleCards Supabase Auth - Quick Reference

## 🎯 What Was Fixed

| Issue | Status | Solution |
|-------|--------|----------|
| ❌ **CRITICAL: OtpType.signup is deprecated** | ✅ FIXED | Changed to `OtpType.email` in `authentication_service.dart` |
| ❌ **Hardcoded Supabase credentials** | ✅ FIXED | Moved to environment variables in `main.dart` |
| ❌ **Incomplete error handling** | ✅ FIXED | Added messages for all error scenarios |
| ❌ **No input validation** | ✅ FIXED | Added validation in all auth methods |

---

## ⚡ Exact Commands to Run

### 1️⃣ Get Dependencies
```bash
cd c:\Users\USER PC\noble_cards
flutter pub get
```

### 2️⃣ Clean Build
```bash
flutter clean
```

### 3️⃣ Run Application (Windows)
```bash
flutter run -d windows --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_publishable_key_here
```

### 4️⃣ Run Application (Android)
```bash
flutter run -d android --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_publishable_key_here
```

### 5️⃣ Run Application (iOS)
```bash
flutter run -d ios --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_publishable_key_here
```

---

## 📝 How to Get Your Supabase Credentials

1. Go to https://supabase.com/dashboard
2. Login with your account
3. Select your NobleCards project
4. Click "Settings" in left sidebar
5. Click "API" tab
6. Copy these values:
   - **Project URL** → Your `SUPABASE_URL`
   - **anon public** → Your `SUPABASE_ANON_KEY`

Example:
```
SUPABASE_URL=https://cboxcprrzzpyyzylgffb.supabase.co
SUPABASE_ANON_KEY=sb_publishable_bauRSw8hHi6KkOCOHx-36w_QYIupMYH
```

---

## ✅ Test the Complete Flow in 5 Steps

### Step 1: Start App
```bash
flutter run -d windows --dart-define=SUPABASE_URL=https://cboxcprrzzpyyzylgffb.supabase.co --dart-define=SUPABASE_ANON_KEY=sb_publishable_bauRSw8hHi6KkOCOHx-36w_QYIupMYH
```

### Step 2: Sign Up
- Tap "Sign Up" 
- Email: `test123@gmail.com`
- Password: `SecurePass123!@` (8+ chars, uppercase, lowercase, number, special)
- Fill rest of form
- Tap "Sign Up"

### Step 3: Verify Email
- Check email inbox for 6-digit code
- Enter code in app
- Tap "Verify"

### Step 4: Success
- ✅ You should see home screen
- ✅ Session is established

### Step 5: Test Login
- Logout from app
- Tap "Log In"
- Enter same email and password
- ✅ You should log in without OTP (already verified)

---

## 🐛 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| "SUPABASE_URL not set" | Add `--dart-define` parameters to flutter run command |
| OTP verification fails | Make sure code is exactly 6 digits, no spaces or dashes |
| No email received | Check spam folder, verify Supabase email config |
| "Email already registered" | The email already exists in your Supabase - use different email |
| Network error | Verify internet, check Supabase status at status.supabase.com |

---

## 📂 Files Modified

✅ **lib/screens/authentication/services/authentication_service.dart**
- Fixed: `OtpType.signup` → `OtpType.email`
- Added: Comprehensive error messages
- Added: Input validation
- Added: Profile persistence methods (saveUserProfile, getUserProfile)

✅ **lib/main.dart**
- Moved: Hardcoded credentials to environment variables
- Improved: Comments for setup instructions

---

## 🔐 Security Best Practice

**IMPORTANT:** Never commit real Supabase credentials to Git!

Add to `.gitignore`:
```
.env
.env.local
.env.*.local
```

For CI/CD (GitHub Actions, etc.), use GitHub Secrets or similar.

---

## 📞 Need Help?

See **SUPABASE_AUTH_SETUP.md** for:
- Detailed setup instructions
- All 10 test scenarios with expected results
- Troubleshooting guide
- Security notes

---

## Summary: Auth Flow is Now Complete ✅

1. **Signup** → OTP sent to email
2. **Verify OTP** → 6-digit code verification
3. **Session Established** → User logged in
4. **Error Handling** → All scenarios covered
5. **Security** → Credentials in environment variables

**Ready to test!** 🚀
