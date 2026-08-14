import React, { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { AuthLayout } from "../../components/auth/AuthLayout";
import { PasswordInput } from "../../components/auth/PasswordInput";
import { authService } from "../../services/authService";

export const ResetPassword = () => {
  const navigate = useNavigate();

  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [success, setSuccess] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    if (newPassword !== confirmPassword) {
      setError("Passwords do not match.");
      return;
    }

    setLoading(true);
    try {
      const res = await authService.resetPassword(newPassword, confirmPassword);
      if (res.success) {
        setSuccess(true);
      }
    } catch (err) {
      setError(err.message || "Failed to reset password.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout title="Reset Password" subtitle="Choose a strong, unique new password for your admin account.">
      {error && (
        <div className="auth-alert auth-alert-danger">
          <i className="bx bx-error-circle"></i> {error}
        </div>
      )}

      {success ? (
        <div className="auth-form">
          <div className="auth-alert auth-alert-success">
            <i className="bx bx-check-circle"></i> Password successfully changed!
          </div>
          <button type="button" className="auth-submit-btn" onClick={() => navigate("/login")}>
            Return to Login
          </button>
        </div>
      ) : (
        <form className="auth-form" onSubmit={handleSubmit}>
          <PasswordInput
            label="New Password"
            name="newPassword"
            value={newPassword}
            onChange={(e) => setNewPassword(e.target.value)}
            placeholder="Minimum 8 characters"
          />

          <PasswordInput
            label="Confirm New Password"
            name="confirmPassword"
            value={confirmPassword}
            onChange={(e) => setConfirmPassword(e.target.value)}
            placeholder="Re-enter password"
          />

          <button type="submit" className="auth-submit-btn" disabled={loading}>
            {loading ? (
              <>
                <i className="bx bx-loader-alt bx-spin"></i> Resetting Password...
              </>
            ) : (
              "Update Password"
            )}
          </button>
        </form>
      )}

      <div className="auth-footer-text">
        <Link to="/login" className="auth-link">
          <i className="bx bx-arrow-back"></i> Back to Login
        </Link>
      </div>
    </AuthLayout>
  );
};

export default ResetPassword;