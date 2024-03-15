# Testing

This work in support of XSpec is in need of more rigorous testing.

Interactive testing has been performed with all scripts.

But requirements and specifications are loose, having been driven up to this point by functional requirements faced by the metaschema-xslt project - for a flexible, performant runtime that works independently of licensed software, with developer-friendly controls from the command line and inside CI/CD. Specifically, this means a number of issues, including testing, that bear on full integration back into XSpec have been set aside for the present.

Some experience in application will also be helpful in prioritizing the testing work to be done.

Meanwhile, some interesting questions, both practical and theoretical, are posed by the need to test these capabilities, especially outside particular deployments.

For which capabilities can we write XSpec or meaningfully test and confirm (expose and document) in other ways, including

  - `xsl:message` behavior including terminate="yes"
  - side effects such as `xsl:result-document`?
  - Runtime parameter semantics
  - Exception handling

(XSpec especially with `@run-as='external'` is able to provide support for much of this, but specific means are tbd.)

Contributor at-galtm also notes that message handling code in the [xslt3-functions project repository](https://github.com/usnistgov/xslt3-functions) is configurable to emit processing instructions (instead of or with `xsl:message`) as message proxies, making this functionality testable.

Additionally, plenty of 'obvious' tasks remain to be done, including

  - Addressing functional gaps e.g. Schematron, `x:label`, `x:pending`
  - Scope/coverage analysis
  - XSpec for "easy" stuff, including HTML rendering
