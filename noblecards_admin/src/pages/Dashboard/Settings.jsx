import React, { useState, useEffect } from "react";
import { GeneralSettings, AdminProfileSettings, SecuritySettings, IntegrationsSettings, LegalPrivacySettings, SystemPreferences } from "../../components/settings/SettingsSections";
import { AdminManagement } from "../../components/settings/AdminManagement";
import "../../styles/settings.css";

const Settings = () => {
  const [activeTab, setActiveTab] = useState("general");
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(false);
  const [toastMessage, setToastMessage] = useState({ show: false, type: "", text: "" });

  // Simulate network loading state
  const loadSettingsData = () => {
    setLoading(true);
    setError(false);
    setTimeout(() => {
      // Simulate 5% chance of network error for realistic testing
      if (Math.random() < 0.05) {
        setError(true);
      } else {
        setLoading(false);
      }
    }, 1200);
  };

  useEffect(() => {
    loadSettingsData();
  }, []);

  const showToast = (type, text) => {
    setToastMessage({ show: true, type, text });
    setTimeout(() => setToastMessage({ show: false, type: "", text: "" }), 3000);
  };

  const navItems = [
    { id: "general", label: "General", icon: "bx-cog" },
    { id: "profile", label: "Admin Profile", icon: "bx-user-circle" },
    { id: "security", label: "Security", icon: "bx-shield-quarter" },
    { id: "management", label: "Admin Management", icon: "bx-group" },
    { id: "integrations", label: "Integrations", icon: "bx-plug" },
    { id: "legal", label: "Legal & Privacy", icon: "bx-file-blank" },
    { id: "preferences", label: "System Preferences", icon: "bx-slider-alt" },
  ];

  const renderActiveSection = () => {
    switch (activeTab) {
      case "general": return <GeneralSettings showToast={showToast} />;
      case "profile": return <AdminProfileSettings showToast={showToast} />;
      case "security": return <SecuritySettings showToast={showToast} />;
      case "management": return <AdminManagement showToast={showToast} />;
      case "integrations": return <IntegrationsSettings showToast={showToast} />;
      case "legal": return <LegalPrivacySettings showToast={showToast} />;
      case "preferences": return <SystemPreferences showToast={showToast} />;
      default: return <GeneralSettings showToast={showToast} />;
    }
  };

  return (
    <div className="settings-page-wrapper">
      <div className="settings-page-header">
        <h1>Platform Settings</h1>
        <button className="settings-refresh-btn" onClick={loadSettingsData} disabled={loading}>
          <i className={`bx bx-refresh ${loading ? 'bx-spin' : ''}`}></i> Refresh
        </button>
      </div>

      {error ? (
        <div className="settings-error-state animate-fade-in">
          <i className="bx bx-error-circle"></i>
          <h3>Unable to load settings</h3>
          <p>There was a network error connecting to the server.</p>
          <button className="settings-btn-primary" onClick={loadSettingsData}>Try Again</button>
        </div>
      ) : loading ? (
        <div className="settings-skeleton-layout animate-fade-in">
          <div className="skeleton-nav shimmer"></div>
          <div className="skeleton-content shimmer"></div>
        </div>
      ) : (
        <div className="settings-layout">
          {/* Mobile & Desktop Navigation */}
          <div className="settings-sidebar">
            <nav className="settings-nav-list">
              {navItems.map(item => (
                <button 
                  key={item.id} 
                  className={`settings-nav-item ${activeTab === item.id ? 'active' : ''}`}
                  onClick={() => setActiveTab(item.id)}
                >
                  <i className={`bx ${item.icon}`}></i>
                  <span>{item.label}</span>
                </button>
              ))}
            </nav>
          </div>

          {/* Content Area */}
          <div className="settings-content-area">
            {renderActiveSection()}
          </div>
        </div>
      )}

      {/* Global Toast Notification */}
      {toastMessage.show && (
        <div className={`settings-toast ${toastMessage.type} animate-slide-up`}>
          <i className={`bx ${toastMessage.type === 'success' ? 'bx-check-circle' : 'bx-error-circle'}`}></i>
          {toastMessage.text}
        </div>
      )}
    </div>
  );
};

export default Settings;