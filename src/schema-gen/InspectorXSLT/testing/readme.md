# Testing Metaschema XSLT Inspector XSLT

See the [Testing](../Testing.md) docs for Inspector XSLT for explanation of how these resources can be used.

## If you have a metaschema that you wish to use

## Working with the trial (model) metaschema

### XSpecing the computer model

A number of XSpec files in this folder should all complete successfully and report "all green" -- no warnings, no errors, no unexpected 'pending' sections.

#### `computer-constraints.xspec`

| CONSTRAINT TYPE    | empty(@target) (flags) | target="."  | target="path"
|---|---|---|---|
| allowed-values     | x   | x   | x
| matches/@regex     | x   | x   | (x)
| matches/@datatype  | O   | ?   | O    
| expect             |     |     |  |
| has-cardinality    | n/a | n/a |  |
| is-unique          |     |     |  |
| index              |     |     |  |
| index-has-key      |     |     |  |

tbd - markup-validation.xspec

markup line and markup-multiline validation

- unknown elements
- elements out of place
- text out of place
- extract from XSD sources?