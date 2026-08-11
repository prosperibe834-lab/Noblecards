import React from 'react';

const StatCard = ({ stat }) => {
  return (
    <div className="stat-card">
      <div className="stat-card-top">
        <div
          className="stat-icon-wrapper"
          style={{ backgroundColor: stat.iconBg, color: stat.iconColor }}
        >
          <i className={`bx ${stat.icon}`}></i>
        </div>
        <button className="stat-card-more" aria-label="More options">
          <i className="bx bx-dots-vertical-rounded"></i>
        </button>
      </div>

      <div>
        <span className="stat-card-title">{stat.title}</span>
        <h2 className="stat-card-value">{stat.value}</h2>
      </div>

      <div className="stat-card-footer">
        <span className={`stat-trend-indicator ${stat.isPositive ? 'positive' : 'negative'}`}>
          <i className={`bx ${stat.isPositive ? 'bx-up-arrow-alt' : 'bx-down-arrow-alt'}`}></i>
          {stat.change}
        </span>
        <span className="stat-comparison-text">{stat.comparisonText}</span>
      </div>
    </div>
  );
};

export default StatCard;