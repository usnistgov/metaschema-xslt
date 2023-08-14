# Metaschema Documentation Production

Metaschema in, documentation out.

## Scripts

The scripts are written in `bash` and rely on [Apache Maven](https://maven.apache.org/) for Java dependency management.

### `mvn-schemadocs-testsite-xpl.sh`

Produces a set of interlinked HTML files documenting the models (XML and object/JSON) for a metaschema, in a subdirectory.

Arguments are provided to the script as `METASCHEMA_XML OUTPUT_DIR SCHEMA_NAME`, for example

```
> ./mvn-schemadocs-testsite-xpl.sh a-metaschema.xml docs metaschemaA
```

where

- the script `./mvn-schemadocs-testsite-xpl.sh` is available (in the directory or on the system path)
- `a-metaschema.xml` is a metaschema (top-level module) as a relative path (file URI)
- `docs` is a *relative* path (URI syntax) for writing serialized outputs (HTML files)
- `metaschemaA` is the label to use in the documentation produced (file names and links)

Assuming the incoming metaschema is valid, correct, and correctly linked (imports resolved), HTML file outputs are written to the indicated subdirectory.

The result file names are defined in the underlying XProc, `METASCHEMA-DOCS-TESTSITE-write.xpl`.

## Pipelines

All these pipelines have a primary input source port named `METASCHEMA`, which should be provided with a valid metaschema whose imports are resolvable and valid.

Ports for outputs (terminal and intermediate results) are not always exposed, for example if the XProc pipeline is configured to write outputs to the file system.

### `METASCHEMA-DOCS-DIVS-write.xpl`

Given a `path` to write to and a key name (schema name), this pipeline serializes and writes a set of documentation rooted at HTML `div` elements, suitable for ingestion into Hugo or any other HTML-based publishing system.

NB: Markdown can be acquired for docs by reducing this HTML to Markdown. Make inquiries if this would be a useful feature for this pipeline.

### `METASCHEMA-DOCS-DIVS.xpl`

This pipeline produces the same outputs as the preceding, except:

- instead of serializing outputs as files, it exposes results on ports
- it permits renaming and redirecting outputs (names and locations) via runtime options

Use this pipeline from script or in an IDE to debug the basic pipeline.

### `METASCHEMA-DOCS-TESTSITE-write.xpl`

Like `METASCHEMA-DOCS-DIVS-write.xpl`, this pipeline writes files to the system, except they are complete HTML files, not only fragments (rooted at `\<div>`). The files are written in a directory whose path provided at runtime, linked and styled using CSS provided in the pipeline.

Use this pipeline to produce a set of standalone documentation ready to preview and use. This is the pipeline called by the script `mvn-schemadocs-testsite-xpl.sh`.

### `METASCHEMA-DOCS-TRACE.xpl`

The base pipeline called by all other HTML rendering pipelines (just listed), exposing all intermediate and final ports for debugging. Use this pipeline directly from script (binding all its ports), from another pipeline (as in other XProcs in this directory) or in an IDE or debugging framework.
