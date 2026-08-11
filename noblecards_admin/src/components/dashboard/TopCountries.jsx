import React from 'react';

const TopCountries = ({ countries }) => {
  return (
    <div className="dashboard-card">
      <div className="dashboard-card-header">
        <h3 className="dashboard-card-title">Top Countries</h3>
      </div>

      <div className="countries-section-grid">
        {/* SVG World Map Graphic */}
        <div className="map-svg-container">
          <svg viewBox="0 0 1000 500" xmlns="http://www.w3.org/2000/svg">
            <path
              d="M150,150 Q200,100 250,150 T350,150 M450,200 Q500,150 550,200 M650,250 Q700,200 750,250 M200,300 Q250,250 300,300 M500,350 Q550,300 600,350"
              stroke="var(--border)"
              strokeWidth="12"
              fill="none"
              strokeLinecap="round"
            />
            {/* Country Visual Highlight Dots */}
            <circle cx="510" cy="270" r="10" fill="#10B981" />
            <circle cx="490" cy="280" r="8" fill="#2563EB" />
            <circle cx="540" cy="290" r="8" fill="#7C3AED" />
            <circle cx="220" cy="180" r="9" fill="#F59E0B" />
            <circle cx="470" cy="150" r="7" fill="#EF4444" />
          </svg>
        </div>

        {/* Country Breakdown List */}
        <div className="country-list-group">
          {countries.map((item, index) => (
            <div key={index} className="country-list-item">
              <div className="country-info-wrapper">
                <span className="legend-dot" style={{ backgroundColor: item.color }}></span>
                <span>{item.country}</span>
              </div>
              <span className="country-stat-count">{item.count}</span>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default TopCountries;