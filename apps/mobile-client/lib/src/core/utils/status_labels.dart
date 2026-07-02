bool bookingIsPastNotClosed({
  required String status,
  required DateTime? endsAt,
  DateTime? now,
}) {
  if (endsAt == null) return false;
  final cursor = now ?? DateTime.now();
  return endsAt.isBefore(cursor) &&
      (status == 'confirmed' || status == 'in_progress' || status == 'pending');
}

String bookingStatusLabel(String status, {DateTime? endsAt}) {
  if (bookingIsPastNotClosed(status: status, endsAt: endsAt)) {
    return 'Passé';
  }
  return switch (status) {
    'confirmed' => 'Confirmé',
    'pending' => 'En attente',
    'in_progress' => 'En cours',
    'completed' => 'Terminé',
    'cancelled' => 'Annulé',
    _ => 'En attente',
  };
}

String bookingStatusHeadline(String status, {DateTime? endsAt}) {
  if (bookingIsPastNotClosed(status: status, endsAt: endsAt)) {
    return 'Rendez-vous passé';
  }
  return switch (status) {
    'confirmed' => 'Rendez-vous confirmé',
    'in_progress' => 'Rendez-vous en cours',
    'completed' => 'Rendez-vous terminé',
    'cancelled' => 'Rendez-vous annulé',
    _ => 'En attente de confirmation',
  };
}

String bookingDepositHeadline(String depositPaymentStatus) {
  return switch (depositPaymentStatus) {
    'authorized' => 'Paiement en vérification',
    'succeeded' => 'Acompte confirmé',
    'failed' => 'Paiement à reprendre',
    'refunded' => 'Acompte remboursé',
    _ => 'Acompte à finaliser',
  };
}

String bookingDepositSupportingText(String depositPaymentStatus) {
  return switch (depositPaymentStatus) {
    'authorized' =>
      'Le paiement a été lancé. Nous attendons encore la confirmation de l\'opérateur.',
    'succeeded' => 'Votre acompte a bien été confirmé.',
    'failed' =>
      'Le paiement n\'a pas été confirmé. Relancez le paiement pour finaliser la réservation.',
    'refunded' => 'Cet acompte a été remboursé.',
    _ => 'Le rendez-vous sera confirmé dès réception de l\'acompte.',
  };
}
