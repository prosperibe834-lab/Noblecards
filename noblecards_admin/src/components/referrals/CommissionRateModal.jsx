import React, { useState } from 'react';

const CommissionRateModal = ({ currentRate, onClose, onSave }) => {
  const [step, setStep] = useState(1);
  const [newRate, setNewRate] = useState(currentRate);
  const [reason, setReason] = useState('');
  const [error, setError] = useState('');

  const handleNextStep = () => {
    if (!newRate || isNaN(newRate) || parseFloat(newRate) <= 0) {
      setError('Please enter a valid percentage rate greater than 0.');
      return;
    }
    if (!reason.trim()) {
      setError('Please provide a reason for recording in the financial audit log.');
      return;
    }
    setError('');
    setStep(2);
  };

  const handleConfirm = () => {
    onSave(parseFloat(newRate), reason);
  };

  return (
    <div className="ref-modal-overlay" onClick={onClose}>
      <div className="ref-modal-box" onClick={(e) => e.stopPropagation()}>
        {step === 1 ? (
          <div>
            <h3 style={{ fontSize: '18px', fontWeight: '700', marginBottom: '8px' }}>
              Edit Referral Commission Rate (Step 1 of 2)
            </h3>
            <p style={{ fontSize: '13px', color: 'var(--text-secondary)', marginBottom: '16px' }}>
              Updating this rate will change the automated reward calculation for future qualifying referrals.
            </p>

            {error && (
              <div style={{ background: 'rgba(239, 68, 68, 0.1)', color: '#ef4444', padding: '10px', borderRadius: '6px', fontSize: '12px', marginBottom: '12px' }}>
                {error}
              </div>
            )}

            <div style={{ marginBottom: '14px' }}>
              <label style={{ display: 'block', fontSize: '12px', color: 'var(--text-secondary)', marginBottom: '4px' }}>
                Current Rate (%)
              </label>
              <input type="text" className="ref-select-input" style={{ width: '100%' }} value={`${currentRate}%`} disabled />
            </div>

            <div style={{ marginBottom: '14px' }}>
              <label style={{ display: 'block', fontSize: '12px', color: 'var(--text-secondary)', marginBottom: '4px' }}>
                New Commission Rate (%)
              </label>
              <input 
                type="number" 
                step="0.1" 
                className="ref-select-input" 
                style={{ width: '100%' }} 
                value={newRate} 
                onChange={(e) => setNewRate(e.target.value)} 
                placeholder="e.g. 1.0"
              />
            </div>

            <div style={{ marginBottom: '20px' }}>
              <label style={{ display: 'block', fontSize: '12px', color: 'var(--text-secondary)', marginBottom: '4px' }}>
                Reason for Change (Audit Requirement)
              </label>
              <textarea 
                className="ref-select-input" 
                style={{ width: '100%', height: '70px', resize: 'none' }} 
                value={reason} 
                onChange={(e) => setReason(e.target.value)}
                placeholder="e.g. Adjusting seasonal marketing promotion budget"
              />
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '8px' }}>
              <button className="ref-btn ref-btn-outline" onClick={onClose}>Cancel</button>
              <button className="ref-btn ref-btn-primary" onClick={handleNextStep}>Continue to Confirmation</button>
            </div>
          </div>
        ) : (
          <div>
            <h3 style={{ fontSize: '18px', fontWeight: '700', color: '#f59e0b', marginBottom: '8px', display: 'flex', alignItems: 'center', gap: '6px' }}>
              <i className='bx bx-error-circle'></i> Confirm Rate Change (Step 2 of 2)
            </h3>

            <div style={{ background: 'var(--bg-primary)', padding: '14px', borderRadius: '8px', border: '1px solid var(--border-color)', marginBottom: '16px', fontSize: '13px' }}>
              <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
                <span>Previous Rate:</span>
                <strong>{currentRate}%</strong>
              </div>
              <div style={{ display: 'flex', justifyContent: 'space-between', color: 'var(--primary-color)' }}>
                <span>New Commission Rate:</span>
                <strong style={{ fontSize: '16px' }}>{newRate}%</strong>
              </div>
            </div>

            <div style={{ background: 'rgba(239, 68, 68, 0.08)', padding: '10px', borderRadius: '6px', fontSize: '12px', color: '#ef4444', marginBottom: '20px' }}>
              <strong>Warning:</strong> This is a financial configuration change. The new percentage rate will immediately be enforced by the backend for all pending and new qualification calculations.
            </div>

            <div style={{ display: 'flex', justifyContent: 'flex-end', gap: '8px' }}>
              <button className="ref-btn ref-btn-outline" onClick={() => setStep(1)}>Back</button>
              <button className="ref-btn ref-btn-primary" onClick={handleConfirm}>Confirm & Save Change</button>
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default CommissionRateModal;