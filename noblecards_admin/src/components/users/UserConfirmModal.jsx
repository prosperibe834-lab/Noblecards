import React, { useState } from 'react';

const UserConfirmModal = ({ actionType, user, onClose, onConfirm }) => {
  const [typedConfirm, setTypedConfirm] = useState('');
  const [step, setStep] = useState(1);

  if (!actionType || !user) return null;

  const isDelete = actionType === 'delete';
  const isSuspend = actionType === 'suspend';
  const isBan = actionType === 'ban';

  const handleNextOrConfirm = () => {
    if (isDelete && step === 1) {
      setStep(2);
      return;
    }
    onConfirm();
  };

  return (
    <div className="modal-overlay" onClick={onClose}>
      <div
        className="modal-content-card"
        style={{ maxWidth: '440px' }}
        onClick={(e) => e.stopPropagation()}
      >
        <div className="modal-header-row">
          <div style={{ display: 'flex', alignItems: 'center', gap: '10px' }}>
            <i
              className={`bx ${isDelete ? 'bx-trash' : isBan ? 'bx-ban' : 'bx-pause-circle'}`}
              style={{
                fontSize: '1.4rem',
                color: isDelete || isBan ? 'var(--error)' : 'var(--warning)',
              }}
            ></i>
            <h3 className="modal-title-text" style={{ textTransform: 'capitalize' }}>
              {actionType} User?
            </h3>
          </div>
          <button className="modal-close-btn" onClick={onClose}>
            <i className="bx bx-x"></i>
          </button>
        </div>

        <div className="modal-body-padding">
          {step === 1 ? (
            <div>
              <p style={{ fontSize: '0.9rem', color: 'var(--primary-text)' }}>
                Are you sure you want to <strong>{actionType}</strong> {user.fullName}?
              </p>
              <p style={{ fontSize: '0.8rem', color: 'var(--secondary-text)', marginTop: '8px' }}>
                {isSuspend && 'The user will temporarily lose access to their account.'}
                {isBan && 'The user will permanently lose access to the platform.'}
                {isDelete && 'This action will permanently delete the user and all their data.'}
              </p>
              <div
                style={{
                  marginTop: '16px',
                  padding: '10px',
                  borderRadius: '8px',
                  backgroundColor: 'var(--background)',
                  fontSize: '0.8rem',
                }}
              >
                User: <strong>{user.fullName} ({user.userId})</strong>
              </div>
            </div>
          ) : (
            <div>
              <h4 style={{ fontSize: '0.95rem', fontWeight: 700, color: 'var(--error)' }}>
                Final Confirmation
              </h4>
              <p style={{ fontSize: '0.825rem', color: 'var(--secondary-text)', marginTop: '6px' }}>
                This action is irreversible. Please type <strong>DELETE</strong> to confirm.
              </p>
              <input
                type="text"
                className="form-input-control"
                style={{ marginTop: '14px' }}
                placeholder="Type DELETE here..."
                value={typedConfirm}
                onChange={(e) => setTypedConfirm(e.target.value)}
              />
            </div>
          )}
        </div>

        <div className="modal-footer-row">
          <button className="btn-secondary-outline" onClick={onClose}>
            Cancel
          </button>
          <button
            className="btn-primary-green"
            style={{
              backgroundColor: isDelete || isBan ? 'var(--error)' : 'var(--warning)',
              borderColor: isDelete || isBan ? 'var(--error)' : 'var(--warning)',
            }}
            disabled={step === 2 && typedConfirm !== 'DELETE'}
            onClick={handleNextOrConfirm}
          >
            {step === 1 && isDelete ? 'Proceed' : `${actionType.toUpperCase()} User`}
          </button>
        </div>
      </div>
    </div>
  );
};

export default UserConfirmModal;