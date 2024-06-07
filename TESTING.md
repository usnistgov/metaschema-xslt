# Testing metaschema-xslt

An important secondary goal of this project is that its processes should be *validable*, which implies transparent and auditable testing processes.

Testing in this context is very broad, including application-level testing of functionalities; testing of behaviors against documented specifications (both in this repository and elsewhere); and lower-level functional tests.

Any directory (folder) may also have its own `TESTING.md` file with information and instructions, in addition to its `README.md` file and any other documentation.

Like each of these, this document constitutes work in progress, and contributors are invited to offer edits, corrections, clarifications and updates.

## Linting and syntax checks

Currently we are not running formal syntax checks over XSLT or XProc, or imposing any kind of rigorous syntax requirements. Developers should use good judgment and write the most legible code possible, commenting where useful.

If code legibility and consistency become an issue, we can consider more stringent rules along with automation to support them.

## *Test Everything*

With `make`, `bash`, and Maven installed, `make test -C src` runs all the tests (tested under Ubuntu) in the `src` directory relative to the current working directory.

The top-level Makefile in this directory collects commands from Makefiles distributed throughout the repo.

You can also use `make` in isolation from the top-level testing, to focus on your application. As a developer you only need to worry about the folder containing your application, binding test tasks to the targets 'smoke-test', 'spec-test' and 'unit-test' as need be.

Model such a Makefile, which calls XSpec for testing XSLT, after the example `src/schema-gen/InspectorXSLT/Makefile`.

Experiment using different Makefile targets as configured in the various directories.

For any directory, `make` with no arguments should offer tips.

### Testing technologies

[XSpec](https://github.com/xspec/xspec/) is the preferred testing harness for XSLT in this initiative. XSpec test suites can be either self-contained, or can reference testing artifacts maintained externally. The repository contains XSpec examples demonstrating a range of usage patterns that can be applied.

Script-driven testing should rely on the same dependencies as the runtimes they test, as documented.

### Extensions to XSpec

Currently we are emulating and re-engineering some specific XSpec capabilities in the [support/xspec-dev](support/xspec-dev) folder.

These efforts are focused on producing and refining XSpec runtimes for various use cases and scenarios with specialized requirements faced by this project, such as arbitrary batching and iXML support. Tools we develop here are released under the same terms as Metaschema-XSLT (as open-source software).

## Test-driven development

Almost all testing in this repository falls into the category of either XSLT transformations, or runtimes that embed transformations.

### The approach

While this project began as an experimental proof of concept, it now aims for higher levels of assurance and confidence than are necessary or appropriate for applications intended only to produce findings regarding feasibility and levels of effort. Accordingly, our development approach has shifted from rapid prototyping to a more explicit and traceable process of design, specification and implementation.

If you touch a particular unit of code that doesn't have tests, write tests for it in the same PR as your change. If you touch a particular unit of code that has tests, update or augment them to test the change you are making. In general, push the tests ahead of the code, not the other way around, aligning the tests with [the Metaschema specification(s)](https://pages.nist.gov/metaschema/specification/) first.

This expenditure of effort prevents bugs (easier than repairing them) and guards against regression, opening opportunities to do more interesting things. So it is not so much "extra" as an investment in future stability and sustainability.

The approach can require changing some habits. Looking for inspiration and "striking while the iron is hot" no longer works as well (since the forge must be warmed up first). Sometimes immediate gratification has to be set aside. Yet the payoffs are substantial, and come early.

## Global functional testing

`src/testing` includes resources for global-level testing. This folder or its contents should not to be moved or edited without fully testing *all* test runtimes, as resources inside this directory are sometimes dependencies.

Do not commit anything to this folder that you do not wish to stay there indefinitely; instead, copy into a sibling (temporary) directory that can be deleted freely.

## Application component-level (functional) unit testing

`src/**/testing` includes (functional) testing for utilities supported in a given folder.

When developing applications, feel free to add and modify any `testing` folder or its contents within the scope of work.

Unit tests are expected to run successfully when committed - both completing, and passing all applicable tests. Keep in mind that most testing frameworks support marking tests as not applicable (in XSpec, [flag a scenario or `expect` as `pending`](https://github.com/xspec/xspec/wiki/Focusing-Your-Efforts#marking-scenario-or-expectation-as-pending)), so it is possible to write tests ahead of an implementation and still pass.

## Testing under CI/CD

Github Actions is configured in the file [.github/workflows/test.yml](.github/workflows/test.yml)

Note that since this logic enters the `Makefile` logic from the top, make executes the specified subroutines recursively.

Accordingly, adding a test subroutine to a `spec-tests` Makefile configuration anywhere in the repository has the effect of enabling it (turning it on) for CI/CD as well.


