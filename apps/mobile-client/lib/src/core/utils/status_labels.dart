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
