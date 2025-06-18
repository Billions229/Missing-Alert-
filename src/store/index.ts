import { create } from 'zustand';
import { User, Alert } from '../types';

interface AppState {
  user: User | null;
  alerts: Alert[];
  isLoading: boolean;
  setUser: (user: User | null) => void;
  setAlerts: (alerts: Alert[]) => void;
  setLoading: (loading: boolean) => void;
  addAlert: (alert: Alert) => void;
  updateAlert: (id: string, updates: Partial<Alert>) => void;
}

export const useAppStore = create<AppState>((set) => ({
  user: null,
  alerts: [],
  isLoading: false,
  setUser: (user) => set({ user }),
  setAlerts: (alerts) => set({ alerts }),
  setLoading: (isLoading) => set({ isLoading }),
  addAlert: (alert) => set((state) => ({
    alerts: [...state.alerts, alert]
  })),
  updateAlert: (id, updates) => set((state) => ({
    alerts: state.alerts.map(alert =>
      alert.id === id ? { ...alert, ...updates } : alert
    )
  })),
}));
