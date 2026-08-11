import React, { useState } from 'react';
import {
  ResponsiveContainer,
  AreaChart,
  Area,
  XAxis,
  YAxis,
  Tooltip,
  CartesianGrid,
} from 'recharts';

const RevenueChart = ({ revenueData }) => {
  const [timeframe, setTimeframe] = useState('This Week');
  const activeData = revenueData.timeframeData[timeframe] || revenueData.timeframeData['This Week'];

  return (
    <div className="dashboard-card">
      <div className="dashboard-card-header">
        <div>
          <span className="stat-card-title">Revenue Overview</span>
          <div style={{ display: 'flex', alignItems: 'center', gap: '8px', marginTop: '4px' }}>
            <span style={{ fontSize: '1.25rem', fontWeight: 800 }}>{revenueData.totalRevenue}</span>
            <span className="stat-trend-indicator positive" style={{ fontSize: '0.8rem' }}>
              <i className="bx bx-up-arrow-alt"></i>
              {revenueData.growth}
            </span>
          </div>
        </div>

        <select
          className="card-timeframe-select"
          value={timeframe}
          onChange={(e) => setTimeframe(e.target.value)}
        >
          <option value="This Week">This Week</option>
          <option value="This Month">This Month</option>
          <option value="This Year">This Year</option>
        </select>
      </div>

      <div style={{ width: '100%', height: 220 }}>
        <ResponsiveContainer width="100%" height="100%">
          <AreaChart data={activeData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
            <defs>
              <linearGradient id="revenueGradient" x1="0" y1="0" x2="0" y2="1">
                <stop offset="5%" stopColor="#7C3AED" stopOpacity={0.35} />
                <stop offset="95%" stopColor="#7C3AED" stopOpacity={0.0} />
              </linearGradient>
            </defs>
            <CartesianGrid strokeDasharray="3 3" vertical={false} stroke="var(--border)" />
            <XAxis
              dataKey="date"
              axisLine={false}
              tickLine={false}
              tick={{ fill: 'var(--secondary-text)', fontSize: 11 }}
            />
            <YAxis
              axisLine={false}
              tickLine={false}
              tick={{ fill: 'var(--secondary-text)', fontSize: 11 }}
              tickFormatter={(val) => `$${val / 1000}K`}
            />
            <Tooltip
              contentStyle={{
                backgroundColor: 'var(--card)',
                borderColor: 'var(--border)',
                borderRadius: '8px',
                color: 'var(--primary-text)',
                fontSize: '12px',
                fontWeight: 600,
              }}
              formatter={(value) => [`$${value.toLocaleString()}`, 'Revenue']}
            />
            <Area
              type="monotone"
              dataKey="revenue"
              stroke="#7C3AED"
              strokeWidth={3}
              fillOpacity={1}
              fill="url(#revenueGradient)"
            />
          </AreaChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
};

export default RevenueChart;