# XSpec Development

The intention being to merge all this in to ../xspec at some point tbd.

The initiative focuses on two kinds of assets:

- XProc pipelines to orchestrate XSpec evaluation
- Scripts to initiate XProc pipelines

These should be either useful directly, or useful if copied and adjusted, i.e. as templates.

## Pipelines

XProc pipelines demonstrate running XSpec using the current distribution.

In the XSpec distribution, the [Saxon XSLT Harness pipeline](../xspec/src/harnesses/saxon/saxon-xslt-harness.xproc) can be called directly to process a single XSpec.

But it is easier to use [the script provided](mvn-run-xspec-html.sh) to run [the XProc](xspec-single.xpl), with ports as follows:

- (input) `xspec` - the XSpec file input
- (output) `html-report` - an HTML report from evaluating the XSpec
- (output) `summary` - an XML summary of the XSpec report
- (output) `determination` - one line, showing findings

For running XSpecs in batch, the [pipeline](xspec-batch.xpl) `xspec-batch.xpl`is offered.

- (input) `batch` - a sequence of XSpec file inputs
- (output) `xspec-results` - aggregated results from evaluating all XSpecs (XML)
- (output) `summary` - an XML summary of the XSpec results
- (output) `determination` - one line, showing findings

The `determination` port gives a single line of plain text with a determination of `SUCCESS` (when no failures are reported) or `FAILURE` (when any failures are reported).

either can be used as a step in a calling pipeline, which configures its sources and ports.

An example is given in the `testing` directory at [testing/xspec-test-batch.xpl](testing/xspec-test-batch.xpl)`

HTML results from evaluating a batch are not planned currently, but could easily added.

These pipelines can be called directly (providing XSpecs on source ports `xspec` or `batch`), so to combine `1.xspec` and `2.xspec` into a single runtime where `xproc` calls the XProc processor:

```bash
xproc path/to/xspec-batch.xpl -ibatch=1.xspec -ibatch=2.xspec -oxspec-results=/dev/null -osummary=/dev/null
```

writes the `determination` for the combined XSpecs to the console (dropping other outputs).

## Scripts

`bash` scripts show how to run the pipelines under Maven, using XML Calabash.

They have been tested under WSL/Ubuntu.

### Producing an HTML report for a single XSpec

Emulating the functionality provided in an editor, run XSpec test suites one at a time using this script:

```
$ ./mvn-run-xspec-html.sh [yourxspec.xspec]
```

This should run from anywhere, so for example test it from the testing directory on an XSpec test set located in place:

```
testing$ ../mvn-run-xspec-html.sh xspec-basic.xspec
```

The script will create an HTML file named after the XSpec source file, in a directory named `xspec`. It also echoes a one-line determination to the console or `STDOUT`.

### Applying and evaluating a batch of XSpecs together

Support for a batch capability is demonstrated in the test directory, which contains a script [testing/mvn-run-xspec-test-batch.sh](testing/mvn-run-xspec-test-batch.sh) that initiates the test pipeline `testing/xspec-test-batch.xpl` using XML Calabash under Maven.

This demonstrates how to hard-wire an XProc for a set of XSpecs to be evaluated.

## HTML Production

In order to work around limitations in the current XSpec HTML production (details with respect to its deployment under XProc 1.0), a [new HTML production XSLT](xspec-mx-html-report.xsl) is provided here, for use either for standalone XSpec reporting, or for reporting results of batch processes.

[This XSLT ](xspec-mx-html-report.xsl) produces standalone HTML including embedded CSS and some lightweight Javascript supporting navigation features.

A runtime parameter can be set on this transformation, `theme`, customizing color schemes. `theme=clean` (the default) produces a medium-contrast color-neutral format; `theme=uswds` uses colors for emphasis from the USWDS color scheme; `theme=classic` uses colors drawn from the good-old XSpec HTML; and `theme=toybox` provides a more extravagant scheme.

New themes can be added in a new XSLT that imports this one, by copying and modifying an appropriate template. Such an importing XSLT can also modify any other feature of the XSLT.
