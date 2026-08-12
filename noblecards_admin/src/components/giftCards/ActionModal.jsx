import React from 'react';

const ActionModal = ({ isOpen, onClose, actionType, card, onConfirm }) => {
  if (!isOpen || !card) return null;

  const getDetails = () => {
    switch (actionType) {
      case 'Suspend':
        return {
          title: 'Suspend Gift Card?',
          text: `Are you sure you want to suspend ${card.name}? This may prevent users from buying or selling this card temporarily.`,
          btnText: 'Suspend Card',
          btnClass: 'gc-btn-secondary' // Can override with warning colors locally
        };
      case 'Delete':
        return {
          title: 'Delete Gift Card?',
          text: `This action will remove ${card.name} from the active marketplace entirely. Are you sure?`,
          btnText: 'Delete Gift Card',
          btnClass: 'gc-btn-secondary'
        };
      default:
        return {
          title: `${actionType} Gift Card?`,
          text: `Are you sure you want to ${actionType.toLowerCase()} ${card.name}?`,
          btnText: `Confirm ${actionType}`,
          btnClass: 'gc-btn-primary'
        };
    }
  };

  const details = getDetails();

  return (
    <div className="gc-modal-overlay">
      <div className="gc-modal-content">
        <div className="gc-modal-header">
          <h2 className="gc-modal-title">{details.title}</h2>
          <button className="gc-close-btn" onClick={onClose}>&times;</button>
        </div>
        <p style={{ color: 'var(--secondary-text)', marginBottom: '24px' }}>
          {details.text}
        </p>
        <div className="gc-modal-footer">
          <button className="gc-btn gc-btn-secondary" onClick={onClose}>Cancel</button>
          <button className={`gc-btn ${details.btnClass}`} onClick={() => onConfirm(card.id, actionType)}>
            {details.btnText}
          </button>
        </div>
      </div>
    </div>
  );
};

export default ActionModal;