import React from 'react';
import { useNavigate } from 'react-router-dom';

const RecentTransactions = ({ transactions }) => {
  const navigate = useNavigate();

  return (
    <div className="dashboard-card">
      <div className="dashboard-card-header">
        <h3 className="dashboard-card-title">Recent Transactions</h3>
        <button
          className="view-all-btn"
          onClick={() => navigate('/transactions')}
        >
          View All
        </button>
      </div>

      <div className="recent-tx-list">
        {transactions.map((tx) => (
          <div key={tx.id} className="tx-item-row">
            <div className="tx-item-left">
              <div className="tx-brand-icon-box">
                <i className={`bx ${tx.icon}`} style={{ color: tx.iconColor }}></i>
              </div>
              <div className="tx-details-group">
                <span className="tx-card-title">{tx.cardName}</span>
                <span className="tx-user-sub">{tx.user}</span>
              </div>
            </div>

            <div className="tx-item-right">
              <span className="tx-amount-green">{tx.amount}</span>
              <span className="tx-time-sub">{tx.time}</span>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default RecentTransactions;