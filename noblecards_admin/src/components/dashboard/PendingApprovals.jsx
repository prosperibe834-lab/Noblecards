import React from 'react';
import { useNavigate } from 'react-router-dom';

const PendingApprovals = ({ approvals }) => {
  const navigate = useNavigate();

  return (
    <div className="dashboard-card">
      <div className="dashboard-card-header">
        <h3 className="dashboard-card-title">Pending Approvals</h3>
      </div>

      <div className="pending-grid-row">
        {approvals.map((item) => (
          <div key={item.id} className="pending-card-box">
            <div className="pending-card-header">
              <p>{item.title}</p>
              <i className={`bx ${item.icon}`} style={{ color: item.color }}></i>
            </div>
            <span className="pending-count-large">{item.count}</span>
            <span
              className="pending-view-link"
              onClick={() => navigate(item.route)}
            >
              View
            </span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default PendingApprovals;