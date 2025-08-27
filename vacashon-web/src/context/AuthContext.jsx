import { createContext, useContext, useEffect, useMemo, useReducer } from "react";
import { loadUser, saveUser, clearUser } from "../models/user.js";

const AuthContext = createContext(null);

function reducer(state, action) {
  switch (action.type) {
    case "SET_USER": return { ...state, user: action.payload };
    case "LOGOUT":   return { ...state, user: null };
    default:         return state;
  }
}

export function AuthProvider({ children }) {
  const [state, dispatch] = useReducer(reducer, { user: loadUser() });

  useEffect(() => {
    state.user ? saveUser(state.user) : clearUser();
  }, [state.user]);

  const value = useMemo(() => ({
    user: state.user,
    setUser: (u) => dispatch({ type: "SET_USER", payload: u }),
    logout: ()   => dispatch({ type: "LOGOUT" }),
  }), [state.user]);

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error("useAuth must be used within <AuthProvider>");
  return ctx;
}
