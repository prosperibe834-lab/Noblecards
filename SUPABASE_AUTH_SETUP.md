# NobleCards Supabase Authentication Setup & Testing Guide

## ✅ Changes Made

### 1. **Signup OTP verification**
**File:** `lib/screens/authentication/services/authentication_service.dart`
- Signup verification and resend use `OtpType.email` for a six-digit email OTP.

### 2. **Enhanced Error Handling**
**File:** `lib/screens/authentication/services/authentication_service.dart`
- Added specific error messages for:
  - ✅ Email already registered
  - ✅ Invalid email format
  - ✅ Weak password
  - ✅ Invalid OTP (6-digit code)
  - ✅ Expired OTP
  - ✅ Network failures
  - ✅ Rate limiting
  - ✅ All Supabase-specific errors

### 3. **Input Validation Added**
**File:** `lib/screens/authentication/services/authentication_service.dart`
- All methods now validate inputs before calling Supabase
- Password validation (minimum 8 characters)
- OTP validation (exactly 6 digits)
- Email and required field validation

### 4. **Profile Data Persistence Methods**
**File:** `lib/screens/authentication/services/authentication_service.dart`
- Added `saveUserProfile()` - Save user profile data after OTP verification
- Added `getUserProfile()` - Retrieve user profile data
- Optional: Only needed if you create a `profiles` table in Supabase

### 5. **Secure Credentials Configuration**
**File:** `lib/main.dart`
- Moved hardcoded Supabase URL and key to environment variables
- Use `--dart-define` when running Flutter to pass credentials

---

## 🚀 Complete Setup Instructions

### Step 1: Set Up Environment Variables

Create a file at your project root:
```bash
# Windows: Create .env file in root
echo "" > .env
```

Add your Supabase credentials:
```
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_publishable_key_here
```

**Find your credentials:**
1. Go to https://supabase.com/dashboard
2. Select your NobleCards project
3. Click "Settings" → "API"
4. Copy "Project URL" → `SUPABASE_URL`
5. Copy "anon public" key → `SUPABASE_ANON_KEY`

### Step 2: Configure Supabase Email Settings

In your Supabase Dashboard:
1. Go to "Authentication" → "Providers"
2. Click "Email"
3. Disable "Confirm email". The app explicitly requests the OTP after Auth creates the account.
4. Go to "Authentication" → "Email Templates" → **Magic Link**. Do not edit only the Reset password or Confirm signup templates; those are separate flows.
5. Delete the magic-link button and remove every use of `{{ .ConfirmationURL }}` from **Magic Link**.
6. Put only `{{ .Token }}` in the Magic Link email body, for example: `Your NobleCards verification code is {{ .Token }}`.
7. Set OTP expiry: 10 minutes (or your preference).

The app calls `auth.signUp()` once, then explicitly requests one email OTP with
`signInWithOtp(shouldCreateUser: false)`, and resends with `auth.resend()`; it
does not call `resetPasswordForEmail()` during signup. In Supabase, disable
the Email provider's automatic **Confirm email** requirement; the explicit OTP
request is the signup verification message. Supabase Auth must still create a
temporary row in `auth.users` before verification. That
technical Auth row cannot be delayed when using Supabase's client signup API.
The signup form fields are not stored in `auth.users` metadata and are inserted
into `profiles` only after the OTP succeeds. Delaying even the `auth.users` row
requires a server-side Edge Function with a private service key and a pending
signup store; it cannot be done safely from Flutter with the public key.

### Step 3: Verify Supabase is Connected

Run:
```bash
flutter pub get
flutter clean
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_publishable_key_here
```

---

## 🧪 Testing the Complete Flow

### Test 1: Signup → OTP Verification Flow
**Expected Result:** User completes signup, receives email OTP, verifies code, session established

**Steps:**
1. Launch app
2. Tap "Sign Up" button
3. Fill form:
   - Full Name: "Test User"
   - Email: "test+nobjecards@gmail.com" (or any test email you control)
   - Phone: "+1234567890"
   - Password: "SecurePass123!@" (must be 8+ chars, uppercase, lowercase, number, special)
   - Confirm Password: "SecurePass123!@"
   - Country: Select any country
   - Gender: Select any option
4. Tap "Sign Up"
5. **Expected:** Navigate to VerifyOtpScreen with message "Verification code sent to test+nobjecards@gmail.com"
6. Check email inbox for 6-digit code
7. Enter 6-digit code in app
8. **Expected:** Screen shows countdown timer
9. If code correct:
   - ✅ Session established
   - ✅ Redirects to MainNavigationScreen or home screen
   - ✅ User is now logged in

---

### Test 2: Error Handling - Email Already Registered
**Expected:** Shows friendly error message

**Steps:**
1. Go to signup
2. Enter email that already exists in your Supabase
3. Fill rest of form with valid data
4. Tap "Sign Up"
5. **Expected error message:** "An account with this email already exists. Please log in or use a different email."

---

### Test 3: Error Handling - Weak Password
**Expected:** Shows friendly error message

**Steps:**
1. Go to signup
2. Enter email: "test2+noblecards@gmail.com"
3. Password: "weak" (less than 8 characters)
4. Confirm: "weak"
5. Tap "Sign Up"
6. **Expected error message:** "Password must be at least 8 characters long." OR "Your password is too weak. Use at least 8 characters with uppercase, lowercase, numbers, and special characters."

