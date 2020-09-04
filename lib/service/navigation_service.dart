abstract class NavigationService {
  get key;

  Future<dynamic> pushNamed(String routeName, {Object arguments});

  Future<dynamic> pushNamedAndRemoveAll(String routeName, {Object arguments});
}
