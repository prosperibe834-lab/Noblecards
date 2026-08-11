import { BrowserRouter } from "react-router-dom";
import Sidebar from "./components/Sidebar";
import { ThemeProvider } from "./context/ThemeContext";

function App() {
  return (
    <ThemeProvider>
      <BrowserRouter>
        <Sidebar />
      </BrowserRouter>
    </ThemeProvider>
  );
}

export default App;