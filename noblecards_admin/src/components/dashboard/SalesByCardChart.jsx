import React from 'react';
import { ResponsiveContainer, PieChart, Pie, Cell, Tooltip } from 'recharts';

const SalesByCardChart = ({ salesData }) => {
  return (
    <div className="dashboard-card">
      <div className="dashboard-card-header">
        <h3 className="dashboard-card-title">Sales by Gift Card Type</h3>
      </div>

      <div style={{ width: '100%', height: 160, position: 'relative' }}>
        <ResponsiveContainer width="100%" height="100%">
          <PieChart>
            <Pie
              data={salesData.data}
              cx="50%"
              cy="50%"
              innerRadius={50}
              outerRadius={70}
              paddingAngle={3}
              dataKey="value"
            >
              {salesData.data.map((entry, index) => (
                <Cell key={`cell-${index}`} fill={entry.color} stroke="none" />
              ))}
            </Pie>
            <Tooltip
              contentStyle={{
                backgroundColor: 'var(--card)',
                borderColor: 'var(--border)',
                borderRadius: '8px',
                color: 'var(--primary-text)',
                fontSize: '12px',
              }}
              formatter={(value, name) => [`${value} sold`, name]}
            />
          </PieChart>
        </ResponsiveContainer>

        {/* Center Donut Label */}
        <div
          style={{
            position: 'absolute',
            top: '50%',
            left: '50%',
            transform: 'translate(-50%, -50%)',
            textAlign: 'center',
            pointerEvents: 'none',
          }}
        >
          <div style={{ fontSize: '1.1rem', fontWeight: 800, lineHeight: 1 }}>
            {salesData.totalSold}
          </div>
          <div style={{ fontSize: '0.65rem', color: 'var(--secondary-text)' }}>Total Sold</div>
        </div>
      </div>

      {/* Legend Grid */}
      <div className="donut-legend-list">
        {salesData.data.map((item, idx) => (
          <div key={idx} className="donut-legend-item">
            <div className="donut-legend-label">
              <span className="legend-dot" style={{ backgroundColor: item.color }}></span>
              <span>{item.name}</span>
            </div>
            <div className="donut-legend-value">
              {item.percentage}% ({item.value})
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};

export default SalesByCardChart;