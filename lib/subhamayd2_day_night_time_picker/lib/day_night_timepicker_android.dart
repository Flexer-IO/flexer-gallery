import 'ampm.dart';
import 'common/action_buttons.dart';
import 'common/display_value.dart';
import 'common/filter_wrapper.dart';
import 'common/wrapper_container.dart';
import 'common/wrapper_dialog.dart';
import 'daynight_banner.dart';
import 'state/state_container.dart' as state;
import 'utils.dart';
import 'constants.dart' as consts hide SelectedInput;
import 'package:flutter/material.dart';

/// Private class. [StatefulWidget] that renders the content of the picker.
// ignore: must_be_immutable
class DayNightTimePickerAndroid extends StatefulWidget {
  const DayNightTimePickerAndroid({
    Key? key,
    required this.sunrise,
    required this.sunset,
    required this.duskSpanInMinutes,
  }) : super(key: key);
  final TimeOfDay sunrise;
  final TimeOfDay sunset;
  final int duskSpanInMinutes;

  @override
  DayNightTimePickerAndroidState createState() =>
      DayNightTimePickerAndroidState();
}

/// Picker state class
class DayNightTimePickerAndroidState extends State<DayNightTimePickerAndroid> {
  late state.TimeModelBindingState timeState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timeState = state.TimeModelBinding.of(context);
  }

  @override
  Widget build(BuildContext context) {
    double min = getMin(
        timeState.widget.minMinute,
        timeState.widget.minuteInterval as consts.TimePickerInterval);
    double max = getMax(
        timeState.widget.maxMinute,
        timeState.widget.minuteInterval as consts.TimePickerInterval);

    int minDiff = (max - min).round();
    int divisions = getDivisions(
        minDiff, timeState.widget.minuteInterval as consts.TimePickerInterval);

    if (timeState.selected == state.SelectedInput.HOUR) {
      min = timeState.widget.minHour!;
      max = timeState.widget.maxHour!;
      divisions = (max - min).round();
    }

    final color =
        timeState.widget.accentColor ?? Theme.of(context).colorScheme.secondary;

    final hourValue = timeState.widget.is24HrFormat
        ? timeState.time.hour
        : ((timeState.time.hour % 12 == 0) ? 12 : timeState.time.hour % 12);

    final ltrMode =
        timeState.widget.ltrMode ? TextDirection.ltr : TextDirection.rtl;

    final hideButtons = timeState.widget.hideButtons;

    Orientation currentOrientation = MediaQuery.of(context).orientation;

    double value = timeState.time.hour.roundToDouble();
    if (timeState.selected == state.SelectedInput.MINUTE) {
      value = timeState.time.minute.roundToDouble();
    } else if (timeState.selected == state.SelectedInput.SECOND) {
      value = timeState.time.second.roundToDouble();
    }

    return Center(
      child: SingleChildScrollView(
        physics: currentOrientation == Orientation.portrait
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: FilterWrapper(
          child: WrapperDialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                DayNightBanner(
                  sunrise: widget.sunrise,
                  sunset: widget.sunset,
                  duskSpanInMinutes: widget.duskSpanInMinutes,
                ),
                WrapperContainer(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const AmPm(),
                      const SizedBox(height: 8),
                      const Spacer(),
                      Row(
                        textDirection: ltrMode,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          DisplayValue(
                            onTap: (timeState.widget.disableHour == true)
                                ? null
                                : () {
                                    timeState.onSelectedInputChange(
                                      state.SelectedInput.HOUR,
                                    );
                                  },
                            value: hourValue.toString().padLeft(2, '0'),
                            isSelected:
                                timeState.selected == state.SelectedInput.HOUR,
                          ),
                          const DisplayValue(
                            value: ':',
                          ),
                          DisplayValue(
                            onTap: (timeState.widget.disableMinute == true)
                                ? null
                                : () {
                                    timeState.onSelectedInputChange(
                                      state.SelectedInput.MINUTE,
                                    );
                                  },
                            value: timeState.time.minute
                                .toString()
                                .padLeft(2, '0'),
                            isSelected:
                                timeState.selected == state.SelectedInput.MINUTE,
                          ),
                          ...timeState.widget.showSecondSelector
                              ? [
                                  const DisplayValue(
                                    value: ':',
                                  ),
                                  DisplayValue(
                                    onTap: () {
                                      timeState.onSelectedInputChange(
                                        state.SelectedInput.SECOND,
                                      );
                                    },
                                    value: timeState.time.second
                                        .toString()
                                        .padLeft(2, '0'),
                                    isSelected: timeState.selected ==
                                        state.SelectedInput.SECOND,
                                  ),
                                ]
                              : [],
                        ],
                      ),
                      Slider(
                        onChangeEnd: (_) => onChangedSlider(),
                        value: value,
                        onChanged: timeState.onTimeChange,
                        min: min,
                        max: max,
                        divisions: divisions,
                        activeColor: color,
                        inactiveColor: color.withAlpha(55),
                      ),
                      const Spacer(),
                      if (!hideButtons) const ActionButtons(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onChangedSlider() {
    if (!(timeState.widget.disableAutoFocusToNextInput == true)) {
      if (timeState.selected == state.SelectedInput.HOUR) {
        if (!(timeState.widget.disableMinute == true)) {
          timeState.onSelectedInputChange(state.SelectedInput.MINUTE);
        } else if (timeState.widget.showSecondSelector) {
          timeState.onSelectedInputChange(state.SelectedInput.SECOND);
        }
      } else if (timeState.selected == state.SelectedInput.MINUTE &&
          timeState.widget.showSecondSelector) {
        timeState.onSelectedInputChange(state.SelectedInput.SECOND);
      }
    }
    if (timeState.widget.isOnValueChangeMode == true) {
      timeState.onOk();
    }
  }
}