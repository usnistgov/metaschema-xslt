# Metaschema Documentation Production

Metaschema in, documentation out.

## Scripts

The scripts are written in `bash` and rely on [Apache Maven](https://maven.apache.org/) for Java dependency management.

### `mvn-schemadocs-html-xpl.sh`

Produces a set of interlinked HTML files documenting the models (XML and object/JSON) for a metaschema, in a subdirectory.

```
> ./mvn-schemadocs-html-xpl.sh a-metaschema.xml metaschemaA docs METASCHEMA_XML SCHEMA_NAME OUTPUT_DIR
```

where

- the script `./mvn-schemadocs-html-xpl.sh` is available (in the directory or on the system path)
- `a-metaschema.xml` is a metaschema (top-level module) as a relative path (file URI)
- `metaschemaA` is the label to use in the documentation produced (file names and links)
- `docs` is a *relative* path (URI syntax) for writing serialized outputs (HTML files)

Assuming the incoming metaschema is valid, correct, and correctly linked (imports resolved), HTML file outputs are written to the indicated subdirectory.

The result file names are defined in the underlying XProc, `METASCHEMA-HTML-DOCS.xpl`.

### `mvn-schemadocs-debug-xpl.sh`

This script invokes the base 'traceable' XProc, `METASCHEMA-DOCS-TRACE.xpl`. By managing exposed ports (now binding to `/dev/null` for intermediate results and file paths for HTML results) through this script, intermediate and final outputs can be examined and assessed. Use for debugging.

## Pipelines

### `METASCHEMA-HTML-DOCS.xpl`

This 'wrapper' pipeline includes the base pipeline `METASCHEMA-DOCS-TRACE.xpl` as a defined step, and invokes it with metaschema input while configuring its runtime. Consequently it is much simpler to run.

Use this pipeline with metaschema input when you want HTML file results written to a specific location by the XProc.

### `METASCHEMA-DOCS-TRACE.xpl`

The base pipeline called by the HTML rendering pipeline, exposing ports for debugging,

TO DO: extend this to support a new pipeline optimizing for Hugo - means showing new ports exposing HTML results before they are wrapped. This can replace the current Hugo-writing pipeline.

Text
