import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { Modal, Button, Form, Alert, Spinner } from "react-bootstrap";
import { AuthAPI } from "../../api/client.js";

export default function RegisterModal({ show, handleClose }) {
  const navigate = useNavigate();

  const [data, setData] = useState({ email: "", username: "", password: "" });
  const [loading, setLoading] = useState(false);
  const [errorMsg, setErrorMsg] = useState("");
  const [successMsg, setSuccessMsg] = useState("");

  async function handleSubmit(e) {
    e.preventDefault();
    setErrorMsg(""); setSuccessMsg(""); setLoading(true);
    try {
      const payload = await AuthAPI.register(data);
      setSuccessMsg("Account created successfully.");
      setTimeout(() => {
        handleClose();
        navigate("/confirm", { state: { id: payload.id, email: payload.email, username: payload.username } });
      }, 500);
    } catch (err) {
      setErrorMsg(err.message || "Registration failed.");
    } finally {
      setLoading(false);
    }
  }

  function resetAndClose() {
    setData({ email: "", username: "", password: "" });
    setErrorMsg(""); setSuccessMsg("");
    handleClose();
  }

  return (
    <Modal show={show} onHide={resetAndClose} centered>
      <Modal.Header closeButton><Modal.Title>Register</Modal.Title></Modal.Header>
      <Modal.Body>
        {errorMsg && <Alert variant="danger" className="mb-3">{errorMsg}</Alert>}
        {successMsg && <Alert variant="success" className="mb-3">{successMsg}</Alert>}

        <Form onSubmit={handleSubmit} noValidate>
          <Form.Group className="mb-3" controlId="regEmail">
            <Form.Label>Email</Form.Label>
            <Form.Control type="email" placeholder="you@example.com"
              value={data.email}
              onChange={(e) => setData(p => ({ ...p, email: e.target.value }))}
              required />
          </Form.Group>

          <Form.Group className="mb-3" controlId="regUsername">
            <Form.Label>Username</Form.Label>
            <Form.Control type="text" placeholder="Choose a username"
              value={data.username}
              onChange={(e) => setData(p => ({ ...p, username: e.target.value }))}
              required />
          </Form.Group>

          <Form.Group className="mb-3" controlId="regPassword">
            <Form.Label>Password</Form.Label>
            <Form.Control type="password" placeholder="Create a password"
              value={data.password}
              onChange={(e) => setData(p => ({ ...p, password: e.target.value }))}
              required />
          </Form.Group>

          <Button className="w-100" variant="primary" type="submit" disabled={loading}>
            {loading ? <Spinner size="sm" animation="border" /> : "Register"}
          </Button>
        </Form>
      </Modal.Body>
    </Modal>
  );
}
