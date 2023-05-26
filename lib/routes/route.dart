import 'package:auto_route/auto_route.dart';
import 'package:untitled/routes/route.gr.dart';


part 'route_imports.dart';

@AutoRouterConfig( replaceInRouteName: 'Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get routeType => const RouteType.adaptive();

  @override
  List<AutoRoute> get routes => [

    AutoRoute(page: HomeScreenRoute.page, initial: true),
    AutoRoute(page: AttendanceScreenRoute.page),
  ];
}