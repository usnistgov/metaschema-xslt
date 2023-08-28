# Testing metaschema-xslt

An important secondary goal of this project is that its processes should be *validable*, which implies transparent and auditable testing processes.

Testing in this context is very broad, including application-level testing of functionalities; testing of behaviors against documented specifications (both in this repository and elsewhere); and lower-level functional tests.

Any directory (folder) may also have its own `TESTING.md` file with information and instructions, in addition to its README file and any other documentation.

Like each of these, this document constitutes work in progress, and contributors are invited offer edits, corrections, clarifications and updates.

## Linting and syntax checks

Currently we are not running formal syntax checks over XSLT or XProc, or imposing any kind of rigorous syntax requirements. Developers should use good judgment and write the most legible code possible, commenting where useful.

If code legibility and consistency become an issue, we can consider more stringent rules along with automation to support them.

## *Test Everything*

TBD - a TEST EVERYTHING subroutine.

## Global functional testing

`src/testing` includes resources for global-level testing. This folder or its contents should not to be moved or edited without fully testing *all* test runtimes, as resources inside this directory are sometimes dependencies.

Do not commit anything to this folder that you do not wish to stay there indefinitely; instead, copy into a sibling (temporary) directory that can be deleted freely.

## Application component-level (functional) unit testing

`src/**/testing` include (functional) testing for utilities supported in a given folder.

When developing applications, feel free to add and modify any `testing` folder or its contents within the scope of work.

Unit tests are expected to run successfully when committed.

## Test applications

`examples` (tbd) includes top-level independent metaschema examples made for testing and demonstration.

This location is available for lightweight and 'toy' applications, useful for demonstrations and learning. Fully built-out applications of Metaschema can also call this repository in as a submodule (like [OSCAL](https://github.com/usnistgov/oscal))

## Testing under CI/CD

Also tbd
