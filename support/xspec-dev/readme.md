# XSpec Development

The intention being to merge all this in to ../xspec at some point tbd.

The initiative focuses on two kinds of assets:

- XProc pipelines to orchestrate XSpec evaluation
- Scripts to initiate XProc pipelines

These should be either useful directly, or useful if copied and adjusted, i.e. as templates.

## Pipelines

XProc pipelines demonstrate running XSpec using the current distribution.

In the XSpec distribution, the [Saxon XSLT Harness pipeline](../xspec/src/harnesses/saxon/saxon-xslt-harness.xproc) can be called directly for processing a single XSpec, as shown in [the script](mvn-run-xspec-html.sh).

For running XSpecs in batch, the [pipeline](xspec-batch.xpl) `xspec-batch.xpl`is offered. It produces a summary report for a set of XSpecs, in XML and as a single line of plain text with a determination of `SUCCESS` (when no failures are reported) or `FAILURE` (when any failures are reported).

This pipeline can be called directly (providing XSpecs at the source port `batch`), or it can be used as a step in a calling pipeline, which configures its sources and ports.

See an example of this in the `testing` directory at [testing/xspec-test-batch.xpl](testing/xspec-test-batch.xpl)`

Note* until we have a need for HTML results, the current capability produces only **XML** and **plain text** results for a batch of XSpecs. HTML results from evaluating a batch are not planned currently.

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

The script will create an HTML file named after the XSpec source file, in a directory named `xspec`.

#### Buglet repair

In the [XSpec distribution XProc harness library file file](../xspec/src/harnesses/harness-lib.xpl), at line 301 in `//p:xslt[@name='format-report']` provide:

```
<p:with-param name="inline-css" select="'true'"/>
```

Otherwise the results have no CSS.

Cf https://github.com/xspec/xspec/issues/1832

### Applying and evaluating a batch of XSpecs together

Scripting the 'batch' capability is demonstrated in the test directory, which contains a script [testing/mvn-run-xspec-test-batch.sh](testing/mvn-run-xspec-test-batch.sh) that initiates the test pipeline `testing/xspec-test-batch.xpl` using XML Calabash under Maven. This script can be copied and adjusted to run from anywhere invoking such a pipeline.

Currently these pipelines are hard-wired for the sets of XSpecs to be processed. But either `xspec-batch.xpl` or an importing pipeline can also bind the XSpec sources dynamically, to the `batch` input port.



