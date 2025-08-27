import { useState } from "react";
import { Modal, Button, Form, Alert, Spinner } from "react-bootstrap";
import { useAuth } from "../../context/AuthContext.jsx";
import { userFromLogin } from "../../models/user.js";
import { AuthAPI } from "../../api/client.js";

export default function LoginModal({ show, handleClose }) {
  const { setUser } = useAuth();
  const [credentials, setCredentials] = useState({ login: "", password: "" });
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");
  const [successMsg, setSuccessMsg] = useState("");

  async function handleSubmit(e) {
    e.preventDefault();
    setErrorMsg(""); setSuccessMsg(""); setLoading(true);
    try {
      const payload = await AuthAPI.login(credentials);
      const u = userFromLogin(payload);
      setUser(u);
      setSuccessMsg("Logged in successfully.");
      setTimeout(() => handleClose(), 800);
    } catch (err) {
      setErrorMsg(err.message || "Login failed.");
    } finally {
      setLoading(false);
    }
  }

  function resetAndClose() {
    setCredentials({ login: "", password: "" });
    setErrorMsg(""); setSuccessMsg("");
    handleClose();
  }

  return (
    <Modal show={show} onHide={resetAndClose} centered>
      <Modal.Header closeButton><Modal.Title>Login</Modal.Title></Modal.Header>
      <Modal.Body>
        {errorMsg && <Alert variant="danger" className="mb-3">{errorMsg}</Alert>}
        {successMsg && <Alert variant="success" className="mb-3">{successMsg}</Alert>}

        <Form onSubmit={handleSubmit}>
          <Form.Group className="mb-3" controlId="formLogin">
            <Form.Label>Login</Form.Label>
            <Form.Control
              type="text" placeholder="Enter login"
              value={credentials.login}
              onChange={(e) => setCredentials(p => ({ ...p, login: e.target.value }))}
              autoFocus required
            />
          </Form.Group>

          <Form.Group className="mb-3" controlId="formPassword">
            <Form.Label>Password</Form.Label>
            <Form.Control
              type="password" placeholder="Enter password"
              value={credentials.password}
              onChange={(e) => setCredentials(p => ({ ...p, password: e.target.value }))}
              required
            />
          </Form.Group>

          <Button className="w-100" variant="primary" type="submit" disabled={loading}>
            {loading ? <Spinner size="sm" animation="border" /> : "Login"}
          </Button>
        </Form>
      </Modal.Body>
    </Modal>
  );
}
