/// En qué punto de su vida está una fiesta respecto al reloj.
///
/// Es lo que decide el aspecto de la tarjeta en el calendario: el blanco
/// dejó de ser una marca fija del JSON y pasó a significar "esto está
/// pasando ahora mismo".
enum EventStatus {
  /// Todavía no empieza.
  upcoming,

  /// Está ocurriendo: entre su hora de inicio y la de fin.
  inProgress,

  /// Ya terminó.
  past,
}
