import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifiers/onboarding_page_state_notifier.dart';
import 'ui/common/blue_text_button.dart';
import 'ui/common/text/texts.dart';
import 'ui/common/text/unit_rounded_text.dart';
import 'ui/widgets/url_launchable_title.dart';
import 'package:url_launcher/url_launcher.dart';

class OnboardingDepthFirstSearch extends ConsumerWidget {
  const OnboardingDepthFirstSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IntrinsicHeight(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          UrlLaunchableTitle(
            text: 'Depth-first search',
            onPressed: () => launchUrl(Uri.parse('https://en.wikipedia.org/wiki/Depth-first_search')),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Image.asset(
              "packages/showcase_library/assets/igniti0n_flutter_algorithms_visualization/dfs.gif",
            ),
          ),
          const UnitRoundedText(
            Texts.depthFirstExplanation,
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
                text: 'Got it!',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
