// ==========================================
// NEW FILE
// File: src/services/securityLogService.js
// Purpose: Business logic for Security Audit Logs filtering, searching, export, and API simulation
// ==========================================

import { MOCK_SECURITY_LOGS, INITIAL_SECURITY_ALERTS } from "../data/securityLogsData";

export class SecurityLogService {
  /**
   * Simulates fetching security statistics calculated from log history.
   */
  static async getStatistics() {
    await new Promise((resolve) => setTimeout(resolve, 300));

    const totalEvents = MOCK_SECURITY_LOGS.length;
    const successfulEvents = MOCK_SECURITY_LOGS.filter((l) => l.status === "Success").length;
    const failedEvents = MOCK_SECURITY_LOGS.filter((l) => l.status === "Failed").length;
    const suspiciousEvents = MOCK_SECURITY_LOGS.filter((l) => l.status === "Suspicious" || l.risk === "CRITICAL").length;
    const adminActions = MOCK_SECURITY_LOGS.filter((l) => l.actor === "Admin").length;
    const userEvents = MOCK_SECURITY_LOGS.filter((l) => l.actor === "User").length;
    const loginAttempts = MOCK_SECURITY_LOGS.filter((l) => l.eventType === "Login").length;
    const blockedAttempts = MOCK_SECURITY_LOGS.filter((l) => l.status === "Blocked").length;

    return {
      totalEvents,
      successfulEvents,
      failedEvents,
      suspiciousEvents,
      adminActions,
      userEvents,
      loginAttempts,
      blockedAttempts
    };
  }

  /**
   * Simulates fetching active security alerts.
   */
  static async getAlerts() {
    await new Promise((resolve) => setTimeout(resolve, 200));
    return [...INITIAL_SECURITY_ALERTS];
  }

