// Simulated API delay
const delay = (ms = 1000) => new Promise((resolve) => setTimeout(resolve, ms));

export const authService = {
  // 1. Admin Login Initial Stage
  async loginAdmin(identifier, password) {
    await delay(1200);
    if (!identifier || !password) {
      throw new Error("Please enter both email/phone and password.");
    }
    // Simulation: accept any credentials for demo
    return {
      success: true,
      message: "Credentials verified. Verification code dispatched.",
      adminTempId: "TEMP-ADM-8832",
    };
  },

  // 2. Admin Signup Initial Stage
  async registerAdmin(signupData) {
    await delay(1500);
    const { firstName, lastName, email, phone, password, confirmPassword, adminPin, confirmAdminPin } = signupData;

    if (!firstName || !lastName || !email || !phone || !password || !adminPin) {
      throw new Error("All fields are required.");
    }
    if (password !== confirmPassword) {
      throw new Error("Passwords do not match.");
    }
    if (adminPin.length !== 6 || adminPin !== confirmAdminPin) {
      throw new Error("Admin PINs must match and be exactly 6 digits.");
    }

    return {
      success: true,
      message: "Account registration initiated. Check email for OTP.",
      adminTempId: "TEMP-REG-9910",
    };
  },

  // 3. Final Verification (Requires BOTH OTP and Admin PIN)
  async verifyOtpAndPin({ otp, adminPin, flowType }) {
    await delay(1400);

    if (otp.length !== 6) {
      throw new Error("Verification code must be exactly 6 digits.");
    }
    if (adminPin.length !== 6) {
      throw new Error("Admin PIN must be exactly 6 digits.");
    }

    // Mock validation rules for testing error handling
    if (otp === "000000") {
      throw new Error("Invalid or expired verification code.");
    }
    if (adminPin === "000000") {
      throw new Error("Incorrect Admin PIN entered.");
    }

    return {
      success: true,
      message: "Identity confirmed successfully.",
      user: {
        id: "ADM-001",
        fullName: "Noble Master",
        email: "admin@noblecards.com",
        role: "Super Admin",
      },
      token: "mock-jwt-noblecards-token-2026",
    };
  },

  // 4. Resend OTP Code
  async resendOTP(identifier) {
    await delay(1000);
    return {
      success: true,
      message: "New 6-digit verification code sent to your email.",
    };
  },

  // 5. Initiate Forgot Password
  async requestPasswordReset(identifier) {
    await delay(1100);
    if (!identifier) {
      throw new Error("Please provide your email or phone number.");
    }
    return {
      success: true,
      message: "Reset code dispatched to your registered address.",
    };
  },

  // 6. Reset Password Final Stage
  async resetPassword(newPassword, confirmPassword) {
    await delay(1300);
    if (!newPassword || newPassword.length < 8) {
      throw new Error("Password must be at least 8 characters long.");
    }
    if (newPassword !== confirmPassword) {
      throw new Error("Passwords do not match.");
    }
    return {
      success: true,
      message: "Password reset complete. You can now login.",
    };
  },
};