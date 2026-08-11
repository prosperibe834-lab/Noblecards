import React, { useState } from 'react';
import { NavLink } from 'react-router-dom';
import { useTheme } from '../context/ThemeContext';
import { SIDEBAR_LINKS } from '../constants/navigation';
import '../styles/sidebar.css';

// Importing both logos
import LightLogo from '../assets/logo/MainLightLogo.png.png';
import DarkLogo from '../assets/logo/MainDarkLogo.png.png';

const Sidebar = ({ isMobileOpen, closeMobileSidebar }) => {
  const { isDarkMode, toggleTheme } = useTheme();
  
  // Desktop collapse state
  const [isCollapsed, setIsCollapsed] = useState(false);

  // Determine active logo based on theme
  const currentLogo = isDarkMode ? DarkLogo : LightLogo;

  // Handles clicking a link on mobile to auto-close the drawer
  const handleLinkClick = () => {
    if (window.innerWidth <= 992 && closeMobileSidebar) {
      closeMobileSidebar();
    }
  };

  const handleLogout = () => {
    // TODO: Implement Auth Service Logout logic here
    console.log('Admin logged out.');
  };

  return (
    <>
      {/* Mobile Backdrop Overlay */}
      {isMobileOpen && (
        <div 
          className="mobile-backdrop" 
          onClick={closeMobileSidebar}
          style={{
            position: 'fixed', top: 0, left: 0, width: '100%', height: '100%',
            backgroundColor: 'rgba(0,0,0,0.5)', zIndex: 40
          }}
        />
      )}

      {/* Main Sidebar Container */}
      <aside className={`sidebar ${isCollapsed ? 'collapsed' : ''} ${isMobileOpen ? 'mobile-open' : ''}`}>
        
        {/* Header Section */}
        <div className="sidebar-header">
          <div className="brand">
            <img src={currentLogo} alt="NobleCards" className="brand-logo" />
            <div className="brand-text">
              <span className="brand-title">NobleCards</span>
              <span className="brand-subtitle">Admin Panel</span>
            </div>
          </div>
          
          <button 
            className="collapse-btn" 
            onClick={() => setIsCollapsed(!isCollapsed)}
            aria-label="Toggle Sidebar"
            title={isCollapsed ? "Expand Sidebar" : "Collapse Sidebar"}
          >
            <i className="bx bx-chevrons-left"></i>
          </button>
        </div>

        {/* Navigation Links */}
        <nav className="sidebar-nav" aria-label="Main Navigation">
          {SIDEBAR_LINKS.map((link, index) => (
            <NavLink
              key={index}
              to={link.path}
              onClick={handleLinkClick}
              className={({ isActive }) => `nav-item ${isActive ? 'active' : ''}`}
              data-tooltip={link.label}
            >
              <i className={link.icon}></i>
              <span className="nav-label">{link.label}</span>
              {link.hasBadge && <span className="nav-badge"></span>}
            </NavLink>
          ))}
        </nav>

        {/* Footer Section */}
        <div className="sidebar-footer">
          {/* Theme Toggle Card */}
          <div 
            className="theme-toggle-card" 
            onClick={toggleTheme}
            aria-label="Toggle Light/Dark Mode"
          >
            <div className="theme-toggle-info">
              <i className={isDarkMode ? "bx bx-moon" : "bx bx-sun"}></i>
              <span>{isDarkMode ? "Dark Mode" : "Light Mode"}</span>
            </div>
            <div className="custom-switch"></div>
          </div>

          {/* Logout Button */}
          <button className="logout-btn" onClick={handleLogout} aria-label="Logout">
            <i className="bx bx-log-out"></i>
            <span>Logout</span>
          </button>
        </div>
      </aside>
    </>
  );
};

export default Sidebar;