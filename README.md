# Thesis Project: Formic Learning (CS310)
Undergraduate dissertation project surmising the development of a feature-rich social VLE to promote student performance in schools. For more information, refer to the [system specification](http://www.alexmacpherson.uk/specification.pdf "View System Specification") or [progress report](http://www.alexmacpherson.uk/progress-report.pdf "View Progress Report"), or [visit my website](http://www.alexmacpherson.uk/ "Portfolio").

## Dependencies
The system was developed using the following, so support for previous versions cannot be guaranteed:
* **Ruby v2.4+**
* **Rails v5.0.0+**
* **SQLite v3.15.0+** - development/testing environment only
* **PostgreSQL v9.5.4+** - production environment only

All further dependencies are managed by the system's Gemfile, detailed below.

## Live Build
A live build with the latest stable version can be found on Heroku at [https://formic.herokuapp.com/](https://formic.herokuapp.com/ "View Live Build on Heroku")

## Configuring the System
If you wish to download and tinker with the most recent build, simply clone this repository. With this done, you must first ensure all system dependencies and required modules are installed and updated using:
> bundle install

**Note:** You may be prompted to update some existing dependencies prior to running *bundle install* - this can be done using:
> bundle update

You should then be able to run *bundle install* without issue. With dependencies handled, the database must then be initialised prior to running the system. This can be done from the project root using:
> rails db:migrate

Once migrated, the database can be optionally seeded with dummy data using:
> rails db:seed

## Running the System
Once configured, I recommend using the **RubyMine IDE** to view and edit this code, as it supports a built-in development environment, which can be started by pressing
> Shift+F10

If you do not have **RubyMine**, the system can be run by manually starting a **Puma** server from the project root. On Linux, this is done using:
> rails server

To run a server on Windows, use:
> bin\rails server

## Running the Test Suite
A collection of unit tests has been provided to ensure all modules within the system function as intended. This can be run from the project root using:
> rails test

The output, assuming all test cases succeed, should look something like this, where *x* is the number of tests run and *y* is the number of assertions made by these tests:
> *x* tests, *y* assertions, 0 failures, 0 errors, 0 skips

If *failures* or *errors* exceed 0, an error is present within the system and should be re-cloned from the repository before running.

**Note:** Some tests may be skipped, due to how the test suite runs - this can be ignored.
