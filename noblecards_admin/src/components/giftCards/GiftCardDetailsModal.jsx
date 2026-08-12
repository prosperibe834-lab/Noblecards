import React from 'react';

const GiftCardDetailsModal = ({ isOpen, onClose, card }) => {
  if (!isOpen || !card) return null;

  return (
    <div className="gc-modal-overlay">
      <div className="gc-modal-content gc-modal-large">
        <div className="gc-modal-header">
          <div className="gc-card-identity">
            <div className="gc-card-icon"><i className="bx bx-gift"></i></div>
            <div>
              <h2 className="gc-modal-title" style={{ margin: 0 }}>{card.name}</h2>
              <span style={{ color: 'var(--secondary-text)', fontSize: '13px' }}>ID: {card.cardId}</span>
            </div>
          </div>
          <button className="gc-close-btn" onClick={onClose}>&times;</button>
        </div>

        <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(200px, 1fr))', gap: '16px', marginBottom: '24px' }}>
          <div style={{ background: 'var(--background)', padding: '12px', borderRadius: '8px', border: '1px solid var(--border)' }}>
            <span style={{ color: 'var(--secondary-text)', fontSize: '12px' }}>Buy Rate</span>
            <div style={{ fontSize: '18px', fontWeight: 'bold', color: 'var(--primary-green)' }}>{card.buyRate}%</div>
          </div>
          <div style={{ background: 'var(--background)', padding: '12px', borderRadius: '8px', border: '1px solid var(--border)' }}>
            <span style={{ color: 'var(--secondary-text)', fontSize: '12px' }}>Sale Rate</span>
            <div style={{ fontSize: '18px', fontWeight: 'bold', color: 'var(--blue)' }}>{card.saleRate}%</div>
          </div>
          <div style={{ background: 'var(--background)', padding: '12px', borderRadius: '8px', border: '1px solid var(--border)' }}>
            <span style={{ color: 'var(--secondary-text)', fontSize: '12px' }}>Available Stock</span>
            <div style={{ fontSize: '18px', fontWeight: 'bold', color: 'var(--primary-text)' }}>{card.available.toLocaleString()}</div>
          </div>
          <div style={{ background: 'var(--background)', padding: '12px', borderRadius: '8px', border: '1px solid var(--border)' }}>
            <span style={{ color: 'var(--secondary-text)', fontSize: '12px' }}>Total Revenue</span>
            <div style={{ fontSize: '18px', fontWeight: 'bold', color: 'var(--accent-gold)' }}>${card.revenue.toLocaleString()}</div>
          </div>
        </div>

        <div style={{ marginBottom: '20px' }}>
          <h4 style={{ margin: '0 0 8px 0', color: 'var(--primary-text)' }}>Rate History & Audit Trail</h4>
          <div style={{ background: 'var(--background)', borderRadius: '8px', border: '1px solid var(--border)', padding: '12px', fontSize: '13px' }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', borderBottom: '1px solid var(--border)', paddingBottom: '8px', marginBottom: '8px' }}>
              <span>Buy: 86% &rarr; <strong>{card.buyRate}%</strong> | Sale: 90% &rarr; <strong>{card.saleRate}%</strong></span>
              <span style={{ color: 'var(--secondary-text)' }}>Aug 12, 2026</span>
            </div>
            <div style={{ color: 'var(--secondary-text)', fontSize: '12px' }}>Changed by: Admin (Market Adjustment)</div>
          </div>
        </div>

        <div className="gc-modal-footer">
          <button className="gc-btn gc-btn-secondary" onClick={onClose}>Close Details</button>
        </div>
      </div>
    </div>
  );
};

export default GiftCardDetailsModal;