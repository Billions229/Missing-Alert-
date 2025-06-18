import { Alert } from '../types';

export const formatTimeAgo = (date: Date): string => {
  const now = new Date();
  const diffInMs = now.getTime() - date.getTime();
  const diffInHours = Math.floor(diffInMs / (1000 * 60 * 60));
  const diffInDays = Math.floor(diffInHours / 24);

  if (diffInHours < 1) {
    const diffInMinutes = Math.floor(diffInMs / (1000 * 60));
    return `il y a ${diffInMinutes} minute(s)`;
  } else if (diffInHours < 24) {
    return `il y a ${diffInHours} heure(s)`;
  } else {
    return `il y a ${diffInDays} jour(s)`;
  }
};

export const validatePhoneNumber = (phone: string): boolean => {
  const phoneRegex = /\+229[0-9]{8}$/;
  return phoneRegex.test(phone);
};

export const getAlertStatusText = (status: Alert['status']): string => {
  switch (status) {
    case 'pending':
      return 'En attente de validation';
    case 'validated':
      return 'Validee';
    case 'resolved':
      return 'Resolue';
    case 'cancelled':
      return 'Annulee';
    default:
      return 'Statut inconnu';
  }
};
