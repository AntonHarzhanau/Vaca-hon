const BASE_URL = "http://localhost:8000";

function jsonHeaders(token) {
  const h = { "Content-Type": "application/json" };
  if (token) h["Authorization"] = `Bearer ${token}`;
  return h;
}

/** Универсальный JSON-запрос с логированием */
export async function api(path, { method = "GET", token, body } = {}) {
  const url = `${BASE_URL}${path}`;
  const options = {
    method,
    headers: jsonHeaders(token),
    body: body ? JSON.stringify(body) : undefined,
  };

  console.groupCollapsed(`API ${method} ${path}`);
  console.log("Req URL:", url);
  console.log("Req Options:", options);
  console.groupEnd();

  const res = await fetch(url, options);
  const text = await res.text();

  let payload = null;
  try { payload = text ? JSON.parse(text) : null; } catch { /* not JSON */ }

  console.groupCollapsed(`API RESPONSE ${method} ${path}`);
  console.log("Status:", res.status, "OK:", res.ok);
  console.log("Headers:", Object.fromEntries(res.headers.entries()));
  console.log("Body:", payload ?? text);
  console.groupEnd();

  if (!res.ok) {
    const detail = (payload && (payload.detail || payload.message)) || text || `HTTP ${res.status}`;
    throw new Error(detail);
  }
  return payload;
}

// Специализированные вызовы под ваши маршруты:
export const AuthAPI = {
  register(data)   { return api("/Users",         { method: "POST", body: data }); },               // {email, username, password}
  login(data)      { return api("/Users/login",   { method: "POST", body: data }); },               // {login, password}
  confirm(data)    { return api("/Users/confirm", { method: "POST", body: data }); },               // {id, confirm_code}
};
