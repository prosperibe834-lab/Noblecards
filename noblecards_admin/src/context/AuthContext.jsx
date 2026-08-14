import React, { createContext, useContext, useState, useEffect } from "react";

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [adminUser, setAdminUser] = useState(() => {
    const saved = localStorage.getItem("noblecards_admin_user");
    return saved ? JSON.parse(saved) : null;
  });

  const [authToken, setAuthToken] = useState(() => {
    return localStorage.getItem("noblecards_admin_token") || null;
  });

  const [pendingAuthFlow, setPendingAuthFlow] = useState(() => {
    const saved = sessionStorage.getItem("noblecards_pending_flow");
    return saved ? JSON.parse(saved) : null;
  });

  const loginSuccess = (userData, token) => {
    setAdminUser(userData);
    setAuthToken(token);
    localStorage.setItem("noblecards_admin_user", JSON.stringify(userData));
    localStorage.setItem("noblecards_admin_token", token);
    sessionStorage.removeItem("noblecards_pending_flow");
  };

  const logout = () => {
    setAdminUser(null);
    setAuthToken(null);
    localStorage.removeItem("noblecards_admin_user");
    localStorage.removeItem("noblecards_admin_token");
    sessionStorage.removeItem("noblecards_pending_flow");
  };

  const setAuthFlowState = (data) => {
    setPendingAuthFlow(data);
    sessionStorage.setItem("noblecards_pending_flow", JSON.stringify(data));
  };

  return (
    <AuthContext.Provider
      value={{
        adminUser,
        authToken,
        isAuthenticated: !!authToken,
        pendingAuthFlow,
        loginSuccess,
        logout,
        setAuthFlowState,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};