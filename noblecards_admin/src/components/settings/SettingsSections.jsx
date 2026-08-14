import React, { useState } from "react";
import { platformSettings, integrationsList } from "../../data/settingsData";

export const GeneralSettings = ({ showToast }) => {
  const [config, setConfig] = useState(platformSettings);

  const handleSave = () => {
    showToast("success", "General platform settings saved successfully.");
  };

  return (
    <div className="settings-section-card animate-fade-in">
      <h2>General Settings</h2>
      <p className="settings-subtitle">Configure global platform details and maintenance modes.</p>

      <div className="settings-form-grid mt-4">
        <div className="form-group">
          <label>Platform Name</label>
          <input type="text" className="settings-input" value={config.platformName} onChange={e => setConfig({...config, platformName: e.target.value})} />
        </div>
        <div className="form-group">
          <label>Support Email</label>
          <input type="email" className="settings-input" value={config.supportEmail} onChange={e => setConfig({...config, supportEmail: e.target.value})} />
        </div>
        <div className="form-group">
          <label>Default Currency</label>
          <select className="settings-input" value={config.defaultCurrency} onChange={e => setConfig({...config, defaultCurrency: e.target.value})}>
            <option value="NGN">Nigerian Naira (NGN)</option>
            <option value="USD">US Dollar (USD)</option>
            <option value="GBP">British Pound (GBP)</option>
          </select>
        </div>
      </div>

      <div className="settings-divider"></div>

      <h3>Platform Status</h3>
      <div className="toggle-row">
        <div>
          <strong>Maintenance Mode</strong>
          <p className="sub-text">Prevent users from logging in while updates are applied.</p>
        </div>
        <label className="switch">
          <input type="checkbox" checked={config.maintenanceMode} onChange={e => setConfig({...config, maintenanceMode: e.target.checked})} />
          <span className="slider round"></span>
        </label>
      </div>

      {config.maintenanceMode && (
        <div className="form-group mt-3">
          <label>Maintenance Message</label>
          <textarea className="settings-input" value={config.maintenanceMessage} onChange={e => setConfig({...config, maintenanceMessage: e.target.value})}></textarea>
        </div>
      )}

      <div className="settings-footer-actions">
        <button className="settings-btn-primary" onClick={handleSave}>Save Changes</button>
      </div>
    </div>
  );
};

export const AdminProfileSettings = ({ showToast }) => {
  const [pin, setPin] = useState("");
  
  const handlePinChange = (e) => {
    // Exactly 6 digits, numbers only.
    const val = e.target.value.replace(/\D/g, '');
    if (val.length <= 6) setPin(val);
  };

  const handleSavePin = () => {
    if (pin.length !== 6) {
      showToast("error", "Admin PIN must be exactly 6 digits.");
      return;
    }
    showToast("success", "Admin PIN updated successfully.");
    setPin("");
  };

  return (
    <div className="settings-section-card animate-fade-in">
      <h2>Admin Profile</h2>
      <p className="settings-subtitle">Manage your personal admin credentials and secure PIN.</p>
      
      <div className="profile-header mt-4">
        <img src="https://ui-avatars.com/api/?name=Noble+Master&background=10B981&color=fff" alt="Profile" className="profile-large-avatar" />
        <div className="profile-info">
          <h3>Noble Master</h3>
          <span className="role-badge">Super Admin</span>
          <p>ID: ADM-001</p>
        </div>
      </div>

      <div className="settings-divider"></div>

      <h3>Secure Admin PIN</h3>
      <p className="sub-text mb-3">Your 6-digit PIN is required for approving transactions and configuring platform settings.</p>
      
      <div className="form-group" style={{ maxWidth: "300px" }}>
        <label>New 6-Digit PIN</label>
        <div className="pin-input-container">
          <input 
            type="password" 
            inputMode="numeric" 
            pattern="[0-9]*"
            maxLength={6}
            className="settings-input pin-field" 
            value={pin}
            onChange={handlePinChange}
            placeholder="••••••"
          />
        </div>
        <small className="hint-text">{pin.length}/6 digits entered</small>
      </div>
      <button className="settings-btn-primary mt-3" onClick={handleSavePin}>Update Secure PIN</button>
    </div>
  );
};

