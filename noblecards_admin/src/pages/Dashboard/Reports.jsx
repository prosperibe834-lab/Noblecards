// src/pages/Dashboard/Reports.jsx
import React, { useState, useEffect } from 'react';
import { 
  AreaChart, Area, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer,
  PieChart, Pie, Cell, Legend
} from 'recharts';
import { generateMockData } from '../../data/reportsData';
import ReportControls from '../../components/reports/ReportControls';
import ReportStats from '../../components/reports/ReportStats';
import '../../styles/reports.css';

const formatCurrency = (val) => new Intl.NumberFormat('en-US', { style: 'currency', currency: 'USD', minimumFractionDigits: 0 }).format(val);

const Reports = () => {
  const [loading, setLoading] = useState(true);
  const [refreshing, setRefreshing] = useState(false);
  const [data, setData] = useState(null);
  
  // Filters State
  const [dateRange, setDateRange] = useState('30days');
  const [reportType, setReportType] = useState('revenue');
  const [customDates, setCustomDates] = useState({ start: '', end: '' });
  const [searchTable, setSearchTable] = useState('');

  // Simulate network fetch when filters change
  useEffect(() => {
    fetchData();
  }, [dateRange, reportType]);

  const fetchData = () => {
    setLoading(true);
    // Determine data multiplier to simulate different date ranges
    let multiplier = 1;
    if (dateRange === '7days') multiplier = 0.25;
    if (dateRange === 'today') multiplier = 0.03;
    if (dateRange === 'thisyear') multiplier = 12;

    setTimeout(() => {
      setData(generateMockData(multiplier));
      setLoading(false);
      setRefreshing(false);
    }, 800); // Realistic network delay
  };

  const handleRefresh = () => {
    setRefreshing(true);
    fetchData();
  };

  const exportCSV = () => {
    if (!data) return;
    
    // Example export of Financial Summary table
    let csvContent = "data:text/csv;charset=utf-8,";
    csvContent += "Metric,Current Period,Previous Period,Change(%)\n";
    
    data.financialSummary.forEach(row => {
      csvContent += `"${row.metric}","${row.current}","${row.previous}","${row.change}"\n`;
    });

    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `NobleCards_Report_${dateRange}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  if (!data && loading) {
    return <div className="reports-dashboard shimmer" style={{ minHeight: '100vh' }}></div>;
  }

  return (
    <div className="reports-dashboard">
      
      {/* HEADER SECTION */}
      <div className="reports-header">
        <div className="reports-title">
          <h1>Reports & Analytics</h1>
          <p>Comprehensive overview of NobleCards business performance</p>
        </div>
        <div className="reports-actions">
          <button className="btn-action" onClick={handleRefresh} disabled={refreshing}>
            <i className={`bx bx-refresh ${refreshing ? 'spin' : ''}`}></i>
            {refreshing ? 'Refreshing...' : 'Refresh Data'}
          </button>
          <button className="btn-action">
            <i className="bx bx-calendar-event"></i>
            Schedule Report
          </button>
          <button className="btn-action primary" onClick={exportCSV}>
            <i className="bx bx-export"></i>
            Export CSV
          </button>
        </div>
      </div>

      {/* CONTROLS */}
      <ReportControls 
        dateRange={dateRange} 
        setDateRange={setDateRange}
        reportType={reportType}
        setReportType={setReportType}
        customDates={customDates}
        setCustomDates={setCustomDates}
      />

      {/* INSIGHTS */}
      <div className="analytics-insights">
        <i className="bx bx-bulb"></i>
        <div>
          <strong>AI Insight: </strong> 
          {data?.insights[Math.floor(Math.random() * data.insights.length)]}
        </div>
      </div>

      {/* SUMMARY STATS */}
      <ReportStats summary={data?.summary} loading={loading} />

      {/* MONEY FLOW VISUALIZATION */}
      <div className="money-flow">
        <div className="flow-node">
          <div className="flow-node-icon"><i className="bx bx-wallet"></i></div>
          <div className="flow-node-title">Total Deposits</div>
          <div className="flow-node-value">{formatCurrency(data?.summary.deposits)}</div>
        </div>
        <i className="bx bx-right-arrow-alt flow-arrow"></i>
        <div className="flow-node">
          <div className="flow-node-icon"><i className="bx bx-transfer"></i></div>
          <div className="flow-node-title">Transaction Vol</div>
          <div className="flow-node-value">{formatCurrency(data?.summary.transactionVolume)}</div>
        </div>
        <i className="bx bx-right-arrow-alt flow-arrow"></i>
        <div className="flow-node">
          <div className="flow-node-icon"><i className="bx bx-gift"></i></div>
          <div className="flow-node-title">Gift Card Vol</div>
          <div className="flow-node-value">{formatCurrency(data?.summary.giftCardRevenue)}</div>
        </div>
        <i className="bx bx-right-arrow-alt flow-arrow"></i>
        <div className="flow-node">
          <div className="flow-node-icon" style={{color: 'var(--success-color)'}}><i className="bx bx-line-chart"></i></div>
          <div className="flow-node-title">Net Revenue</div>
          <div className="flow-node-value">{formatCurrency(data?.summary.netRevenue)}</div>
        </div>
      </div>

      {/* CHARTS */}
      <div className="charts-grid">
        {/* Main Area Chart */}
        <div className="chart-card">
          <h3>Revenue & Transaction Volume</h3>
          {loading ? (
             <div className="shimmer" style={{ height: 300, borderRadius: 8 }}></div>
          ) : (
            <ResponsiveContainer width="100%" height={300}>
              <AreaChart data={data?.revenueChart} margin={{ top: 10, right: 30, left: 0, bottom: 0 }}>
                <defs>
                  <linearGradient id="colorRevenue" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="var(--primary-green)" stopOpacity={0.8}/>
                    <stop offset="95%" stopColor="var(--primary-green)" stopOpacity={0}/>
                  </linearGradient>
                  <linearGradient id="colorVolume" x1="0" y1="0" x2="0" y2="1">
                    <stop offset="5%" stopColor="var(--blue)" stopOpacity={0.8}/>
                    <stop offset="95%" stopColor="var(--blue)" stopOpacity={0}/>
                  </linearGradient>
                </defs>
                <XAxis dataKey="name" stroke="var(--text-secondary)" fontSize={12} />
                <YAxis stroke="var(--text-secondary)" fontSize={12} tickFormatter={(val) => `$${val/1000}k`} />
                <CartesianGrid strokeDasharray="3 3" stroke="var(--border-color)" vertical={false} />
                <Tooltip 
                  contentStyle={{ backgroundColor: 'var(--bg-card)', borderColor: 'var(--border-color)', color: 'var(--text-primary)' }}
                  formatter={(value) => formatCurrency(value)}
                />
                <Area type="monotone" dataKey="volume" stroke="var(--blue)" fillOpacity={1} fill="url(#colorVolume)" name="Transaction Volume" />
                <Area type="monotone" dataKey="revenue" stroke="var(--primary-green)" fillOpacity={1} fill="url(#colorRevenue)" name="Revenue" />
              </AreaChart>
            </ResponsiveContainer>
          )}
        </div>

        {/* Transaction Status Donut */}
        <div className="chart-card">
          <h3>Transaction Status</h3>
          {loading ? (
            <div className="shimmer" style={{ height: 300, borderRadius: 8 }}></div>
          ) : (
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={data?.statusChart}
                  cx="50%"
                  cy="50%"
                  innerRadius={60}
                  outerRadius={80}
                  paddingAngle={5}
                  dataKey="value"
                >
                  {data?.statusChart.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={entry.fill} />
                  ))}
                </Pie>
                <Tooltip 
                  contentStyle={{ backgroundColor: 'var(--bg-card)', borderColor: 'var(--border-color)', color: 'var(--text-primary)' }}
                  formatter={(value) => `${value}%`}
                />
                <Legend verticalAlign="bottom" height={36}/>
              </PieChart>
            </ResponsiveContainer>
          )}
        </div>
      </div>

      {/* DATA TABLES SECTION */}
      <div className="data-tables-grid">
        
        {/* Table 1: Financial Summary */}
        <div className="table-card">
          <div className="table-header">
            <h3>Financial Summary</h3>
          </div>
          <div style={{ overflowX: 'auto' }}>
            <table className="noble-table">
              <thead>
                <tr>
                  <th>Metric</th>
                  <th>Current Period</th>
                  <th>Previous Period</th>
                  <th>Change</th>
                </tr>
              </thead>
              <tbody>
                {loading ? Array(5).fill(0).map((_, i) => (
                  <tr key={i}><td colSpan="4"><div className="shimmer" style={{height: 20, width: '100%'}}></div></td></tr>
                )) : data?.financialSummary.map((row, i) => (
                  <tr key={i}>
                    <td style={{fontWeight: 500}}>{row.metric}</td>
                    <td>{formatCurrency(row.current)}</td>
                    <td>{formatCurrency(row.previous)}</td>
                    <td style={{color: row.change >= 0 ? 'var(--success-color)' : 'var(--danger-color)', fontWeight: 600}}>
                      {row.change >= 0 ? '+' : ''}{row.change}%
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Table 2: Top Gift Cards */}
        <div className="table-card">
          <div className="table-header">
            <h3>Best-Selling Gift Cards</h3>
            <div className="table-search">
              <input 
                type="text" 
                placeholder="Search cards..." 
                value={searchTable}
                onChange={(e) => setSearchTable(e.target.value)}
              />
            </div>
          </div>
          <div style={{ overflowX: 'auto' }}>
            <table className="noble-table">
              <thead>
                <tr>
                  <th>Brand</th>
                  <th>Cards Sold</th>
                  <th>Volume</th>
                  <th>Revenue</th>
                </tr>
              </thead>
              <tbody>
                {loading ? Array(5).fill(0).map((_, i) => (
                  <tr key={i}><td colSpan="4"><div className="shimmer" style={{height: 20, width: '100%'}}></div></td></tr>
                )) : data?.giftCards
                  .filter(gc => gc.name.toLowerCase().includes(searchTable.toLowerCase()))
                  .map((gc, i) => (
                  <tr key={i}>
                    <td>
                      <div style={{fontWeight: 600}}>{gc.name}</div>
                      <div style={{fontSize: 12, color: 'var(--text-secondary)'}}>{gc.category}</div>
                    </td>
                    <td>{gc.sold.toLocaleString()}</td>
                    <td>{formatCurrency(gc.volume)}</td>
                    <td style={{color: 'var(--success-color)', fontWeight: 600}}>{formatCurrency(gc.revenue)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Table 3: Country Analytics */}
        <div className="table-card">
          <div className="table-header">
            <h3>Top Countries by Volume</h3>
          </div>
          <div style={{ overflowX: 'auto' }}>
            <table className="noble-table">
              <thead>
                <tr>
                  <th>Country</th>
                  <th>Active Users</th>
                  <th>Volume</th>
                  <th>Revenue</th>
                </tr>
              </thead>
              <tbody>
                {loading ? Array(4).fill(0).map((_, i) => (
                  <tr key={i}><td colSpan="4"><div className="shimmer" style={{height: 20, width: '100%'}}></div></td></tr>
                )) : data?.countries.map((country, i) => (
                  <tr key={i}>
                    <td style={{fontWeight: 500, display: 'flex', alignItems: 'center', gap: '8px'}}>
                      <img src={`https://flagcdn.com/24x18/${country.code.toLowerCase()}.png`} alt={country.name} />
                      {country.name}
                    </td>
                    <td>{country.users.toLocaleString()}</td>
                    <td>{formatCurrency(country.volume)}</td>
                    <td>{formatCurrency(country.revenue)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Table 4: Currency Analytics */}
        <div className="table-card">
          <div className="table-header">
            <h3>Currency Performance (USD Base)</h3>
          </div>
          <div style={{ overflowX: 'auto' }}>
            <table className="noble-table">
              <thead>
                <tr>
                  <th>Currency</th>
                  <th>Deposits</th>
                  <th>Withdrawals</th>
                  <th>Revenue</th>
                </tr>
              </thead>
              <tbody>
                {loading ? Array(3).fill(0).map((_, i) => (
                  <tr key={i}><td colSpan="4"><div className="shimmer" style={{height: 20, width: '100%'}}></div></td></tr>
                )) : data?.currencies.map((curr, i) => (
                  <tr key={i}>
                    <td style={{fontWeight: 600}}>{curr.name}</td>
                    <td>{formatCurrency(curr.deposit)}</td>
                    <td>{formatCurrency(curr.withdrawal)}</td>
                    <td style={{color: 'var(--success-color)', fontWeight: 600}}>{formatCurrency(curr.revenue)}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

      </div>
    </div>
  );
};

export default Reports;