  /**
   * Primary filter & search function matching user specifications.
   */
  static async getLogs(params = {}) {
    // Artificial latency simulation for realistic UI feel
    await new Promise((resolve) => setTimeout(resolve, 350));

    let logs = [...MOCK_SECURITY_LOGS];

    const {
      search = "",
      eventType = "ALL",
      status = "ALL",
      risk = "ALL",
      actor = "ALL",
      country = "ALL",
      device = "ALL",
      dateRange = "ALL",
      startDate = "",
      endDate = "",
      page = 1,
      pageSize = 10
    } = params;

    // 1. Text Search across multiple fields
    if (search.trim()) {
      const query = search.trim().toLowerCase();
      logs = logs.filter((log) => {
        return (
          (log.userName && log.userName.toLowerCase().includes(query)) ||
          (log.username && log.username.toLowerCase().includes(query)) ||
          (log.userEmail && log.userEmail.toLowerCase().includes(query)) ||
          (log.userId && log.userId.toLowerCase().includes(query)) ||
          (log.adminId && log.adminId.toLowerCase().includes(query)) ||
          (log.adminName && log.adminName.toLowerCase().includes(query)) ||
          (log.ipAddress && log.ipAddress.toLowerCase().includes(query)) ||
          (log.event && log.event.toLowerCase().includes(query)) ||
          (log.deviceType && log.deviceType.toLowerCase().includes(query)) ||
          (log.city && log.city.toLowerCase().includes(query)) ||
          (log.actor && log.actor.toLowerCase().includes(query)) ||
          (log.description && log.description.toLowerCase().includes(query))
        );
      });
    }

    // 2. Event Type Filter
    if (eventType !== "ALL") {
      logs = logs.filter((log) => log.eventType.toLowerCase() === eventType.toLowerCase());
    }

    // 3. Status Filter
    if (status !== "ALL") {
      logs = logs.filter((log) => log.status.toLowerCase() === status.toLowerCase());
    }

    // 4. Risk Level Filter
    if (risk !== "ALL") {
      logs = logs.filter((log) => log.risk.toLowerCase() === risk.toLowerCase());
    }

    // 5. Actor Type Filter
    if (actor !== "ALL") {
      logs = logs.filter((log) => log.actor.toLowerCase() === actor.toLowerCase());
    }

    // 6. Country Filter
    if (country !== "ALL") {
      logs = logs.filter((log) => log.country.toLowerCase() === country.toLowerCase());
    }

    // 7. Device Filter
    if (device !== "ALL") {
      logs = logs.filter((log) => log.deviceType.toLowerCase() === device.toLowerCase());
    }

    // 8. Date Range Filter
    if (dateRange !== "ALL") {
      const now = new Date("2026-08-14T12:30:00"); // Standard reference anchor
      logs = logs.filter((log) => {
        const logTime = new Date(log.timestamp);

        if (dateRange === "TODAY") {
          return logTime.toDateString() === now.toDateString();
        }
        if (dateRange === "YESTERDAY") {
          const y = new Date(now);
          y.setDate(now.getDate() - 1);
          return logTime.toDateString() === y.toDateString();
        }
        if (dateRange === "LAST_7_DAYS") {
          const sevenDaysAgo = new Date(now);
          sevenDaysAgo.setDate(now.getDate() - 7);
          return logTime >= sevenDaysAgo && logTime <= now;
        }
        if (dateRange === "LAST_30_DAYS") {
          const thirtyDaysAgo = new Date(now);
          thirtyDaysAgo.setDate(now.getDate() - 30);
          return logTime >= thirtyDaysAgo && logTime <= now;
        }
        if (dateRange === "THIS_MONTH") {
          return logTime.getMonth() === now.getMonth() && logTime.getFullYear() === now.getFullYear();
        }
        if (dateRange === "LAST_MONTH") {
          const lastMonth = new Date(now.getFullYear(), now.getMonth() - 1, 1);
          return logTime.getMonth() === lastMonth.getMonth() && logTime.getFullYear() === lastMonth.getFullYear();
        }
        if (dateRange === "CUSTOM" && startDate && endDate) {
          const start = new Date(startDate);
          const end = new Date(endDate);
          end.setHours(23, 59, 59, 999);
          return logTime >= start && logTime <= end;
        }
        return true;
      });
    }

    const totalRecords = logs.length;
    const totalPages = Math.ceil(totalRecords / pageSize) || 1;
    const validPage = Math.min(Math.max(1, page), totalPages);

    const startIndex = (validPage - 1) * pageSize;
    const paginatedLogs = logs.slice(startIndex, startIndex + pageSize);

    return {
      data: paginatedLogs,
      pagination: {
        totalRecords,
        totalPages,
        currentPage: validPage,
        pageSize
      }
    };
  }

  /**
   * Generates and triggers download for CSV based on current active filters.
   */
  static exportToCSV(logs) {
    if (!logs || !logs.length) return false;

    const headers = [
      "Log ID",
      "Timestamp",
      "Event",
      "Type",
      "Actor",
      "User ID / Admin ID",
      "User / Admin Name",
      "IP Address",
      "Country",
      "City",
      "ISP",
      "Device",
      "OS",
      "Browser",
      "Status",
      "Risk",
      "Description"
    ];

    const rows = logs.map((log) => [
      `"${log.id || ""}"`,
      `"${log.timestamp || ""}"`,
      `"${log.event || ""}"`,
      `"${log.eventType || ""}"`,
      `"${log.actor || ""}"`,
      `"${log.userId || log.adminId || "N/A"}"`,
      `"${log.userName || log.adminName || "System"}"`,
      `"${log.ipAddress || ""}"`,
      `"${log.country || ""}"`,
      `"${log.city || ""}"`,
      `"${log.isp || ""}"`,
      `"${log.deviceType || ""}"`,
      `"${log.os || ""}"`,
      `"${log.browser || ""}"`,
      `"${log.status || ""}"`,
      `"${log.risk || ""}"`,
      `"${(log.description || "").replace(/"/g, '""')}"`
    ]);

    const csvContent = "data:text/csv;charset=utf-8," + [headers.join(","), ...rows.map((e) => e.join(","))].join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", `NobleCards_Security_Audit_${new Date().toISOString().slice(0, 10)}.csv`);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    return true;
  }
}