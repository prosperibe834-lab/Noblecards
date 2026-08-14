import React, { useState } from "react";

export const PasswordInput = ({ label, name, value, onChange, placeholder, required = true }) => {
  const [showPassword, setShowPassword] = useState(false);

  return (
    <div className="auth-field-group">
      {label && <label htmlFor={name}>{label}</label>}
      <div className="auth-input-wrapper">
        <i className="bx bx-lock-alt auth-input-icon"></i>
        <input
          id={name}
          name={name}
          type={showPassword ? "text" : "password"}
          className="auth-input"
          placeholder={placeholder || "••••••••"}
          value={value}
          onChange={onChange}
          required={required}
        />
        <button
          type="button"
          className="auth-eye-btn"
          onClick={() => setShowPassword(!showPassword)}
          tabIndex="-1"
          aria-label={showPassword ? "Hide password" : "Show password"}
        >
          <i className={`bx ${showPassword ? "bx-show" : "bx-hide"}`}></i>
        </button>
      </div>
    </div>
  );
};