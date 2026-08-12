import React from 'react';
import {
  ResponsiveContainer,
  AreaChart,
  Area,
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  XAxis,
  YAxis,
  Tooltip,
  Legend
} from 'recharts';

export const DepositCharts = ({ chartData }) => {
  return (
    <div className="deposit-charts-grid">
      {/* 1. Deposit Volume Trend */}
      <div className="chart-card">
        <div className="chart-header">
          <h4><i className="bx bx-line-chart"></i> Deposit Volume Trend (USD)</h4>
          <span className="chart-sub">Daily volume & throughput</span>
        </div>
        <div className="chart-body">
          <ResponsiveContainer width="100%" height={240}>
            <AreaChart data={chartData.volumeOverTime}>
              <defs>
                <linearGradient id="volumeGrad" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="var(--primary-color, #4f46e5)" stopOpacity={0.4}/>
                  <stop offset="95%" stopColor="var(--primary-color, #4f46e5)" stopOpacity={0.0}/>
                </linearGradient>
              </defs>
              <XAxis dataKey="date" stroke="var(--text-secondary)" fontSize={12} />
              <YAxis stroke="var(--text-secondary)" fontSize={12} tickFormatter={(val) => `$${val/1000}k`} />
              <Tooltip 
                formatter={(value) => [`$${value.toLocaleString()}`, 'Volume']}
                contentStyle={{ background: 'var(--bg-card)', borderColor: 'var(--border-color)', borderRadius: '8px' }}
              />
              <Area 
                type="monotone" 
                dataKey="volume" 
                stroke="var(--primary-color, #4f46e5)" 
                strokeWidth={2}
                fillOpacity={1} 
                fill="url(#volumeGrad)" 
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* 2. Deposit Status Distribution */}
      <div className="chart-card">
        <div className="chart-header">
          <h4><i className="bx bx-pie-chart-alt-2"></i> Status Breakdown</h4>
          <span className="chart-sub">Volume proportion</span>
        </div>
        <div className="chart-body">
          <ResponsiveContainer width="100%" height={240}>
            <PieChart>
              <Pie
                data={chartData.statusBreakdown}
                cx="50%"
                cy="50%"
                innerRadius={55}
                outerRadius={80}
                paddingAngle={4}
                dataKey="value"
              >
                {chartData.statusBreakdown.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={entry.color} />
                ))}
              </Pie>
              <Tooltip formatter={(val) => `$${val.toLocaleString()}`} />
              <Legend verticalAlign="bottom" height={36} />
            </PieChart>
          </ResponsiveContainer>
        </div>
      </div>

      {/* 3. Deposit Methods Bar Chart */}
      <div className="chart-card">
        <div className="chart-header">
          <h4><i className="bx bx-bar-chart-alt-2"></i> Popular Deposit Methods</h4>
          <span className="chart-sub">Volume by channel</span>
        </div>
        <div className="chart-body">
          <ResponsiveContainer width="100%" height={240}>
            <BarChart data={chartData.methodBreakdown}>
              <XAxis dataKey="method" stroke="var(--text-secondary)" fontSize={11} />
              <YAxis stroke="var(--text-secondary)" fontSize={12} tickFormatter={(val) => `$${val/1000000}M`} />
              <Tooltip formatter={(value) => `$${value.toLocaleString()}`} />
              <Bar dataKey="amount" fill="var(--info-color, #3b82f6)" radius={[6, 6, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
    </div>
  );
};