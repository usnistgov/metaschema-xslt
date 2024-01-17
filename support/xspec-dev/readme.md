# XSpec Development

The initiative focuses on two kinds of assets:

- XProc pipelines to orchestrate XSpec evaluation
- Scripts to initiate XProc pipelines

These should be either useful directly, or useful if copied and adjusted, i.e. as templates.

Additionally, this project has new functionality for XSpec provided by an updated **XSpec Report HTML** transformation.

## Pipelines

The pipelines in this project depend on prior art in the XSpec repository. Pipelines are currently implemented using XProc 1.0 to be run under XML Calabash.

XProc 3.0 is planned for a later date.

Three pipelines are provided at the top level. All have dependencies on XSpec [in the XSpec distribution included as a repo submodule](../xspec/src/harnesses/). Rather than forking from XSpec, the aim is to merge these capabilities back in.

`xspec-single-report.xpl` - processes an XSPec input file by applying XSpec execution using the XSpec XProc test harness, then processing its native report to make an HTML page.

The HTML XSLT was developed to mitigate configuration problems using the project-standard presentation stylesheet (as noted below). It is designed to be functional but lightweight, robust and cleanly extensible for a range of use cases or deployments.

*Limitation*: At present, the presentation stylesheet meets these goals with respect to XSpec testing XSLT - not (yet) testing XQuery, Schematron or other runtimes to which XSpec might be applied.

`xspec-batch-report.xpl` - provides the same set of operations, except instead of a single XSpec (file instance), it can accept any number of XSpec files designated as inputs (either wired in or via XProc port bindings). Results from these tests are *aggregated* into a single report.

This pipeline also demonstrates how reports can be further processed to provide other outputs such as XML summaries (for batches) and simple plain-text summaries.

Additionally, another XProc is included for future diagnostics:

`xspec-single-xspec-repo-report.xpl` - calls the XSpec project XProc (pipeline), delivering an HTML file using the 'regular' XSLT in the XSpec distribution. *Note*: YMMV especially as it regards CSS setup in HTML file results.

This pipeline is essentially a minimal, functionally standalone wrapper around XSpec-native capabilities, made to expose the 'pain points' in using the current resources (which were originally authored and tested over ten years ago). For good results using XProc 1.0 under XML Calabash (itself no longer cutting-edge technology), certain modifications must be made in the XSpec repository libraries:

* Serialization needs to use latest (HTML5) serialization options to deal with character handling, rather than the current 'double reverse' character escaping of markup characters into [the Unicode Private Use Areas (PUA)](https://en.wikipedia.org/wiki/Private_Use_Areas) -- thus effectively requiring a character mapping back, which is not well supported under XProc 1.0.
* CSS handling/deployment needs to be improved or exposed such that generated HTML files have their CSS available.

## How to batch XSpec - a 'mini' demo

A demonstration of how to use the **batch report** XProc as a step in a calling XProc is provided. The advantage of such a 'wrapper' XProc is that it can encapsulate logic for an even simpler interface or runtime for the specific use case (whether running from the command line, under CI/CD, in an IDE etc). Both the batch (the XSpecs to be run) and what to do with the test results can thus be hard-wired, or provided with customized interface controls.

The ['test batch' XProc](testing/xspec-test-batch.xpl) in this folder can be copied anywhere and adjusted per case, restoring its import link, pointing it to local XSpec file sources, and setting up ports or `p:store` (file save) options as wanted. It then runs in place to execute, as a set, all the XSpecs it points to.

Summary: how to use -

- Copy the XPL (and batch script if wanted) to a convenient location
- Rename and comment both of these for local use, rewiring their configuration, comments, and help messaging according to your design
- In editing the XProc, consider adding or removing any ports or whether to expose output ports vs write file outputs (`p:store`)
- Run the XProc standalone using the script or otherwise

## Scripts calling XProc

The `bash` [script](mvn-xproc-xspec-html.sh) shows how a script can invoke XML Calabash to execute one of these pipelines.

How a particular XProc is used depends on the ports defined in the XProc. XML Calabash provides syntax and interfaces for those ports. Accordingly, a script or command-line invocation typically has to set, for these XProcs:

- input port `xspec` is where XSpec inputs are configured - these must be files accessible on the system
- output port `xspec-report` or `xspec-results`, if any, shows XSpec runtime outputs, with no further processing, as a single (XML) report
- output port `html-report` shows the results, rendered in HTML for viewing in a web browser
- output `summary` shows the XML report reduced to a simple summary form
- output `determination` shows a plain text result for the entire run,with the summary results

Additionally, a runtime option `theme` supports changing the HTML page rendition settings (CSS), including its color palette, as described below.

## XProc alone

A script can be nice for repeated use, but for testing / one-time use, the same commands or their equivalents can be used to run the pipelines directly in XML Calabash, binding the input XSpecs to the `xspec` input port. Assuming `xml-calabash.sh` executes XML Calabash, this syntax will serve to combine execution of `testing_1.xspec` and `testing_2.xspec` into a single runtime:

```bash
./xml-calabash.sh path/to/xspec-batch.xpl -ixspec=testing_1.xspec -ixspec=testing_2.xspec -oxspec-report=/dev/null -ohtml-report=/dev/null -osummary=/dev/null
```

Since the port `determination` is unnamed, its outputs are echoed to the console. Bindings to `dev/null` have the effect of silencing the other output ports. (They might otherwise be directed to file outputs for inspection.)

See XML Calabash docs for more info on its flags and switches.

## Enhanced HTML Production

In order to work around limitations in the current XSpec HTML production (details with respect to its deployment under XProc 1.0), a [new HTML production XSLT](xspec-mx-html-report.xsl) is provided here, for use either for standalone XSpec reporting, or for reporting results from several XSpecs in aggregate ("batch").

[This XSLT ](xspec-mx-html-report.xsl) produces standalone HTML including embedded CSS and some lightweight Javascript supporting navigation features.


### Theming HTML from XProc

The XProc files support a runtime option, `theme`, which also exposes control of the theme setting (in the HTML and CSS). This takes the form of an HTML `class` value on the `body` element, along with CSS to be applied to the page on the basis of that setting.

- `theme=clean` (the default) produces a medium-contrast color-neutral format
- `theme=uswds` uses colors for emphasis from the USWDS color scheme
- `theme=classic` uses colors drawn from the good-old XSpec HTML
- `theme=toybox` provides a more extravagant scheme.

New themes can be added in the XSLT or in a new "shell" XSLT importing it, by copying and modifying an appropriate template to match the new theme and give it style. Such an importing XSLT can also modify any other feature of the HTML page result.
