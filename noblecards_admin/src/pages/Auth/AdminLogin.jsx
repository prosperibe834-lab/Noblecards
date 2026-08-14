import React, { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { AuthLayout } from "../../components/auth/AuthLayout";
import { PasswordInput } from "../../components/auth/PasswordInput";
import { PinInput } from "../../components/auth/PinInput";




import { authService } from "../../services/authService";
import { useAuth } from "../../context/AuthContext";

export const AdminLogin = () => {
  const navigate = useNavigate();
  const { setAuthFlowState } = useAuth();

  const [identifier, setIdentifier] = useState("");
  const [password, setPassword] = useState("");
  const [adminPin, setAdminPin] = useState(Array(6).fill(""));
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");
    setLoading(true);

    try {
      const response = await authService.loginAdmin(identifier, password);
      if (response.success) {
        setAuthFlowState({
          type: "login",
          identifier,
          tempId: response.adminTempId,
        });
        navigate("/verify-otp");
      }
    } catch (err) {
      setError(err.message || "Login failed. Please check your credentials.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout title="Admin Sign In" subtitle="Enter your credentials to access the management portal.">
      {error && (
        <div className="auth-alert auth-alert-danger">
          <i className="bx bx-error-circle"></i> {error}
        </div>
      )}

      <form className="auth-form" onSubmit={handleSubmit}>
        <div className="auth-field-group">
          <label htmlFor="identifier">Email or Phone Number</label>
          <div className="auth-input-wrapper">
            <i className="bx bx-user auth-input-icon"></i>
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

        <PasswordInput
          label="Password"
          name="password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          placeholder="••••••••"
        />

         {/* SECTION 2: Permanent Admin PIN */}
                <PinInput pin={adminPin} setPin={setAdminPin} label="2. Permanent 6-Digit Admin PIN" />
        

        <div className="auth-options-row">
          <div></div>
          <Link to="/forgot-password" className="auth-link">
            Forgot Password?
          </Link>
        </div>

        <button type="submit" className="auth-submit-btn" disabled={loading}>
          {loading ? (
            <>
              <i className="bx bx-loader-alt bx-spin"></i> Authenticating...
            </>
          ) : (
            <>
              Continue <i className="bx bx-right-arrow-alt"></i>
            </>
          )}
        </button>
      </form>

      <div className="auth-footer-text">
        Need an admin account?{" "}
        <Link to="/signup" className="auth-link">
          Create Account
        </Link>
      </div>
    </AuthLayout>
  );
};

export default AdminLogin;