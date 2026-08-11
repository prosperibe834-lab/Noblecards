import React, { useEffect } from 'react';

const UserToast = ({ toast, onClose }) => {
  useEffect(() => {
    if (toast) {
      const timer = setTimeout(() => {
        onClose();
      }, 4000);
      return () => clearTimeout(timer);
    }
  }, [toast, onClose]);

  if (!toast) return null;

  return (
    <div
      className="users-toast-banner"
      style={{
        borderLeftColor: toast.type === 'error' ? 'var(--error)' : 'var(--primary-green)',
      }}
    >
      <i
        className={`bx ${toast.type === 'error' ? 'bx-error-circle' : 'bx-check-circle'}`}
        style={{
          fontSize: '1.25rem',
          color: toast.type === 'error' ? 'var(--error)' : 'var(--primary-green)',
        }}
      ></i>
      <span style={{ fontSize: '0.875rem', fontWeight: 600 }}>{toast.message}</span>
      <button
        onClick={onClose}
        style={{
          background: 'none',
          border: 'none',
          color: 'var(--secondary-text)',
          cursor: 'pointer',
          marginLeft: '8px',
        }}
      >
        <i className="bx bx-x"></i>
      </button>
    </div>
  );
};

export default UserToast;