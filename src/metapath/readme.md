# Metaschema Metapath

A prototype / proof-of-concept path evaluation library.

Provides for processing Metapath syntax and operations dependent on processing such as path rewriting.

Modules here including `metapath-jsonize.xsl` and `docs-metapath.xsl` may be included or called into pipelines elsewhere in this library.

Provided XSpec tests along with inline code help to document the interfaces.

## Note to developers

This implementation was first built out of necessity, and includes functionality untested before its development, as well as machine-generated code whose ongoing reproduction may be problematic.

At the same time, since its inception, new capabilities in the XML stack, notably [Invisible XML](https://invisiblexml.org), provide a strong foundation for further work.

See also the related project repository hosting iXML support, the [iXML Breadboard](https://github.com/usnistgov/ixml-breadboard)

Accordingly, next steps might include a near-term migration onto an iXML-based implementation providing the same service.

For an iXML grammar, until a normative Metapath grammar is published, the alignment target is [the Metapath grammar](https://github.com/usnistgov/metaschema-java/blob/main/core/src/main/antlr4/metapath10.g4) supported in the metaschema-java project.

---
