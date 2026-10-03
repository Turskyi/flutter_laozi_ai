enum AppRoute {
  home('/'),
  about('/about'),
  faq('/faq'),
  privacy('/privacy'),
  support('/support'),
  manuscript('/manuscript');

  const AppRoute(this.path);

  final String path;
}
