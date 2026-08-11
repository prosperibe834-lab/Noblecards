import Sidebar from "./components/Sidebar";
import AppRoutes from "./routes/AppRoutes";

function App() {
  return (
    <div className="admin-app">
      <Sidebar />

      <main className="main-content">
        <AppRoutes />
      </main>
    </div>
  );
}

export default App;