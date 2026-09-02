dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../src/assets_picker.dart'; // For InstaAssetPickerConfig and InstaAssetCropDelegate
import '../src/widget/insta_asset_picker_delegate.dart'; // For InstaAssetPickerBuilderDelegate
import 'deps/wechat_assets_picker/wechat_assets_picker.dart'; // For AssetPicker, AssetPickerPage

/// A Flutter page wrapper for the `insta_assets_picker` library.
///
/// This page provides a minimal wrapper to display the `InstaAssetPicker` UI.
/// It uses `AssetPickerPage` from `wechat_assets_picker` as the underlying
/// widget, configured with `InstaAssetPickerBuilderDelegate`.
class LegoffmaelInstaAssetsPickerPage extends StatefulWidget {
  const LegoffmaelInstaAssetsPickerPage({super.key});

  @override
  State<LegoffmaelInstaAssetsPickerPage> createState() =>
      _LegoffmaelInstaAssetsPickerPageState();
}

class _LegoffmaelInstaAssetsPickerPageState
    extends State<LegoffmaelInstaAssetsPickerPage> {
  late InstaAssetPickerBuilderDelegate _delegate;

  @override
  void initState() {
    super.initState();
    // Initialize the delegate with minimal required parameters.
    // The actual configuration can be passed via constructor if needed,
    // but for a thin wrapper, default values are sufficient.
