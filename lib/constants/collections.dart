class CollectionNames {
  static String users = 'users';
  static String transactions = 'transactions';
}

String get usersCollectionName => CollectionNames.users;
String get transactionsCollectionName => CollectionNames.transactions;

List<String> collectionNames = [
  usersCollectionName,
  transactionsCollectionName,
];
