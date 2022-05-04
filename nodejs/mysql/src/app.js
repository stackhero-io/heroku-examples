const mysqlx = require('@mysql/xdevapi');

(async () => {
  if (!process.env.STACKHERO_MYSQL_HOST) {
    throw Error('STACKHERO_MYSQL_HOST environment variable is not defined!');
  }

  console.log('🤓 Starting test...');

  // Connection to MySQL using MySQL X Protocol
  console.log(`Connecting to database on ${process.env.STACKHERO_MYSQL_HOST}...`);
  const session = await mysqlx.getSession({
    host: process.env.STACKHERO_MYSQL_HOST,
    user: 'root',
    password: process.env.STACKHERO_MYSQL_ROOT_PASSWORD
  });


  // Create a schema (database) if not exists
  const schemaExists = await session.getSchema('stackherotest').existsInDatabase();
  if (!schemaExists) {
    await session.createSchema('stackherotest');
  }

  // Create table "users" if not exists
  const tableExists = await session
    .getSchema('stackherotest')
    .getTable('users')
    .existsInDatabase();
  if (!tableExists) {
    console.log('Creating test table...');
    await session
      .sql('CREATE TABLE `stackherotest`.`users` '
        + '('
        + '`userId` INT UNSIGNED NOT NULL,'
        + '`name` VARCHAR(128) NOT NULL,'
        + '`address` TEXT NOT NULL,'
        + '`email` VARCHAR(265) NOT NULL'
        + ') '
        + 'ENGINE = InnoDB;')
      .execute();
  }


  // Insert a fake user
  console.log('Inserting a fake user to the database...');
  await session
    .getSchema('stackherotest') // Database name
    .getTable('users') // Table name
    .insert('userId', 'name', 'address', 'email') // Columns names
    .values(
      Math.round(Math.random() * 100000), // Generate a fake userId
      'User name', // column 'name'
      'User address', // column 'address'
      'user@email.com' // column 'email'
    )
    .execute();


  // Count number of rows in table users
  const usersCount = await session
    .getSchema('stackherotest') // Database name
    .getTable('users')
    .count();

  console.log(`There is now ${usersCount} entries in table "users"`);

  console.log();
  console.log('🥳 Congratulations! The connection to the database works and reading/writing to it works!');

  // Close the connection to MySQL
  await session.close();

})().catch(error => {
  console.error('');
  console.error('🐞 An error occurred!');
  console.error(error);
  process.exit(1);
});