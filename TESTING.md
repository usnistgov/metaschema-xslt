# Testing metaschema-xslt

An important secondary goal of this project is that its processes should be *validable*, which implies transparent and auditable testing processes.

Testing in this context is very broad, including application-level testing of functionalities; testing of behaviors against documented specifications (both in this repository and elsewhere); and lower-level functional tests.

Any directory (folder) may also have its own `TESTING.md` file with information and instructions, in addition to its README file and any other documentation.

Like each of these, this document constitutes work in progress, and contributors are invited to offer edits, corrections, clarifications and updates.

## Linting and syntax checks

Currently we are not running formal syntax checks over XSLT or XProc, or imposing any kind of rigorous syntax requirements. Developers should use good judgment and write the most legible code possible, commenting where useful.

If code legibility and consistency become an issue, we can consider more stringent rules along with automation to support them.

## *Test Everything*

TBD - a TEST EVERYTHING subroutine.

## Testing technologies

[XSpec](https://github.com/xspec/xspec/) is the preferred testing harness for XSLT in this initiative. XSpec test suites can be either self-contained, or can reference testing artifacts maintained externally. The repository contains XSpec examples demonstrating a range of usage patterns that can be applied.

Script-driven testing should rely on the same dependencies as the runtimes they test, as documented.

## Global functional testing

`src/testing` includes resources for global-level testing. This folder or its contents should not to be moved or edited without fully testing *all* test runtimes, as resources inside this directory are sometimes dependencies.

Do not commit anything to this folder that you do not wish to stay there indefinitely; instead, copy into a sibling (temporary) directory that can be deleted freely.

## Application component-level (functional) unit testing

`src/**/testing` includes (functional) testing for utilities supported in a given folder.

When developing applications, feel free to add and modify any `testing` folder or its contents within the scope of work.

Unit tests are expected to run successfully when committed - both completing, and passing all applicable tests. Keep in mind that most testing frameworks support marking tests as not applicable (in XSpec, [flag a scenario or `expect` as `pending`](https://github.com/xspec/xspec/wiki/Focusing-Your-Efforts#marking-scenario-or-expectation-as-pending)), so it is possible to write tests ahead of an implementation and still pass.

### Test-driven development

While this project began as an experimental proof of concept, it now aims for higher levels of assurance and confidence than are necessary or appropriate for applications intended only to produce findings regarding feasibility and levels of effort. Accordingly, our development approach has shifted from rapid prototyping to a more explicit and traceable process of design, specification and implementation.

If you touch a particular unit of code that doesn't have tests, write tests for it in the same PR as your change. If you touch a particular unit of code that has tests, update or augment them to test the change you are making. In general, push the tests ahead of the code, not the other way around, aligning the tests with specifications first.

This expenditure of effort prevents bugs (easier than repairing them) and guards against regression, opening opportunities to do more interesting things. So it is not so much "extra" as an investment in future stability and sustainability.

## Test applications

`examples` (tbd) includes top-level independent metaschema examples made for testing and demonstration.

This location is available for lightweight and <q>toy</q> applications, useful for evaluation, demonstration and learning. Fully built-out applications of Metaschema can also call this repository in as a submodule (like [OSCAL](https://github.com/usnistgov/oscal)).

## Testing under CI/CD

Also tbd

Links of interest: 

- https://github.com/nkutsche/xspec-maven-plugin
- https://github.com/galtm/xslt-accumulator-tools/blob/db1c6b2a/pom.xml#L68
