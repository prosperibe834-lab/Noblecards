import React, { useState, useEffect } from 'react';

const ManageRatesModal = ({ isOpen, onClose, card, onSave }) => {
  const [buyRate, setBuyRate] = useState('');
  const [saleRate, setSaleRate] = useState('');
  
  useEffect(() => {
    if (card) {
      setBuyRate(card.buyRate);
      setSaleRate(card.saleRate);
    }
  }, [card]);

  if (!isOpen || !card) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    // Simulate API call to Laravel backend
    // axios.put(`/api/v1/admin/giftcards/${card.cardId}/rates`, { buyRate, saleRate })
    onSave(card.id, parseFloat(buyRate), parseFloat(saleRate));
  };

  return (
    <div className="gc-modal-overlay">
      <div className="gc-modal-content">
        <div className="gc-modal-header">
          <h2 className="gc-modal-title">Manage Rates: {card.name}</h2>
          <button className="gc-close-btn" onClick={onClose}>&times;</button>
        </div>
        
        <form onSubmit={handleSubmit}>
          <div className="gc-form-group">
            <label>Buy Rate (%) - What NobleCards pays sellers</label>
            <input 
              type="number" 
              value={buyRate} 
              onChange={(e) => setBuyRate(e.target.value)} 
              min="1" max="100" required 
            />
          </div>
          <div className="gc-form-group">
            <label>Sale Rate (%) - What buyers pay</label>
            <input 
              type="number" 
              value={saleRate} 
              onChange={(e) => setSaleRate(e.target.value)} 
              min="1" max="100" required 
            />
          </div>
          
          <div className="gc-modal-footer">
            <button type="button" className="gc-btn gc-btn-secondary" onClick={onClose}>Cancel</button>
            <button type="submit" className="gc-btn gc-btn-primary">Update Rates</button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default ManageRatesModal;