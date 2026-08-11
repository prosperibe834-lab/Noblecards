import React from 'react';

const UserDetailsModal = ({ user, onClose }) => {
  if (!user) return null;

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div className="modal-content-card" onClick={(e) => e.stopPropagation()}>
        <div className="modal-header-row">
          <h3 className="modal-title-text">User Profile Overview</h3>
          <button className="modal-close-btn" onClick={onClose}>
            <i className="bx bx-x"></i>
          </button>
        </div>

        <div className="modal-body-padding">
          {/* Main User Card Header */}
          <div style={{ display: 'flex', alignItems: 'center', gap: '16px', marginBottom: '24px' }}>
            <img src={user.avatar} alt={user.fullName} className="user-avatar-img" style={{ width: '64px', height: '64px' }} />
            <div>
              <h2 style={{ fontSize: '1.25rem', fontWeight: 800 }}>{user.fullName}</h2>
              <p style={{ color: 'var(--secondary-text)', fontSize: '0.85rem' }}>{user.username}</p>
              <span className="user-id-code" style={{ marginTop: '6px', inlineFlex: 'block' }}>{user.userId}</span>
            </div>
          </div>

          {/* Key Metrics Row */}
          <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '12px', marginBottom: '24px' }}>
            <div style={{ backgroundColor: 'var(--background)', padding: '12px 16px', borderRadius: '12px', border: '1px solid var(--border)' }}>
              <span style={{ fontSize: '0.75rem', color: 'var(--secondary-text)' }}>Account Balance</span>
              <p style={{ fontSize: '1.2rem', fontWeight: 800, color: 'var(--primary-green)' }}>${user.balance.toFixed(2)}</p>
            </div>
            <div style={{ backgroundColor: 'var(--background)', padding: '12px 16px', borderRadius: '12px', border: '1px solid var(--border)' }}>
              <span style={{ fontSize: '0.75rem', color: 'var(--secondary-text)' }}>Gift Cards Purchased</span>
              <p style={{ fontSize: '1.2rem', fontWeight: 800 }}>{user.cards}</p>
            </div>
          </div>

          {/* Profile Details Grid */}
          <div className="form-grid-two-col" style={{ fontSize: '0.85rem' }}>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>Email Address</span>
              <p style={{ fontWeight: 600, marginTop: '2px' }}>{user.email}</p>
            </div>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>Phone Number</span>
              <p style={{ fontWeight: 600, marginTop: '2px' }}>{user.phone}</p>
            </div>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>Country</span>
              <p style={{ fontWeight: 600, marginTop: '2px' }}>{user.country}</p>
            </div>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>Gender</span>
              <p style={{ fontWeight: 600, marginTop: '2px' }}>{user.gender}</p>
            </div>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>Date of Birth</span>
              <p style={{ fontWeight: 600, marginTop: '2px' }}>{user.dateOfBirth}</p>
            </div>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>Address</span>
              <p style={{ fontWeight: 600, marginTop: '2px' }}>{user.address}</p>
            </div>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>KYC Status</span>
              <p style={{ marginTop: '2px' }}>
                <span className={`kyc-pill ${user.kycStatus.toLowerCase().replace(' ', '-')}`}>{user.kycStatus}</span>
              </p>
            </div>
            <div>
              <span style={{ color: 'var(--secondary-text)' }}>Account Status</span>
              <p style={{ marginTop: '2px' }}>
                <span className={`status-pill ${user.status.toLowerCase()}`}>{user.status}</span>
              </p>
            </div>
          </div>
        </div>

        <div className="modal-footer-row">
          <button className="btn-secondary-outline" onClick={onClose}>
            Close
          </button>
        </div>
      </div>
    </div>
  );
};

export default UserDetailsModal;