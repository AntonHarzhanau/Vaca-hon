import { Routes, Route } from "react-router-dom";
import Header from "./components/Header/Header.jsx";
import Home from "./pages/Home/Home.jsx";
import ConfirmPage from "./pages/Confirm/ConfirmPage.jsx";

export default function App() {
  return (
    <>
      <Header />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/confirm" element={<ConfirmPage />} />
      </Routes>
    </>
  );
}
