export const emptyUser = { id: null, username: "", email: "", token: null };

export function userFromRegister(payload) {
  return {
    id: payload?.id ?? null,
    username: payload?.username ?? "",
    email: payload?.email ?? "",
    token: null,
  };
}

export function userFromLogin(payload) {
  const u = payload?.user || {};
  return {
    id: u?.id ?? null,
    username: u?.username ?? "",
    email: u?.email ?? "",
    token: payload?.token ?? null,
  };
}

export function saveUser(u) {
  try { localStorage.setItem("user", JSON.stringify(u)); } catch {}
}

export function loadUser() {
  try {
    const raw = localStorage.getItem("user");
    return raw ? JSON.parse(raw) : null;
  } catch {
    return null;
  }
}
export function clearUser() {
  try { localStorage.removeItem("user"); } catch {}
}
