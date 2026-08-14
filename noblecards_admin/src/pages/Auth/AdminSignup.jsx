import React, { useState } from "react";
import { useNavigate, Link } from "react-router-dom";
import { AuthLayout } from "../../components/auth/AuthLayout";
import { PasswordInput } from "../../components/auth/PasswordInput";
import { PinInput } from "../../components/auth/PinInput";
import { authService } from "../../services/authService";
import { useAuth } from "../../context/AuthContext";
import "../../assets/css/auth.css";

export const AdminSignup = () => {
  const navigate = useNavigate();
  const { setAuthFlowState } = useAuth();

  const [formData, setFormData] = useState({
    firstName: "",
    lastName: "",
    email: "",
    phone: "",
    password: "",
    confirmPassword: "",
  });

  const [adminPin, setAdminPin] = useState(Array(6).fill(""));
  const [confirmAdminPin, setConfirmAdminPin] = useState(Array(6).fill(""));
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    const pinStr = adminPin.join("");
    const confirmPinStr = confirmAdminPin.join("");

    if (pinStr.length !== 6) {
      setError("Admin PIN must be exactly 6 digits.");
      return;
    }
    if (pinStr !== confirmPinStr) {
      setError("Admin PINs do not match.");
      return;
    }

    setLoading(true);
    try {
      const payload = {
        ...formData,
        adminPin: pinStr,
        confirmAdminPin: confirmPinStr,
      };

      const response = await authService.registerAdmin(payload);
      if (response.success) {
        setAuthFlowState({
          type: "signup",
          email: formData.email,
          tempId: response.adminTempId,
        });
        navigate("/verify-otp");
      }
    } catch (err) {
      setError(err.message || "Registration failed. Try again.");
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout 
      title="Register Administrator" 
      subtitle="Create a new official admin account for NobleCards."
    >
      {error && (
        <div className="auth-alert auth-alert-danger">
          <i className="bx bx-error-circle"></i> 
          <span>{error}</span>
        </div>
      )}

      <form className="auth-form" onSubmit={handleSubmit}>
        {/* Name Fields Row */}
        <div className="auth-form-row">
          <div className="auth-field-group">
            <label htmlFor="firstName">First Name</label>
            <div className="auth-input-wrapper">
              <i className="bx bx-user auth-input-icon"></i>
              <input
                id="firstName"
                type="text"
                name="firstName"
                className="auth-input"
                placeholder="John"
                required
                value={formData.firstName}
                onChange={handleChange}
              />
            </div>
          </div>

          <div className="auth-field-group">
            <label htmlFor="lastName">Last Name</label>
            <div className="auth-input-wrapper">
              <i className="bx bx-user auth-input-icon"></i>
              <input
                id="lastName"
                type="text"
                name="lastName"
                className="auth-input"
                placeholder="Doe"
                required
                value={formData.lastName}
                onChange={handleChange}
              />
            </div>
          </div>
        </div>

        {/* Contact Info Row */}
        <div className="auth-form-row">
          <div className="auth-field-group">
            <label htmlFor="email">Email Address</label>
            <div className="auth-input-wrapper">
              <i className="bx bx-envelope auth-input-icon"></i>
              <input
                id="email"
                type="email"
                name="email"
                className="auth-input"
                placeholder="admin@noblecards.com"
                required
                value={formData.email}
                onChange={handleChange}
              />
            </div>
          </div>

          <div className="auth-field-group">
            <label htmlFor="phone">Phone Number</label>
            <div className="auth-input-wrapper">
              <i className="bx bx-phone auth-input-icon"></i>
              <input
                id="phone"
                type="tel"
                name="phone"
                className="auth-input"
                placeholder="+1 (555) 000-0000"
                required
                value={formData.phone}
                onChange={handleChange}
              />
            </div>
          </div>
        </div>

        {/* Password Row */}
        <div className="auth-form-row">
          <PasswordInput
            label="Password"
            name="password"
            value={formData.password}
            onChange={handleChange}
          />
          <PasswordInput
            label="Confirm Password"
            name="confirmPassword"
            value={formData.confirmPassword}
            onChange={handleChange}
          />
        </div>

        <div className="auth-section-divider"></div>

      {/* SECTION 2: Permanent Admin PIN */}
             <PinInput pin={adminPin} setPin={setAdminPin} label="2. Permanent 6-Digit Admin PIN" />
     

        {/* Submit Button */}
        <button type="submit" className="auth-submit-btn" disabled={loading}>
          {loading ? (
            <>
              <i className="bx bx-loader-alt bx-spin"></i> Processing...
            </>
          ) : (
            <>
              Create Account <i className="bx bx-right-arrow-alt"></i>
            </>
          )}
        </button>
      </form>

      <div className="auth-footer-text">
        Already registered?{" "}
        <Link to="/login" className="auth-link">
          Sign In
        </Link>
      </div>
    </AuthLayout>
  );
};

export default AdminSignup;