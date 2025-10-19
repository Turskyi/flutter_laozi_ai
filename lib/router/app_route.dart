enum AppRoute {
  home('/'),
  about('/about'),
  faq('/faq'),
  privacy('/privacy'),
  support('/support');

  const AppRoute(this.path);

  final String path;
}
