import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:versionary/src/app.dart';
import 'package:versionary/src/api/api.dart';

// Regular expression that validates an email address.
// See https://emailregex.com/ for details.
final emailValidator = RegExp(
  r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$',
);

class LoginView extends ConsumerStatefulWidget {
  const LoginView({
    super.key,
  });

  static const routeName = '/login';

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends ConsumerState<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(apiNotifierProvider).when(
          data: (api) => Scaffold(
            appBar: const VersionaryAppBar(title: 'Login'),
            body: Center(
              child: SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                        child: Text(
                          api.hostName,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildEmailField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildPasswordField(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _buildLoginButton(context, api),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (e, s) => Scaffold(
            appBar: const VersionaryAppBar(title: 'Login'),
            body: Center(
              child: Text(e.toString()),
            ),
          ),
          loading: () => const Scaffold(
            appBar: VersionaryAppBar(title: 'Login'),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
  }

  TextFormField _buildEmailField() {
    return TextFormField(
      autofocus: true,
      controller: _emailController,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'username@versionary.net',
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Required';
        } else if (!emailValidator.hasMatch(value)) {
          return 'Invalid email address';
        } else {
          return null;
        }
      },
    );
  }

  TextFormField _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
        ),
      ),
      obscureText: !_showPassword,
      validator: (value) => value!.isEmpty ? 'Required' : null,
    );
  }

  ElevatedButton _buildLoginButton(BuildContext context, Api api) {
    return ElevatedButton(
      child: const Text('Login'),
      onPressed: () {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        final email = _emailController.text;
        final password = _passwordController.text;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authenticating...')),
        );
        ref
            .read(apiNotifierProvider.notifier)
            .login(email, password)
            .then((isAdmin) {
          final msg = !api.isAuth
              ? 'Invalid email or password'
              : isAdmin
                  ? 'Logged in as $email'
                  : 'Admin credentials required';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
          setState(() {});
        }).catchError((e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        });
      },
    );
  }
}
