enum AppRoute {
  home('/'),
  about('/about'),
  faq('/faq'),
  privacy('/privacy'),
  support('/support'),
  manuscript('/manuscript'),
  manuscriptSaved('/manuscript/saved'),
  manuscriptSearch('/manuscript/search');

  const AppRoute(this.path);

  final String path;
}
