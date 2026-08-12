import React, { useState } from 'react';
import { filterOptions } from '../../data/giftCardData';

const AddGiftCardModal = ({ isOpen, onClose, onAdd }) => {
  const [formData, setFormData] = useState({
    name: '',
    brand: '',
    category: filterOptions.categories[0],
    country: filterOptions.countries[0],
    currency: filterOptions.currencies[0],
    cardType: 'Digital Code',
    buyRate: 85,
    saleRate: 90,
    available: 0,
    description: '',
    terms: ''
  });

  const [denominations, setDenominations] = useState(['10', '25', '50', '100']);
  const [denomInput, setDenomInput] = useState('');
  const [errors, setErrors] = useState({});

  if (!isOpen) return null;

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
    if (errors[name]) {
      setErrors(prev => ({ ...prev, [name]: null }));
    }
  };

  const handleAddDenomination = (e) => {
    e.preventDefault();
    if (denomInput.trim() && !denominations.includes(denomInput.trim())) {
      setDenominations([...denominations, denomInput.trim()]);
      setDenomInput('');
    }
  };

  const handleRemoveDenomination = (tag) => {
    setDenominations(denominations.filter(d => d !== tag));
  };

  const validate = () => {
    const newErrors = {};
    if (!formData.name.trim()) newErrors.name = 'Gift card name is required';
    if (!formData.brand.trim()) newErrors.brand = 'Brand is required';
    if (formData.buyRate <= 0 || formData.buyRate > 100) newErrors.buyRate = 'Invalid buy rate (1-100)';
    if (formData.saleRate <= 0 || formData.saleRate > 100) newErrors.saleRate = 'Invalid sale rate (1-100)';
    if (parseFloat(formData.buyRate) >= parseFloat(formData.saleRate)) {
      newErrors.saleRate = 'Sale rate must be higher than buy rate';
    }
    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (!validate()) return;

    // Generate unique card ID: GC-XXXXXX
    const generatedCardId = `GC-${Math.floor(100000 + Math.random() * 900000)}`;

    const newCard = {
      id: Date.now(),
      cardId: generatedCardId,
      name: formData.name,
      brand: formData.brand,
      category: formData.category,
      country: formData.country,
      currency: formData.currency,
      cardType: formData.cardType,
      buyRate: parseFloat(formData.buyRate),
      saleRate: parseFloat(formData.saleRate),
      available: parseInt(formData.available, 10) || 0,
      sold: 0,
      status: 'Active',
      revenue: 0,
      totalValue: (parseInt(formData.available, 10) || 0) * 100,
      denominations: denominations,
      description: formData.description,
      terms: formData.terms,
      updatedAt: new Date().toISOString().split('T')[0]
    };

    onAdd(newCard);
    onClose();
  };

  return (
    <div className="gc-modal-overlay">
      <div className="gc-modal-content gc-modal-large">
        <div className="gc-modal-header">
          <h2 className="gc-modal-title">Add New Gift Card</h2>
          <button className="gc-close-btn" onClick={onClose}>&times;</button>
        </div>

        <form onSubmit={handleSubmit} className="gc-form-grid">
          <div className="gc-form-group">
            <label>Gift Card Name *</label>
            <input 
              type="text" 
              name="name" 
              placeholder="e.g. Amazon Gift Card" 
              value={formData.name} 
              onChange={handleChange} 
            />
            {errors.name && <span className="gc-error-text">{errors.name}</span>}
          </div>

          <div className="gc-form-group">
            <label>Brand *</label>
            <input 
              type="text" 
              name="brand" 
              placeholder="e.g. Amazon" 
              value={formData.brand} 
              onChange={handleChange} 
            />
            {errors.brand && <span className="gc-error-text">{errors.brand}</span>}
          </div>

          <div className="gc-form-group">
            <label>Category</label>
            <select name="category" value={formData.category} onChange={handleChange}>
              {filterOptions.categories.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>

          <div className="gc-form-group">
            <label>Country</label>
            <select name="country" value={formData.country} onChange={handleChange}>
              {filterOptions.countries.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>

          <div className="gc-form-group">
            <label>Currency</label>
            <select name="currency" value={formData.currency} onChange={handleChange}>
              {filterOptions.currencies.map(c => <option key={c} value={c}>{c}</option>)}
            </select>
          </div>

          <div className="gc-form-group">
            <label>Card Type</label>
            <select name="cardType" value={formData.cardType} onChange={handleChange}>
              <option value="Digital Code">Digital Code</option>
              <option value="Physical Card">Physical Card</option>
            </select>
          </div>

          <div className="gc-form-group">
            <label>Buy Rate (%) - NobleCards Pays</label>
            <input 
              type="number" 
              name="buyRate" 
              value={formData.buyRate} 
              onChange={handleChange} 
              min="1" 
              max="100" 
            />
            {errors.buyRate && <span className="gc-error-text">{errors.buyRate}</span>}
          </div>

          <div className="gc-form-group">
            <label>Sale Rate (%) - Customer Pays</label>
            <input 
              type="number" 
              name="saleRate" 
              value={formData.saleRate} 
              onChange={handleChange} 
              min="1" 
              max="100" 
            />
            {errors.saleRate && <span className="gc-error-text">{errors.saleRate}</span>}
          </div>

          <div className="gc-form-group">
            <label>Initial Inventory Count</label>
            <input 
              type="number" 
              name="available" 
              value={formData.available} 
              onChange={handleChange} 
              min="0" 
            />
          </div>

          <div className="gc-form-group gc-full-width">
            <label>Available Denominations</label>
            <div className="gc-tag-input-container">
              <div className="gc-tags-list">
                {denominations.map(denom => (
                  <span key={denom} className="gc-tag">
                    {formData.currency} {denom}
                    <i className="bx bx-x" onClick={() => handleRemoveDenomination(denom)}></i>
                  </span>
                ))}
              </div>
              <div className="gc-tag-field">
                <input 
                  type="number" 
                  placeholder="Add denomination amount (e.g. 200)" 
                  value={denomInput} 
                  onChange={(e) => setDenomInput(e.target.value)} 
                />
                <button type="button" className="gc-btn gc-btn-secondary" onClick={handleAddDenomination}>
                  Add
                </button>
              </div>
            </div>
          </div>

          <div className="gc-modal-footer gc-full-width">
            <button type="button" className="gc-btn gc-btn-secondary" onClick={onClose}>
              Cancel
            </button>
            <button type="submit" className="gc-btn gc-btn-primary">
              <i className="bx bx-check"></i> Create Gift Card
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AddGiftCardModal;