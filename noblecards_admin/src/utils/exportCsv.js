export const exportDepositsToCSV = (deposits, filename = "NobleCards_Deposits_Report.csv") => {
  if (!deposits || !deposits.length) {
    alert("No deposit data available to export.");
    return;
  }

  const headers = [
    "Deposit ID",
    "User ID",
    "User Name",
    "Username",
    "Original Amount",
    "Currency",
    "USD Value ($)",
    "Exchange Rate",
    "NobleCards Rate",
    "Markup",
    "NobleCards Fee ($)",
    "Provider Fee ($)",
    "Net Amount ($)",
    "Method",
    "Provider",
    "Provider Reference",
    "Payment Reference",
    "Status",
    "Reconciliation",
    "Date"
  ];

  const rows = deposits.map((d) => [
    `"${d.id || ''}"`,
    `"${d.userId || ''}"`,
    `"${d.userName || ''}"`,
    `"${d.userTag || ''}"`,
    d.originalAmount || 0,
    `"${d.currency || ''}"`,
    d.usdValue || 0,
    d.exchangeRate || 0,
    d.nobleRate || 0,
    d.markup || 0,
    d.fee || 0,
    d.providerFee || 0,
    d.netAmount || 0,
    `"${d.method || ''}"`,
    `"${d.provider || ''}"`,
    `"${d.providerRef || ''}"`,
    `"${d.paymentRef || ''}"`,
    `"${d.status || ''}"`,
    `"${d.reconciliation?.status || 'N/A'}"`,
    `"${d.createdAt ? new Date(d.createdAt).toLocaleString() : ''}"`
  ]);

  const csvContent = "data:text/csv;charset=utf-8," 
    + [headers.join(","), ...rows.map(e => e.join(","))].join("\n");

  const encodedUri = encodeURI(csvContent);
  const link = document.createElement("a");
  link.setAttribute("href", encodedUri);
  link.setAttribute("download", filename);
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
};