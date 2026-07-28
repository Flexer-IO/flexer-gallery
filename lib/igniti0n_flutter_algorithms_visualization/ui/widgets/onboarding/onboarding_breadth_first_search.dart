import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers/onboarding_page_state_notifier.dart';
import 'ui/common/blue_text_button.dart';
import 'ui/common/text/texts.dart';
import 'ui/common/text/unit_rounded_text.dart';
import 'ui/widgets/url_launchable_title.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingBreadthFirstSearch extends ConsumerWidget {
  const OnboardingBreadthFirstSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UrlLaunchableTitle(
            text: 'Breadth-first search',
            onPressed: () => launchUrl(Uri.parse('https://en.wikipedia.org/wiki/Breadth-first_search')),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Image.asset(
              "packages/showcase_library/assets/igniti0n_flutter_algorithms_visualization/bfs.gif",
            ),
          ),
          const UnitRoundedText(
            Texts.breadthFirstExplanation,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlueTextButton(
                text: 'Previous',
                onPressed: () => ref.read(onboardingPageStateNotifierProvider.notifier).goToPreviousPage(),
              ),
              const SizedBox(
                width: 60,
              ),
              BlueTextButton(
                text: 'How about DFS?',
                onPressed: () => ref.read(onboardingPageStateNotifierProvider.notifier).goToNextPage(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
