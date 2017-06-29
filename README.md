# Databases

## Table of Contents
1. [Introduction](#introduction)
1. [Overview of Topics](#overview-of-topics)
1. [Environment](#environment)
  1. [Requirements](#requirements)
  1. [Installing Dependencies](#installing-dependencies)
1. [Objectives & Instructions](#objectives-and-instructions)
  1. [Basic Requirements](#basic-requirements)
  1. [Advanced Requirements](#advanced)
1. [Resources](#resources)
1. [Contributing](#contributing)

## Introduction

This sprint will be a little different in that it's a walkthrough, and you'll be using a new, completely different programming language called SQL for much of it. In the second half of it, once you've got a handle on basic SQL concepts, we'll create the backend for a very simple chat app

## Overview of Topics

> ### Overview of Databases

So far, all the apps you've written keep their data in memory, and all that information gets wiped away when the app is closed. If you want to be able to store information in something other than a horrible hack, you'll need a database. Today, we're going to learn about structuring a databases (called 'Schema Design'), and doing some basic CRUD (create, read, update, delete) operations using Postgres, an incredibly powerful and flexible Relational Database.

Broadly speaking, there are two kinds of databases—relational and non-relational. There are hybrids out there, but we won't spend any time on them. We're going work almost entirely on relational databases for this sprint, but lets spend a very short while talking about both of them. 

> ### Non-relational Databases

Non-relational databases store *documents*. These tend to be JSON-like (but honestly, there's a lot of variety here) buckets of data that may or may not have a well-defined schema (way of structuring data conistently) and don't directly relate to each other. Typically, they're good at writing and reading data fast without a bunch of constraints. Some examples and their use cases:
  - MongoDB, used by [Expedia](https://www.mongodb.com/customers/expedia) to store free-form travel plans created by millions of users
  - [ElasticSearch](https://www.elastic.co/use-cases), used by companies like StackOverflow that have to fuzzy search gigabytes of data to find relevant questions and answers. Also used by lots of apps to store application logs and index them so that they're fuzzy-searchable, and useful for debugging. 
  - [Redis](https://redis.io/topics/whos-using-redis), an in-memory database that's lightning fast, mostly used as a cache to save your application from constantly hitting a relational database.
  
Non-relational databases vary quite a lot, and tend to be good for specialised use cases. I won't spend any more time discussing them because I consider each one a beast of its own.

> ### Relational Databases

Relational databases have *tables* that can relate to each other. You'll see these sometimes referred to as RDBMSs (Relational Database Management Systems). Some examples are MySQL, SQLite, Oracle and Postgres (my personal favorite, and what you'll be using). Relational databases are excellent for setting up rules and constraints for building and maintaining a robust set of data that your business logic depends on, and then querying that data. I'd guess that to a first approximation, 99% of the apps you use on any platform have a relational database of some kind behind them.

Relational databases generally try to adhere to an idealistic specification called the *SQL Standard*. SQL stands for *Structured Query language* and is a declarative language that all self-respecting relational databases strive to speak. Broadly, except for the odd quirk here and there, if you know SQL, you know how to work with any relational database. 

It's useful to have a sense of what the differences are between the various relational databases out there. There's a writeup [here](https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems) that you should read some other time. For now, we're going to work with Postgres. 

## Environment
  
You'll need to have Postgres (>v9.0.0), Node (>v6.0.0) and NPM (any version) installed for this sprint. To verify you have:
- [ ] Postgres installed, type `psql` from the command line. If you have it installed, the version will print automatically when psql opens up.
  - If `psql` returns an error that looks like `psql: could not connect to server. Is the server running locally and accepting connections on Unix domain socket "/tmp/.s.PGSQL.5432"?`, you have previously installed Postgres, but its not running.
  - If you installed it with homebrew, run `brew services start postgresql`
  - If you previously installed the [PostgresApp](https://postgresapp.com/), go to `applications` on your mac and open up Postgres.
  - Do not try to install Postgres *both* ways. This will cause one to conflict with the other and may hurt your head very much.

If you haven't got postgres installed, see the instructions below. It may be pertinent for you to read the Postgres section immediately below, even if you already have it installed. 

> ### Postgres

- [ ] Go to [PostgresApp](https://postgresapp.com/) and install Postgres on your machine.
- [ ] Verify its working by running the command `psql` in your terminal. You should see a command prompt that looks something like this:

```
psql (9.4.9)
Type "help" for help.

your_username=# 
```

To be obscenely simplistic, there are three things going on here. 
1. Postgres has created a folder somewhere on your disk for it to use to store all its information. In this folder it created a subfolder for your default database (named after your username) 
2. There is a database *daemon* running in the background. This, rather like the web servers that you've already written, is a persistent process listening for connections on a particular port on your computer. Postgres uses port 5432 by default, but you can configure it to use any port.
3. You opened up a command-line application (psql) that connected to the daemon on port 5432. This is but one way to issue commands to a database. 

A quick note before we get started: throughout this sprint you may get stuck on things. For basic questions, the [Postgres docs](https://www.postgresql.org/docs/9.6/static/index.html) will probably be far too verbose, and [postgrestutorial.com](http://www.postgresqltutorial.com/) or [StackOverflow](https://stackoverflow.com/) are your friends. For more advanced questions (specifics on types etc), definitely use the Postgres docs.

## Objectives and Instructions
  
### Basic Requirements

#### Creating Tables
We said earlier that relational databases are all about tables, so lets create some tables. A collection of tables and their associated rules in a database is called a *schema*. Let's pretend that we're creating a schema for the students at Code Chrysalis, past, present and future. For now, we want to store the name, date of birth, gender and town of origin for each student. For now, lets do this in one table.
- [ ] Open up `psql` to enter Postgres's command line. You can quit using `\q`.
- [ ] Look up the syntax for creating a database, create one called `students`, and connect to it by using `\c students`
  - Pro tip: in SQL all statements must end in a `;`. If your statement is not running, you're most likely missing one of these.

* ANSWER: ```CREATE DATABASE students;```
- [ ] Look up the syntax for creating a table in SQL.
- [ ] You're going to create a table called `students` with columns `id`, `first_name`, `last_name`, `date_of_birth`, `gender` and `town_of_origin`. You should use the type `SERIAL` for `id` but for the others, look up the postgres docs ([simplified](https://www.techonthenet.com/postgresql/datatypes.php) | [advanced](https://www.postgresql.org/docs/9.5/static/datatype.html)) and choose an appropriate data type for each column.
* ANSWER: ```CREATE TABLE students (id serial primary key, first_name varchar(50), last_name varchar(50), date_of_birth date, gender char(1), town_of_origin varchar(50));```
  - We want each student in our table to have an ID because it's often useful to have something that *we*, as the creators of apps can use to uniquely identify every single row in our table, and will *never* have a reason to change.
  - For this purpose, we often use an auto-incrementing integer as an ID whenever we create a table. This is what the type `SERIAL` does.
- [ ] Create the table
  - If you created it incorrectly, you can destroy the table using `drop table students;`
  - Note that in postgres, the case-sensitivity of column names is a gnarly subject. To make your like easy, always use snake_case for your table, column and database names
-  Some useful notes, you can:
    - see all tables in a database by entering `\dt`
    - get a description of any given table by entering `\d name_of_your_table`
    - see all databases you can connect to by entering `\l`

#### Inserting Data
- [ ] Look up the syntax to insert data into a table and insert your own names, genders and date_of_births into your students table. Do not insert an `id` for yourself: that will happen automatically.
- Look at the student data in in the file `seeds/insertStudents.sql`. We are going to change this file so that each line is an `insert` SQL statement. Then we're going to run the entire file using some `psql` magic so save you having to manually insert all of them. 
- [ ] In `seeds/insertStudents.sql`, change each line to be a valid `insert` statement that will insert the student data into the table you just created. Use your sublime shortcuts to save time! We'll actually run this file through `psql` in the next step.
  - Writing lots of SQL in the psql CLI can be painful. It's generally much easier to write a `.sql` file containing the commands you want to run. You can then pipe these commands into psql by using, for example, `psql -d students -f ./seeds/insertStudents.sql`. `-d students` tells psql to connect to the `students` database, and `-f ./seeds/insertStudents.sql` tells it to run the commands in `seeds/insertStudents.sql` as though you typed them in. 
- [ ] From your terminal, exit the postgres CLI (using `\q`), then run `psql -d students -f scripts/insertStudents.sql` to actually insert the data. You'll know it worked if you see the lines `INSERT 0 1` repeated about 100 times. If you see *anything else* that's an error. Try to understand what went wrong and fix it. 
  - If you made a mistake in your table creation rendering this step impossible, you can blow away the table you created using `drop table students;` and start again.

#### Selecting Data
In each of the following files, look up the syntax for these queries and see if you can perform them using `psql -d students -f file_name`. You can also run these queries directly inside `psql`, which can be much faster for prototyping and figuring stuff out.
- [ ] `scripts/selecting/allStudents.sql`: select all data about all students
- [ ] `scripts/selecting/fromSf.sql`: select all data about all students who are from `San Francisco` (look up `where` clauses)
- [ ] `scripts/selecting/over25.sql`: select all data about all students over 25 years old
  - [ ] Now do this without hardcoding today's date
- [ ] `scripts/selecting/studentsByAge`: select just the first_name, last_name and date_of_birth of all students in descending order of age. You may notice at this point that some of the dates of birth are very likely wrong. Don't worry, you'll fix this later. 

- In SQL, every query *must* return a table of data. However, what happens when you want to group rows together?
- Say you want to find the date_of_birth of the oldest person from each town, you'll have to group the rows of the students table together such that you only get a single row for each town. Well, when you group the rows by town, you don't have a table anymore, you have something that looks more like a nested list, e.g.:
```
- Tokyo
  - Vilhelmina | F      | 1989-03-07
  - Hallie     | F      | 1988-05-01
  - Meris      | F      | 1973-07-04
  - Anneliese  | F      | 1975-01-29
  - Angie      | F      | 1970-06-21
- Sydney
  - Harriott   | F      | 1981-09-30
  - Tyne       | F      | 1975-03-09
  - Charlene   | F      | 1984-09-11
  - Ellie      | F      | 1978-11-15
  - Leela      | F      | 1979-03-26
```
- But every query *must* return a table. To turn that nested list into a table, you'll have to [aggregate](https://www.postgresql.org/docs/9.5/static/functions-aggregate.html) each of the columns into a single value per group, so that there's only one row for each town. Use that for this final query. Note that *aggregating* a string is a weird concept, which is why we've only asked for date_of_birth and town_of_origin.
- [ ] `scripts/selecting/oldestInTown`: select just the date_of_birth and town_of_origin of the oldest student in each town (use [group by](https://www.tutorialspoint.com/postgresql/postgresql_group_by.htm))

- This next one is optional (read: difficult). Of course, sometimes you'll need to get string values out of a group-by in a query. There are two useful features in Postgres that'll help with this: [subqueries](http://www.postgresqltutorial.com/postgresql-subquery/) and [window functions](https://www.postgresql.org/docs/9.1/static/tutorial-window.html)
- [ ] `scripts/selecting/oldestInTownByGender` (Extra credit): select the first_name, date_of_birth, town_of_origin and gender of the oldest male and oldest female student in each town
  - [Hints] One way to approach this is to first write a query that will return all data for all students AND an additional column that has the date_of_birth of the oldest person in each town of each gender. Use a window function for this. Then treat this query that you've just written as a subquery. 
- If any of these queries aren't possible, you may have made a bad choice in which data type you used. Check in with an instructor if you're stuck.

#### Updating Data
In SQL, you don't update rows, you update tables. In each of the following, you'll have to select the subset of the table you want to update using one or more `where` clauses. Use a single query to do the following.
- [ ] `scripts/updating/correctCase.sql`: You may have notced, some students are from `Tokyo` and others are from `tokyo`. Update all the students from `tokyo` so that they're from `Tokyo`. 
- [ ] `scripts/updating/correctdate_of_birth.sql`:It looks like there's another error in our data: some students have a date_of_birth exactly 100 years before their real date_of_birth. Find out which students these are and fix them. You can assume that no students are actually > 100 years old. 

#### Deleting Data
You may or may not have noticed one student, `Anakin Skywalker`. Contrary to what you might think, the Dark Lord did *not* attend Code Chrysalis. 
- [ ] `scripts/deleting/lastJedi.sql`: Delete `Anakin Skywalker` from the `students` table. 

#### Constraints
- If you've completed the basic requirements above, you now know about 80% of what you're likely to come across while querying data in databases. If you play music, what you've just done now is learn the database equivalent of C, F, G and F-minor chords. We're now going to look at schema design, which is how to set up and organise your tables.
- [ ] Read the first two paragraphs of [the Postgres docs on constraints](https://www.postgresql.org/docs/current/static/ddl-constraints.html).
- Constraints are limits we place on tables and columns in your database to prevent bad data from being inserted.
- Generally, constraints are added at the time a table is created, but we can also add them after that, provided the data in the table doesn't already break the constraint you're trying to create. If you're curious, look up this [brief tutorial on altering tables](http://www.postgresqltutorial.com/postgresql-alter-table/)--but don't worry if you're rushed, we'll get to this later in this sprint.
- In general, its good practice to create constraints in your database to keep in place rules that must never be changed. For example, it may be reasonable to create constraints to, for example, make sure a date_of_birth isn't in the future.

> ### Unique Constraints
- If you think back to when you created our `students` table, we added an auto-incrementing `id` column to have a unique ID for every student. What happens if we try to create a duplicate `id` ?
  - [ ] Try to insert another student into the `students` table with an `id` of 1. The rest of the information for the student can be anything you like.
  - Notice that it totally let you do that. That's lame! There's already a student with an `id` of 1! The whole point of an ID is that it should *always* be unique.
    - If it threw an error at you that contained the phrase `UNIQUE CONSTRAINT`, you're ahead of the game. You can read through the rest of the `constraints` section but you probably already know this.
- Look up [unique constraints](https://www.postgresql.org/docs/current/static/ddl-constraints.html) in the Postgres docs. 
- [ ] Destroy your students table (`drop table students`), and create it again, this time with a unique constraint on the ID column. Reinsert the student data into it using your `scripts/insertStudents.sql` script.
- [ ] Re-insert the student data using `scripts/insertStudents.sql`, like you did earlier
- [ ] Try to insert a student with a duplicate ID again. Verify that now, you get an error telling you that a student with that ID already exists. If you don't get an error, your constraint isn't set up correctly. If you did get an error, congrats! You've just created your first constraint!

> ### Not-Null Constraints
- [ ] Try to insert yet another student into the `students` table with an `id` explicitly set to `NULL`. 
  - Notice that it let you do that too. That's nuts! What's the point of an ID if some students can just *not* have one? 
  - `NULL` values are notorious pitfalls because unlike in javascript, `NULL` values cannot be computed against in SQL, so unique constraints do not apply to `NULL` values. 
  - Pro tip: In SQL, nothing is equal to `NULL`, including `NULL` itself. 
    - To check if something is `NULL` or not in your queries, instead of using `= NULL` or `!= NULL`, use `IS NULL` or `IS NOT NULL`.
- To help you avoid these problems, you can specify that any column not allow `NULL` values by using a not-null constraint. 
- [ ] Look up [not-null constraints](https://www.postgresql.org/docs/current/static/ddl-constraints.html) in the Postgres docs.
- [ ] Destroy your students table (`drop table students`), and create it again, this time with a unique constraint and a not-null constraint on the ID column. Reinsert the student data into it using your `scripts/insertStudents.sql` script.
- [ ] Try to insert a student with an explicitly `NULL` student ID again. Verify that you get an error. If you don't, your constraint isn't set up correctly.

> ### Primary Keys
- Very often, you'll have one particular column in a table (in this case, our `id` column in the `students` table) that is the primary identifier for rows in that table. Such an ID must never be null, and must always be unique. Most databases provide a `primary key` constraint for this purpose. A primary key constraint is just a unique constraint + a not-null constraint.
- [ ] Look up the [primary key](https://www.postgresql.org/docs/current/static/ddl-constraints.html) documentation in Postgres and verify this for yourself.
- Going forward, you should probably just use a `primary key` constraint, but its important for you to understand exactly what that is =)

#### Joins

> ### One-to-many

- At the very beginning we mentioned that relational databases are all about many tables of data that relate to each other. Well, we've only got one table for now, but fear not, we'll soon fix that!
- [ ] Look at `scripts/insertCheckins.sql`. 
    - The statements inside the file are written inside a transaction (line 1 and line 998). For now, all you need to know about transactions is that when you run the statements inside them, either all of the statements will work, or the whole thing will fail. It will *not* insert part of the data, fail, and leave that part inserted.
- [ ] Try to run `scripts/insertCheckins.sql` using `psql -d students -f scripts/insertCheckins.sql`. 
  - If it did work, move on to the next step
  - If it didn't work, inspect the error message for something like `Key (student_id)=(60) is not present in table "students"`. Delete the checkins for the students whose IDs it complains about from the script. This should be about 20 rows or fewer. Use your sublime shortcuts to save time!
  - Run the script again so it works. Remember, there's no harm in running the script many times until it works.
- [ ] Look up [Foreign Keys](https://www.postgresql.org/docs/current/static/ddl-constraints.html) in the Postgres docs to understand what line 5 of `scripts/insertCheckins.sql` is doing
- You should now have two tables, one with students, and one with checkins. A checkin is just a single time that a student walked into the Code Chrysalis classroom. 
- Notice a few things about our database:
    - Each student could have many checkins
    - Except for his or her ID, no student data is duplicated across the two tables
      - There is a *single source of truth* for every entity in our database. The students table is the only source of data on students, and the checkins table is the only source of data on checkins. 
    - For every checkin, the foreign-key constraint gives us a rock-solid guarantee that there will *always* be a student with that ID. If you try and delete a student with an ID that is used in the checkins table, the database will throw an error and stop you.
    - This is called Referential Integrity, and is the kickass feature of relational databases that makes them popular and reliable.
- Look up the syntax for an [inner join](https://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm), and complete the following scripts:
  - [ ] `scripts/selecting/allStudentAndCheckin.sql`:  select all the student data and checkin data for all students in a single query. 
  - [ ] `scripts/selecting/allCheckinInOn.sql`: select all student data and only `checked_in_at` from the checkins table about all students who checked in in June 2016.
    - [ ] Extra credit: Extend `scripts/selecting/allCheckinInOn.sql` to remove duplicate entries, so each student who checkin in in June 2016 is listed only once in your result, and `checked_in_at` is not shown at all.
      - Hint: look for `DISTINCT`
  - I recommend you read about outer, left and right joins in [this tutorial on joins](https://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm) (also mentioned in the `resources` section below) after this sprint, in your own time.

> ### Many-to-many

- The relationship we've just been looking at between students and checkins at is called a one-to-many relationship, because for each (one) student there are many checkins.
- There are really three kind of possible relationships:
    - one-to-one
    - one-to-many
    - many-to-many
- For a more thorough explanation, see this [generally applicable tutorial](https://support.airtable.com/hc/en-us/articles/218734758-A-beginner-s-guide-to-many-to-many-relationships) (also in the recommended reading)
- Let's look at creating a many-to-many relationship
    - [ ] Have a look at `scripts/insertProjects.sql` and make sure you understand it
    - [ ] create a `projects` table with some seed data using `psql -d students -f scripts/insertProjects.sql `
    - Each project has been worked on by many students. Students may have worked on many projects. This is a many-to-many relationship. 
    - The most common way to represent these in SQL is to have a separate *join table*
      - `scripts/studentsToProjects.sql` contains a list of `student_id`s and `project_id`s. Each row represents a single student working on a specific project.
    - [ ] In the `scripts/studentsToProjects.sql` script, add some SQL to create a join table named `students_to_projects`. The table should have:
      - [ ] `student_id` column with a foreign key constraint tied to the `students` table
      - [ ] `project_id` column with a foreign key constraint tied to the `projects` table
      - [ ] unique constraint on the combination of the two columns above, such that a student cannot be tied to a project more than once.
    - [ ] Edit the `scripts/studentsToProjects.sql` so that it populates the `students_to_projects` table using the given data.
    - If you run into trouble and see an error in the form `Key (student_id)=(60) is not present in table "students"`, simply delete that row from the `scripts/studentsToProjects.sql` file
    - Good work! You've just created your first join table!

- Let's write some queries with this new data!
  - [ ] `scripts/selecting/studentsOnProjectX.sql`: Select the `first_name` and `last_name` of all students who worked on the project with an `id` of 5.
  - [ ] `scripts/selecting/juneProjects.sql`: Select the `name` of all projects worked on by students who checked in in June 2016. There should be no duplicates in the list
  - [ ] `scripts/selecting/slackers.sql` (Extra Credit): Select the `first_name` and `last_name` of all students who did not work on any projects at all.
      - Hint: You will have to use a [subquery](https://stackoverflow.com/questions/19363481/select-rows-which-are-not-present-in-other-table). 

#### Schema Design

- Discuss and come up with a database schema for the following scenarios with your pair. These are deliberately vague to spark debate with your pair. 
- For each one, design a schema with a visual tool like http://dbdesigner.net/. As an example, the schema for this little project is visible below:
![CodeChrysalis-Database-1-schema](/assets/cc-db-1-schema.png?raw=true "CodeChrysalis Database Sprint I")
- [ ] A library. 
    - The library has many books
    - The library has many members
    - members can borrow any number of books
    - The library must keep a historical record of all borrowings
- [ ] Slack
  - Slack has many users who chat
  - Slack also has many channels
  - A channel can have many users
  - Users can also form their own private channels, to direct-message each other
- [ ] Extra Credit: ChrysalisBook - A social network for Code Chrysalis students
  - There are many students
  - Any student can send a friend request to any other student
  - The student who receives the friend request can accept it, reject it or block it
  - Blocked students cannot send friend requests any more, but should not know they are blocked

### Extra Credit

#### Indexes

- Indexes are a core component of relational databases. They dramatically speed up the time it takes for the database to find matching results and become more invaluable as tables get larger. 
- The most common index (and in many cases, the default) is a [B+ tree](https://en.wikipedia.org/wiki/B%2B_tree), which is a variation of the binary trees that you're already familiar with. This is, in a nutshell, a tree in which the leaf nodes are connected by a linked list. You can read more about this in the [overview of how databases actually work](http://coding-geek.com/how-databases-work/), in the `hardcore reading` section.
- The cost to adding an index is that inserting new data becomes slower, so its definitely not a good idea to add an index on all your columns.
- As a rule of thumb, you should add indexes only to columns that you plan on filtering on or joining on relatively frequently.
- Adding a unique constraint to a column will usually add an index to that column too, to make it faster for the database to verify uniqueness on every insertion.
- Adding indexes is of limited use when there is very little variation in the possible values of a column (e.g., boolean values).
- [ ] Discuss with your pair which columns in the students table and the checkins table would deserve indexes. 
- [ ] Look up the syntax for adding indexes in the [Postgres docs](https://www.postgresql.org/docs/9.5/static/sql-createindex.html) (search for the 'examples' section) and add indexes to the columns you think need them.
  - At a minimum, you should add indexes to the ID columns on each table. 
  - Use Google and Stackoverflow liberally. Indexing databases 'correctly' is a huge topic!
- The indexes that exist on a given table can be found in psql using `\d table_name`;

#### Transactions

- Transactions are integral to databases. You've already come across them in `scripts/insertProjects.sql`. 
- A transaction is a way of wrapping up several SQL queries such that we can batch their success together. 
- The classic example of when this is needed is performing bank transfers. When banks have to transfer money from one account to another, they must usually write two queries, one query to subtract the amount from one account, and another to add the amount to the account.
  - If an error, or a power outage occurred when one query was complete and the other was not, the results are catastrophic. Money simply *cannot* disappear like that if the bank is to stay in business. 
  - Wrapping queries inside a transaction causes the database to perform the queries within an iron-clad guarantee that either all of them will fail with *zero* side effects, or all of them will succeed. 
- It's generally good practice whenever writing multiple queries that depend on each other, to do them in a transaction.
- [ ] Complete [this short tutorial](https://www.tutorialspoint.com/postgresql/postgresql_transactions.htm) on transactions

#### Migrations

- Whenever we change the schema of a table, we do so within a migration. A migration is a set of queries that change the schema in some way, and alter the data to fit within the new schema. Migrations should *always* happen within a transaction.
- You may have noticed that in the `students` table, we repeat the names of each student's town of origin several times. This has already caused a few mistakes in the data that you very kindly fixed. A more permanent solution, however, would be to migrate the towns to their own table, and have each student reference the id of the town they originate from in the `towns` table.
  - Create your own `.sql` file and do the following within a transaction:
    - [ ] Create a new table for towns, with just an `id` column and a `name` column
    - [ ] Insert all the towns mentioned in the `students` table to the `towns` table.
    - [ ] Add a column named `town_id` to the students table
    - [ ] For each student, add his or her `town_id` to the `students` table
    - [ ] Drop the `town_of_origin` column from the students table
  - Did it? Congrats! You just created your first migration!
- If you've done the extra credit within this sprint feel free to move on to part II: building your first database-powered app!

## Resources

### Essentials for reference  

- [Postgres documentation](https://www.postgresql.org/docs/9.6/static/index.html)
- [Simplified postgres tutorials](http://www.postgresqltutorial.com/)

### Extra (recommended) reading and watching

- [Comparison of relational databases](https://www.digitalocean.com/community/tutorials/sqlite-vs-mysql-vs-postgresql-a-comparison-of-relational-database-management-systems)
- [How auto-incrementing integers can fail](https://www.youtube.com/watch?v=vA0Rl6Ne5C8&t=158s) (AKA, 'how Gangnam Style "broke the internet"')
- [Postgres overview of constraints](https://www.postgresql.org/docs/current/static/ddl-constraints.html)
- [Tutorial on joins](https://www.tutorialspoint.com/postgresql/postgresql_using_joins.htm)
- [Generally-applicable tutorial on relationships](https://support.airtable.com/hc/en-us/articles/218734758-A-beginner-s-guide-to-many-to-many-relationships)

### Hardcore reading
- [Overview of how databases actually work](http://coding-geek.com/how-databases-work/)
- [UCBerkeley CS186 Introduction to Database Systems lecture](https://www.youtube.com/watch?v=G58q_y0vRpo&list=PL-XXv-cvA_iBVK2QzAV-R7NMA1ZkaiR2y)

## Contributing

See a problem? Can something be done better? [Contribute to our curriculum](mailto:hello@codechrysalis.io)!
