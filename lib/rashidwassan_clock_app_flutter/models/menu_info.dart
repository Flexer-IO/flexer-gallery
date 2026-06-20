import '../constants/enums.dart';

class MenuInfo {
  final MenuType menuType;
  final String title;
  String imageSource;

  MenuInfo(this.menuType, {this.title = '', this.imageSource = ''});
}