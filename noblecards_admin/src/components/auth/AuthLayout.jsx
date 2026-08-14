import React, { useState, useEffect } from "react";
// import "../../assets/css/auth.css";

import lightLogo from "../../assets/logo/MainLightLogo.png.png";
import darkLogo from "../../assets/logo/MainDarkLogo.png.png";

export const AuthLayout = ({ children, title, subtitle }) => {
  const [currentLogo, setCurrentLogo] = useState(lightLogo);

  useEffect(() => {
    const updateLogo = () => {
      const theme = document.documentElement.getAttribute("data-theme");
      if (theme === "dark") {
        setCurrentLogo(darkLogo);
      } else {
        setCurrentLogo(lightLogo);
      }
    };

    updateLogo();
    const observer = new MutationObserver(updateLogo);
    observer.observe(document.documentElement, { attributes: true, attributeFilter: ["data-theme"] });

    return () => observer.disconnect();
  }, []);

  return (
    <div className="auth-wrapper">
      <div className="auth-container">
        {/* Left Branding Side */}
        <div className="auth-branding-side">
          <div className="auth-brand-logo-container">
            <img src={currentLogo} alt="NobleCards Admin" className="auth-brand-logo" />
          </div>

          <div className="auth-hero-content">
            <span className="auth-badge">
              <i className="bx bx-shield-quarter"></i> Admin Security Terminal
            </span>
            <h1 className="auth-hero-title">Manage NobleCards with Full Authority.</h1>
            <p className="auth-hero-subtitle">
              Secure administrative infrastructure for managing gift cards, financial deposits, user verification, and platform parameters.
            </p>
          </div>

          <div className="auth-branding-footer">
            <i className="bx bx-check-shield"></i>
            <span>Encrypted Multi-Factor Authentication Enabled</span>
          </div>
        </div>

        {/* Right Form Side */}
        <div className="auth-form-side">
          <div className="auth-header">
            <h2 className="auth-title">{title}</h2>
            {subtitle && <p className="auth-subtitle">{subtitle}</p>}
          </div>
          {children}
        </div>
      </div>
    </div>
  );
};