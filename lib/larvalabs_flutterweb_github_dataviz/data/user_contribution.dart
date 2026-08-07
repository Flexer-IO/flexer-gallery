import 'contribution_data.dart';
import 'user.dart';

class UserContribution {
  final User user;
  final List<ContributionData> contributions;

  UserContribution(this.user, this.contributions);

  static UserContribution fromJson(Map<String, dynamic> jsonMap) {
    final List<ContributionData> contributionList = (jsonMap['weeks'] as List<dynamic>)
        .map((e) => ContributionData.fromJson(e as Map<String, dynamic>))
        .toList();
    final User user = User.fromJson(jsonMap['author'] as Map<String, dynamic>);
    return UserContribution(user, contributionList);
  }
}