import "package:flutter/material.dart";
import "package:flutter_gen/gen_l10n/app_localizations.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/widgets/app_config.dart";
import "package:kana_to_kanji/src/core/widgets/app_scaffold.dart";
import "package:kana_to_kanji/src/settings/settings_view_model.dart";
import "package:kana_to_kanji/src/settings/widgets/button_item.dart";
import "package:kana_to_kanji/src/settings/widgets/heading_item.dart";
import "package:kana_to_kanji/src/settings/widgets/tile_item.dart";
import "package:stacked/stacked.dart";

class SettingsView extends StatelessWidget {
  static const routeName = "/settings";

  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return ViewModelBuilder<SettingsViewModel>.reactive(
        viewModelBuilder: () => SettingsViewModel(l10n: l10n),
        builder: (context, viewModel, child) => AppScaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(l10n.settings),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => context.pop(),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    // General section
                    HeadingItem(title: l10n.settings_general_section),
                    TileItem(
                      title: Text(l10n.settings_theme_mode),
                      trailing: ToggleButtons(
                        isSelected: viewModel.themeModeSelected,
                        onPressed: viewModel.setThemeMode,
                        children: viewModel.themeModes.values
                            .map((value) => Tooltip(
                                message: value["tooltip"],
                                child: Icon(value["icon"])))
                            .toList(growable: false),
                      ),
                    ),
                    TileItem(
                      title: Text(l10n.settings_language),
                      trailing: DropdownButton<Locale>(
                        value: viewModel.currentLocale ??
                            Localizations.localeOf(context),
                        icon: const Icon(Icons.arrow_downward_rounded),
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: viewModel.setLocale,
                        items: AppLocalizations.supportedLocales
                            .map<DropdownMenuItem<Locale>>((Locale locale) =>
                                DropdownMenuItem<Locale>(
                                  value: locale,
                                  child:
                                      Text(l10n.language(locale.languageCode)),
                                ))
                            .toList(),
                      ),
                    ),
                    ButtonItem(
                        onPressed: viewModel.giveFeedback,
                        child: Text(l10n.settings_give_feedback)),
                    // Legal section
                    HeadingItem(title: l10n.settings_legal_section),
                    TileItem(
                      title: Text(l10n.settings_acknowledgements),
                      onTap: () {
                        showLicensePage(
                            context: context,
                            applicationVersion: viewModel.version);
                      },
                      trailing: const Icon(Icons.arrow_forward_rounded),
                    ),
                    // Danger section
                    HeadingItem(title: l10n.settings_danger_section),
                    FilledButton(
                        onPressed: () async =>
                            viewModel.confirmDeletion(context),
                        style:
                            FilledButton.styleFrom(backgroundColor: Colors.red),
                        child: Text(l10n.settings_delete_account)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.settings_app_version(
                        AppConfig.of(context).environment.name,
                        viewModel.version)),
                  ],
                )
              ],
            )));
  }
}
