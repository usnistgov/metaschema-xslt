
Miscellaneous resources supporting validation of Metaschema and related formats.

Of particular interest:

- `metaschema-composition-check.sch` - some rules checking of a Metaschema module in reference to its composed rendition

- METASCHEMA-SCHXSLT-VALIDATE.xpl

  XProc applies the composition check to a metaschema (Metaschema instance) and reports results in minified plain text.

  Invokes Schxslt

- METASCHEMA-VALIDATE.xpl

  *Should* do the same as above using the Skeleton implementation of Schematron (via XM Calabash), but not yet working or not yet under oXygen harness.

  Note that the parameter `allow-foreign` is set to true. Also note the problem is in file traversals - this validator might run from the CL?


