import React, { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { AuthLayout } from "../../components/auth/AuthLayout";
import { authService } from "../../services/authService";
import { useAuth } from "../../context/AuthContext";

export const ForgotPassword = () => {
  const navigate = useNavigate();
  const { setAuthFlowState } = useAuth();

  const [identifier, setIdentifier] = useState("");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const res = await authService.requestPasswordReset(identifier);
      if (res.success) {
        setAuthFlowState({
          type: "reset-password",
          identifier,
        });
        navigate("/verify-otp");
      }
    } catch (err) {
      setError(err.message || "Unable to process request.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout title="Recover Password" subtitle="Enter your email address or phone number to receive a security code.">
      {error && (
        <div className="auth-alert auth-alert-danger">
          <i className="bx bx-error-circle"></i> {error}
        </div>
      )}

      <form className="auth-form" onSubmit={handleSubmit}>
        <div className="auth-field-group">
          <label htmlFor="identifier">Registered Email or Phone Number</label>
          <div className="auth-input-wrapper">
            <i className="bx bx-envelope auth-input-icon"></i>
            <input
              id="identifier"
              type="text"
              className="auth-input"
              placeholder="admin@noblecards.com or +234..."
              value={identifier}
              onChange={(e) => setIdentifier(e.target.value)}
              required
            />
          </div>
        </div>

        <button type="submit" className="auth-submit-btn" disabled={loading}>
          {loading ? (
            <>
              <i className="bx bx-loader-alt bx-spin"></i> Sending Code...
            </>
          ) : (
            "Send Verification Code"
          )}
        </button>
      </form>

      <div className="auth-footer-text">
        <Link to="/login" className="auth-link">
          <i className="bx bx-arrow-back"></i> Back to Sign In
        </Link>
      </div>
    </AuthLayout>
  );
};

export default ForgotPassword;