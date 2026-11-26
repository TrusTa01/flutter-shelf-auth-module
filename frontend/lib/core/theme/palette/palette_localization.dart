import 'package:flutter/widgets.dart';
import 'package:flutter_shelf_auth_module/core/extensions/l10n_ext.dart';
import 'package:flutter_shelf_auth_module/core/theme/palette/palette_data.dart';

String paletteTitle(BuildContext context, PaletteData palette) {
  if (!palette.isBuiltIn) return palette.name;

  return switch (palette.id) {
    'brand' => context.l10n.paletteBrand,
    'coffee' => context.l10n.paletteCoffee,
    'ocean' => context.l10n.paletteOcean,
    'rose' => context.l10n.paletteRose,
    'forest' => context.l10n.paletteForest,
    _ => palette.name,
  };
}
