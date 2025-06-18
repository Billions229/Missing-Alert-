export interface User {
  id: string;
  email: string;
  phone: string;
  name: string;
  userType: 'family' | 'volunteer' | 'super_observer' | 'authority';
  isVerified: boolean;
  createdAt: Date;
}

export interface Alert {
  id: string;
  personName: string;
  age: number;
  description: string;
  photoUrl: string;
  lastKnownLocation: Location;
  frequentPlaces: string[];
  status: 'pending' | 'validated' | 'resolved' | 'cancelled';
  createdBy: string;
  createdAt: Date;
  validatedAt?: Date;
  resolvedAt?: Date;
}

export interface Location {
  latitude: number;
  longitude: number;
  address?: string;
}

export interface Sighting {
  id: string;
  alertId: string;
  reportedBy: string;
  location: Location;
  photoUrl?: string;
  comment?: string;
  timestamp: Date;
}
