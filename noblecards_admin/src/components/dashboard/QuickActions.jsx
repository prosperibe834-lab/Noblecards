import React from 'react';
import { useNavigate } from 'react-router-dom';

const QuickActions = ({ actions }) => {
  const navigate = useNavigate();

  return (
    <div className="dashboard-card">
      <div className="dashboard-card-header">
        <h3 className="dashboard-card-title">Quick Actions</h3>
      </div>

      <div className="quick-actions-flex">
        {actions.map((act, index) => (
          <div
            key={index}
            className="quick-action-item"
            onClick={() => navigate(act.route)}
            title={act.label}
          >
            <div
              className="action-icon-wrapper"
              style={{ backgroundColor: act.bg, color: act.color }}
            >
              <i className={`bx ${act.icon}`}></i>
            </div>
            <span>{act.label}</span>
          </div>
        ))}
      </div>
    </div>
  );
};

export default QuickActions;