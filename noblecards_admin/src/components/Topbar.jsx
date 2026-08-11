import React from 'react';
import '../styles/topbar.css';

const Topbar = ({ toggleSidebar }) => {
  return (
    <div className="topbar">
      <button 
        className="topbar-mobile-toggle" 
        onClick={toggleSidebar}
        aria-label="Open Menu"
        title="Open Menu"
      >
        <i className="bx bx-menu"></i>
      </button>
    </div>
  );
};

export default Topbar;
