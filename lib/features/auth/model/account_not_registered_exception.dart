class AccountNotRegisteredException implements Exception {
  AccountNotRegisteredException([
    this.message = 'Number not registered',
  ]);

  final String message;

  @override
  String toString() => message;
}
