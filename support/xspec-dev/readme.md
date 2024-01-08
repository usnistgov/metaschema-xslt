# XSpec Development

The intention being to merge all this in to ../xspec at some point tbd.

The initiative focuses on two kinds of assets:

- XProc pipelines to orchestrate XSpec evaluation
- Scripts to initiate XProc pipelines

These should be either useful directly, or useful if copied and adjusted, i.e. as templates.

Additionally, this project has new functionality for XSpec provided by an updated **XSpec Report HTML** transformation.

## Pipelines

Pipelines are currently implemented using XProc 1.0 to be run under XML Calabash.

XProc 3.0 is planned for a later date.

### Scripts calling XProc

XProc pipelines demonstrate running XSpec using the current distribution.

In the XSpec distribution, the [Saxon XSLT Harness pipeline](../xspec/src/harnesses/saxon/saxon-xslt-harness.xproc) can be called directly to process a single XSpec.

A [pipeline calling this XProc step](xspec-single-xspec2xslt.xpl) is provided here with some configuration, saving analysis and effort.

However a new HTML report format is also offered here, with support for production of XSpec reports now in *multiple formats* - XML, HTML and plain text, and operating over XSpec resources (files) in batch as well as singly.

To use these, run or emulate the [the script provided](mvn-xproc-xspec-html.sh) to run [the XProc](xspec-single.xpl), with ports as follows:

- (input) `xspec` - the XSpec file input
- (output) `html-report` - an HTML report from evaluating the XSpec

For running XSpecs in batch, the [pipeline](xspec-batch.xpl) `xspec-batch.xpl`is offered.

- (input) `batch` - a sequence of XSpec file inputs
- (output) `xspec-results` - aggregated results from evaluating all XSpecs (XML)
- (output) `summary` - an XML summary of the aggregated XSpec results
- (output) `html-report` - an HTML report (all XSpecs)
- (output) `determination` - a shorter plain-text summary showing findings

Along with notice of which tests are run, the `determination` port gives a line of plain text with a determination of `SUCCESS` (when no failures are reported) or `FAILURE` (when any failures are reported).

An example is given in the `testing` directory at [testing/xspec-test-batch.xpl](testing/xspec-test-batch.xpl)`

### XProc alone

These pipelines can be called directly (providing XSpecs on source ports `xspec` or `batch`), so to combine `1.xspec` and `2.xspec` into a single runtime where `xproc` calls the XProc processor:

```bash
xproc path/to/xspec-batch.xpl -ibatch=1.xspec -ibatch=2.xspec -oxspec-results=/dev/null -osummary=/dev/null
```

writes the `determination` for the combined XSpecs to the console (dropping other outputs).

### Example for study

Support for a batch capability is also demonstrated in the `test` directory, which contains a script [testing/mvn-run-xspec-test-batch.sh](testing/mvn-run-xspec-test-batch.sh) that initiates the test pipeline `testing/xspec-test-batch.xpl` using XML Calabash under Maven.

This demonstrates how to hard-wire an XProc for a set of XSpecs to be evaluated.

## HTML Production

In order to work around limitations in the current XSpec HTML production (details with respect to its deployment under XProc 1.0), a [new HTML production XSLT](xspec-mx-html-report.xsl) is provided here, for use either for standalone XSpec reporting, or for reporting results of batch processes.

[This XSLT ](xspec-mx-html-report.xsl) produces standalone HTML including embedded CSS and some lightweight Javascript supporting navigation features.

A runtime parameter can be set on this transformation, `theme`, customizing color schemes. `theme=clean` (the default) produces a medium-contrast color-neutral format; `theme=uswds` uses colors for emphasis from the USWDS color scheme; `theme=classic` uses colors drawn from the good-old XSpec HTML; and `theme=toybox` provides a more extravagant scheme.

New themes can be added in a new XSLT that imports this one, by copying and modifying an appropriate template. Such an importing XSLT can also modify any other feature of the XSLT.

### Theming HTML from XProc

The XProc files support a runtime option, `html-theme`, which exposes control of the theme setting to the user or script.

