import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:laozi_ai/application_services/repositories/email_repository_impl.dart';
import 'package:laozi_ai/application_services/repositories/settings_repository_impl.dart';
import 'package:laozi_ai/entities/enums/language.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/ui/chat/language_selector.dart';
import 'package:laozi_ai/ui/support/bloc/support_bloc.dart';
import 'package:laozi_ai/ui/widgets/home_app_bar_button.dart';
import 'package:resend/resend.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({
    required this.preferences,
    required this.initialLanguage,
    super.key,
  });

  final SharedPreferences preferences;
  final Language initialLanguage;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupportBloc>(
      create: (BuildContext _) {
        return SupportBloc(
          EmailRepositoryImpl(Resend.instance),
          SettingsRepositoryImpl(preferences),
          initialLanguage,
        );
      },
      child: _SupportPage(initialLanguage: initialLanguage),
    );
  }
}

class _SupportPage extends StatefulWidget {
  const _SupportPage({required this.initialLanguage});

  final Language initialLanguage;

  @override
  State<_SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<_SupportPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isFormPopulated = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _messageController.addListener(_onFormChanged);

    final Language currentLanguage = Language.fromIsoLanguageCode(
      LocalizedApp.of(context).delegate.currentLocale.languageCode,
    );
    final Language savedLanguage = widget.initialLanguage;
    if (currentLanguage != savedLanguage) {
      changeLocale(context, savedLanguage.isoLanguageCode)
      // The returned value in `then` is always `null`.
      .then((Object? _) {
        if (mounted) {
          context.read<SupportBloc>().add(
            ChangeSupportLanguageEvent(savedLanguage),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: kIsWeb
            ? BlocBuilder<SupportBloc, SupportState>(
                builder: (BuildContext _, SupportState state) {
                  return HomeAppBarButton(language: state.language);
                },
              )
            : null,
        title: Text(translate('support_page.title')),
        actions: <Widget>[
          BlocBuilder<SupportBloc, SupportState>(
            builder: (BuildContext context, SupportState state) {
              return LanguageSelector(
                currentLanguage: state.language,
                onLanguageSelected: (Language newLanguage) {
                  // Dispatch event to the presenter to handle language
                  // change logic and update its state (which might also
                  // update this screen's language).
                  context.read<SupportBloc>().add(
                    ChangeSupportLanguageEvent(newLanguage),
                  );
                  // Force a rebuild of the current screen's state
                  // (`_SupportPageState`).
                  // This is necessary because the `AppBar`'s title `Text`
                  // widget, which uses
                  // `translate('support_page.title')`, needs to be
                  // reconstructed with the new locale provided by the
                  // `flutter_translate` package after `changeLocale`
                  // (implicitly called) has taken effect.
                  // While the `SupportBloc`'s state will update, that
                  // not directly trigger a rebuild of the `AppBar` title
                  // without this explicit `setState`.
                  // This ensures the title immediately reflects the newly
                  // selected language.
                  setState(() {});
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<SupportBloc, SupportState>(
        listener: (BuildContext context, SupportState state) {
          if (state is SupportSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  translate('support_page.email_sent_successfully'),
                ),
              ),
            );
            _formKey.currentState?.reset();
            _nameController.clear();
            _emailController.clear();
            _messageController.clear();
          } else if (state is SupportFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (BuildContext context, SupportState state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(translate('support_page.description')),
                  const SizedBox(height: 8),
                  SelectableText(
                    translate(
                      'support_page.email_direct',
                      args: <String, Object?>{'email': constants.supportEmail},
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    translate('support_page.privacy_notice'),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: translate('support_page.full_name'),
                      hintText: translate('support_page.full_name_hint'),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return translate('support_page.fill_out_all_fields');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: translate('support_page.email_address'),
                      hintText: translate('support_page.email_address_hint'),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return translate('support_page.fill_out_all_fields');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: translate('support_page.message'),
                      hintText: translate('support_page.message_hint'),
                    ),
                    maxLines: 5,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return translate('support_page.fill_out_all_fields');
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: (state is SupportLoading || !_isFormPopulated)
                        ? null
                        : () {
                            if (_formKey.currentState?.validate() ?? false) {
                              context.read<SupportBloc>().add(
                                SendSupportEmail(
                                  name: _nameController.text,
                                  email: _emailController.text,
                                  message: _messageController.text,
                                ),
                              );
                            }
                          },
                    child: state is SupportLoading
                        ? const CircularProgressIndicator()
                        : Text(translate('support_page.send')),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _emailController.removeListener(_onFormChanged);
    _messageController.removeListener(_onFormChanged);
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final bool isPopulated =
        _nameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _messageController.text.isNotEmpty;
    if (_isFormPopulated != isPopulated) {
      setState(() {
        _isFormPopulated = isPopulated;
      });
    }
  }
}
