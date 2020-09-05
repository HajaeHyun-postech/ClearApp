abstract class NavigationService {
  get key;

  void pop({Object arguments});

  Future<dynamic> pushNamed(String routeName, {Object arguments});

  Future<dynamic> pushNamedAndRemoveAll(String routeName, {Object arguments});
}