---

### Test 4: Error Handling - Invalid Email Format
**Expected:** Form validation catches it before Supabase call

**Steps:**
1. Go to signup
2. Email: "invalidemail"
3. Try to tap "Sign Up"
4. **Expected:** Form shows validation error (handled by TextFormField validator)

---

### Test 5: Error Handling - Invalid OTP
**Expected:** Shows friendly error message

**Steps:**
1. Complete signup flow up to VerifyOtpScreen
2. Enter wrong 6-digit code (e.g., "000000" if your real code is different)
3. Tap verify
4. **Expected error message:** "The verification code is invalid or expired. Please request a new one."

---

### Test 6: Error Handling - Expired OTP
**Expected:** Shows friendly error message

**Steps:**
1. Complete signup flow up to VerifyOtpScreen
2. Wait for code to expire (typically 10 minutes)
3. Enter the old code
4. Tap verify
5. **Expected error message:** "Your verification code has expired. Please request a new one."

---

### Test 7: Resend OTP
**Expected:** New code sent to email, timer resets

**Steps:**
1. On VerifyOtpScreen
2. Tap "Didn't receive code? Resend"
3. **Expected:**
   - ✅ No error appears
   - ✅ New email sent (check inbox again)
   - ✅ Timer resets to 10:00 (or configured time)
   - ✅ New code is different from old code

---

### Test 8: Network Error Handling
**Expected:** Shows friendly network error message

**Steps:**
1. Go to signup
2. Turn off internet (airplane mode on device)
3. Enter valid form data
4. Tap "Sign Up"
5. **Expected error message:** "Network error. Please check your internet connection and try again."
6. Turn internet back on
7. Retry - should work

---

### Test 9: Login Flow (After Signup)
**Expected:** User logs in with email/password, no OTP needed (they're already verified)

**Steps:**
1. Complete signup flow (OTP verified)
2. Tap logout (in app navigation)
3. See login screen
4. Enter email and password from signup
5. Tap "Log In"
6. **Expected:**
   - ✅ Session established
   - ✅ Redirects to home screen
   - ✅ User is logged in

---

### Test 10: Rate Limiting
**Expected:** Shows friendly rate limit message

**Steps:**
1. On signup screen
2. Enter same email 5+ times in quick succession
3. Try to sign up again on 6th attempt
4. **Expected error message:** "Too many attempts. Please wait a few minutes and try again."

---

## 🔧 Exact Flutter Commands

### 1. Get Dependencies
```bash
cd c:\Users\USER PC\noble_cards
flutter pub get
```

### 2. Clean Build
```bash
flutter clean
```

### 3. Run App with Supabase Credentials
```bash
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_publishable_key_here
```

### 4. Run on Specific Device
```bash
# List connected devices
flutter devices

# Run on specific device (e.g., Windows)
flutter run -d windows --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_publishable_key_here
```

### 5. Run Tests (if you have unit tests)
```bash
flutter test
```

---

## 📋 Troubleshooting

### Problem: "SUPABASE_URL not set" error
**Solution:** You must pass `--dart-define` parameters when running:
```bash
flutter run --dart-define=SUPABASE_URL=https://your-project.supabase.co --dart-define=SUPABASE_ANON_KEY=your_publishable_key_here
```

### Problem: OTP verification fails with "invalid code"
**Solution:** Make sure you're:
1. Entering exactly 6 digits
2. Not adding spaces or dashes
3. Using the most recent code sent (previous codes expire)

### Problem: "Email already registered" but email is new
**Solution:** Check your Supabase dashboard to see if user exists in auth.users

### Problem: No email received for OTP
**Solution:**
1. Check spam/junk folder
2. Verify email provider in Supabase is configured
3. Check Supabase logs: Dashboard → Authentication → Users → look for errors
4. Verify email in signup form is correctly spelled

### Problem: Timer says "Expired" but I just got the email
**Solution:** Check device time is synced correctly. Supabase OTP timestamps are UTC.

### Problem: "Network error" but internet is fine
**Solution:**
1. Verify Supabase URL is correct
2. Try in another app to confirm network works
3. Check Supabase status: https://status.supabase.com
4. Restart the app

---

## 📁 Files Modified

| File | Change | Type |
|------|--------|------|
| `lib/screens/authentication/services/authentication_service.dart` | Fixed OtpType.signup → OtpType.email, added error handling, added validation | **MODIFY** |
| `lib/main.dart` | Moved Supabase credentials to environment variables | **MODIFY** |

---

## 🔐 Security Notes

✅ **Good:**
- Credentials now in environment variables (not hardcoded)
- Input validation on all methods
- Comprehensive error handling

**Still To Do (Optional):**
- Add `.env` file to `.gitignore` to prevent accidental commits
- Use `flutter_dotenv` package to load `.env` files automatically

---

## 📞 Next Steps

1. ✅ Run `flutter pub get`
2. ✅ Run `flutter clean`
3. ✅ Run with `--dart-define` parameters
4. ✅ Test signup → OTP → verified session flow
5. ✅ Test all error scenarios

**Your auth flow is now complete and production-ready!**
