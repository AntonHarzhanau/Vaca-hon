import { useMemo, useState } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import { Container, Row, Col, Card, Form, Button, Spinner, Alert } from "react-bootstrap";
import { useAuth } from "../../context/AuthContext.jsx";
import { userFromRegister } from "../../models/user.js";
import { AuthAPI } from "../../api/client.js";

export default function ConfirmPage() {
  const { setUser } = useAuth();
  const location = useLocation();
  const navigate = useNavigate();

  const initial = useMemo(() => {
    const st = location.state || {};
    const sp = new URLSearchParams(location.search);
    return {
      id: st.id ?? (sp.get("id") ? Number(sp.get("id")) : null),
      email: st.email ?? sp.get("email") ?? "",
      username: st.username ?? "",
    };
  }, [location]);

  const [confirmCode, setConfirmCode] = useState("");
  const [loading, setLoading] = useState(false);
  const [okMsg, setOkMsg] = useState("");
  const [errMsg, setErrMsg] = useState("");

  async function handleSubmit(e) {
    e.preventDefault();
    setOkMsg(""); setErrMsg(""); setLoading(true);

    if (initial.id == null) {
      setErrMsg("Missing user id. Please register again.");
      setLoading(false);
      return;
    }
    try {

      await AuthAPI.confirm({ id: initial.id, confirm_code: confirmCode });

      setOkMsg("Your account has been successfully confirmed.");

      const u = userFromRegister({ id: initial.id, email: initial.email, username: initial.username });
      setUser(u);

      setTimeout(() => navigate("/"), 1000);
    } catch (err) {
      setErrMsg(err.message || "Confirmation failed.");
    } finally {
      setLoading(false);
    }
  }

  return (
    <Container className="py-4">
      <Row className="justify-content-center">
        <Col md={6} lg={5}>
          <Card>
            <Card.Body>
              <h3 className="mb-3 text-center">Confirm Registration</h3>

              <p className="text-muted">
                Enter the password that was sent to the specified email address.
              </p>
              {initial.email && <p className="mb-3"><strong>Email:</strong> {initial.email}</p>}

              {errMsg && <Alert variant="danger">{errMsg}</Alert>}
              {okMsg && <Alert variant="success">{okMsg}</Alert>}

              <Form onSubmit={handleSubmit} noValidate>
                <Form.Group className="mb-3" controlId="confirmCode">
                  <Form.Label>Password / Code</Form.Label>
                  <Form.Control
                    type="password"
                    placeholder="Enter the password/code from your email"
                    value={confirmCode}
                    onChange={(e) => setConfirmCode(e.target.value)}
                    required
                  />
                </Form.Group>

                <Button className="w-100" variant="primary" type="submit" disabled={loading}>
                  {loading ? <Spinner size="sm" animation="border" /> : "Confirm"}
                </Button>
              </Form>
            </Card.Body>
          </Card>
        </Col>
      </Row>
    </Container>
  );
}