export const SecuritySettings = ({ showToast }) => {
  const handleSave = () => showToast("success", "Security policies updated.");

  return (
    <div className="settings-section-card animate-fade-in">
      <h2>Security & Auth</h2>
      <p className="settings-subtitle">Configure global security policies for the admin panel.</p>

      <div className="toggle-row mt-4">
        <div>
          <strong>Require Two-Factor Authentication (2FA)</strong>
          <p className="sub-text">Force all administrators to use an authenticator app.</p>
        </div>
        <label className="switch">
          <input type="checkbox" defaultChecked />
          <span className="slider round"></span>
        </label>
      </div>

      <div className="toggle-row mt-3">
        <div>
          <strong>New Device Login Alerts</strong>
          <p className="sub-text">Send email alerts when an admin logs in from a new IP or device.</p>
        </div>
        <label className="switch">
          <input type="checkbox" defaultChecked />
          <span className="slider round"></span>
        </label>
      </div>

      <div className="settings-form-grid mt-4">
        <div className="form-group">
          <label>Session Timeout (Minutes)</label>
          <input type="number" className="settings-input" defaultValue={30} />
        </div>
        <div className="form-group">
          <label>Max Failed Login Attempts</label>
          <input type="number" className="settings-input" defaultValue={5} />
        </div>
      </div>

      <div className="settings-footer-actions">
        <button className="settings-btn-primary" onClick={handleSave}>Save Security Policies</button>
      </div>
    </div>
  );
};

export const IntegrationsSettings = ({ showToast }) => {
  const [testing, setTesting] = useState(null);

  const testConnection = (id) => {
    setTesting(id);
    setTimeout(() => {
      setTesting(null);
      showToast("success", "Connection tested successfully. API is responding.");
    }, 1500);
  };

  return (
    <div className="settings-section-card animate-fade-in">
      <h2>Platform Integrations</h2>
      <p className="settings-subtitle">Manage third-party API connections.</p>

      <div className="integrations-list mt-4">
        {integrationsList.map(int => (
          <div className="integration-card" key={int.id}>
            <div className="integration-info">
              <i className={`bx ${int.icon} integration-icon`}></i>
              <div>
                <strong>{int.name}</strong>
                <span className={`status-text ${int.status === 'Connected' ? 'success' : 'warning'}`}>
                  {int.status}
                </span>
              </div>
            </div>
            <button 
              className="settings-btn-outline btn-sm" 
              onClick={() => testConnection(int.id)}
              disabled={testing === int.id}
            >
              {testing === int.id ? <i className="bx bx-loader-alt bx-spin"></i> : "Test API"}
            </button>
          </div>
        ))}
      </div>
    </div>
  );
};

export const LegalPrivacySettings = ({ showToast }) => {
  return (
    <div className="settings-section-card animate-fade-in">
      <h2>Legal & Privacy</h2>
      <p className="settings-subtitle">Manage links to platform legal documents.</p>
      
      <div className="settings-form-grid mt-4">
        <div className="form-group">
          <label>Terms and Conditions URL</label>
          <input type="url" className="settings-input" defaultValue="https://noblecards.com/terms" />
        </div>
        <div className="form-group">
          <label>Privacy Policy URL</label>
          <input type="url" className="settings-input" defaultValue="https://noblecards.com/privacy" />
        </div>
      </div>
      <div className="settings-footer-actions">
        <button className="settings-btn-primary" onClick={() => showToast("success", "Legal links updated.")}>Save Links</button>
      </div>
    </div>
  );
};

export const SystemPreferences = ({ showToast }) => {
  return (
    <div className="settings-section-card animate-fade-in">
      <h2>System Preferences</h2>
      <p className="settings-subtitle">Customize your admin panel experience.</p>
      
      <div className="settings-form-grid mt-4">
        <div className="form-group">
          <label>Timezone</label>
          <select className="settings-input">
            <option>Africa/Lagos (GMT+1)</option>
            <option>UTC (GMT+0)</option>
          </select>
        </div>
        <div className="form-group">
          <label>Date Format</label>
          <select className="settings-input">
            <option>YYYY-MM-DD</option>
            <option>DD-MM-YYYY</option>
          </select>
        </div>
      </div>
      <div className="settings-footer-actions">
        <button className="settings-btn-primary" onClick={() => showToast("success", "Preferences saved.")}>Save Preferences</button>
      </div>
    </div>
  );
};