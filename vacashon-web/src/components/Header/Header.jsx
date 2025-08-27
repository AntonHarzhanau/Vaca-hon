import { useState } from "react";
import { Navbar, Nav, Container, Button } from "react-bootstrap";
import { useAuth } from "../../context/AuthContext.jsx";
import LoginModal from "../LoginModal/LoginModal.jsx";
import RegisterModal from "../RegisterModal/RegisterModal.jsx";
import logo from "../../assets/logo.png";

export default function Header() {
  const { user, logout } = useAuth();
  const [showLogin, setShowLogin] = useState(false);
  const [showRegister, setShowRegister] = useState(false);

  return (
    <>
      <Navbar bg="light" expand="lg">
        <Container>
          <Navbar.Brand href="/" className="d-flex flex-column">
            <div className="d-flex align-items-center">
              <img
                src={logo}
                alt="Vaca$hon Logo"
                width="36" height="36"
                className="d-inline-block align-top me-2"
              />
              <span>Vaca$hon</span>
            </div>
            {user?.username && (
              <small className="text-muted" style={{ marginTop: 2 }}>
                {user.username}
              </small>
            )}
          </Navbar.Brand>

          <Navbar.Toggle aria-controls="main-navbar" />
          <Navbar.Collapse id="main-navbar">
            <Nav className="ms-auto align-items-center gap-2">
              <Nav.Link href="/">Home</Nav.Link>

              {!user && (
                <>
                  <Button variant="outline-primary" onClick={() => setShowLogin(true)}>
                    Login
                  </Button>
                  <Button variant="primary" onClick={() => setShowRegister(true)}>
                    Register
                  </Button>
                </>
              )}

              {user && (
                <Button variant="outline-secondary" onClick={logout}>
                  Logout
                </Button>
              )}
            </Nav>
          </Navbar.Collapse>
        </Container>
      </Navbar>

      <LoginModal show={showLogin}  handleClose={() => setShowLogin(false)} />
      <RegisterModal show={showRegister} handleClose={() => setShowRegister(false)} />
    </>
  );
}
