import React, { useState, useEffect } from "react";
import { useNavigate, Link } from "react-router-dom";
import { AuthLayout } from "../../components/auth/AuthLayout";
import { OTPInput } from "../../components/auth/OTPInput";
import { PinInput } from "../../components/auth/PinInput";
import { authService } from "../../services/authService";
import { useAuth } from "../../context/AuthContext";

export const OTPVerification = () => {
  const navigate = useNavigate();
  const { pendingAuthFlow, loginSuccess } = useAuth();

  const [otp, setOtp] = useState(Array(6).fill(""));
  const [adminPin, setAdminPin] = useState(Array(6).fill(""));

  const [timer, setTimer] = useState(30);
  const [canResend, setCanResend] = useState(false);
  const [loading, setLoading] = useState(false);
  const [resending, setResending] = useState(false);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  useEffect(() => {
    let interval = null;
    if (timer > 0) {
      interval = setInterval(() => setTimer((prev) => prev - 1), 1000);
    } else {
      setCanResend(true);
      if (interval) clearInterval(interval);
    }
    return () => {
      if (interval) clearInterval(interval);
    };
  }, [timer]);

  const handleResend = async () => {
    if (!canResend) return;
    setResending(true);
    setError("");
    setMessage("");

    try {
      const res = await authService.resendOTP(pendingAuthFlow?.identifier || pendingAuthFlow?.email);
      setMessage(res.message);
      setTimer(30);
      setCanResend(false);
    } catch (err) {
      setError("Unable to resend code. Try again.");
    } finally {
      setResending(false);
    }
  };

  const handleVerify = async (e) => {
    e.preventDefault();
    setError("");
    setMessage("");

    const otpStr = otp.join("");
    const pinStr = adminPin.join("");

    if (otpStr.length !== 6) {
      setError("Please enter the complete 6-digit verification code.");
      return;
    }
    if (pinStr.length !== 6) {
      setError("Please enter your 6-digit Admin PIN.");
      return;
    }

    setLoading(true);
    try {
      const flowType = pendingAuthFlow?.type || "login";
      const response = await authService.verifyOtpAndPin({
        otp: otpStr,
        adminPin: pinStr,
        flowType,
      });

      if (response.success) {
        if (flowType === "reset-password") {
          navigate("/reset-password");
        } else if (flowType === "signup") {
          navigate("/login");
        } else {
          loginSuccess(response.user, response.token);
          navigate("/");
        }
      }
    } catch (err) {
      setError(err.message || "Verification failed.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout
      title="Verify Your Identity"
      subtitle="Enter the 6-digit verification code sent to your email AND your 6-digit Admin PIN."
    >
      {error && (
        <div className="auth-alert auth-alert-danger">
          <i className="bx bx-error-circle"></i> {error}
        </div>
      )}

      {message && (
        <div className="auth-alert auth-alert-success">
          <i className="bx bx-check-circle"></i> {message}
        </div>
      )}

      <form className="auth-form" onSubmit={handleVerify}>
        {/* SECTION 1: Verification Code */}
        <OTPInput otp={otp} setOtp={setOtp} label="1. Verification Code (Sent via Email)" />

        <div className="auth-timer-block">
          <span>Didn't get code?</span>
          <button type="button" className="auth-resend-btn" onClick={handleResend} disabled={!canResend || resending}>
            {resending ? (
              <>
                <i className="bx bx-loader-alt bx-spin"></i> Resending...
              </>
            ) : canResend ? (
              "Resend Code"
            ) : (
              `Resend in ${timer}s`
            )}
          </button>
        </div>

        <div className="auth-section-divider"></div>

        {/* SECTION 2: Permanent Admin PIN */}
        <PinInput pin={adminPin} setPin={setAdminPin} label="2. Permanent 6-Digit Admin PIN" />

        <button type="submit" className="auth-submit-btn" disabled={loading}>
          {loading ? (
            <>
              <i className="bx bx-loader-alt bx-spin"></i> Verifying Credentials...
            </>
          ) : (
            "Verify & Continue"
          )}
        </button>
      </form>

      <div className="auth-footer-text">
        <Link to="/login" className="auth-link">
          <i className="bx bx-arrow-back"></i> Return to Login
        </Link>
      </div>
    </AuthLayout>
  );
};

export default OTPVerification;