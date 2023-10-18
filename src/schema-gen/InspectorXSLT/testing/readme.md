# Testing Metaschema XSLT Inspector XSLT

See the [Testing](../Testing.md) docs for Inspector XSLT for explanation of how these resources can be used.

## If you have a metaschema that you wish to use

## Working with the trial (model) metaschema

### XSpecing the computer model

A number of XSpec files in this folder should all complete successfully and report "all green" -- no warnings, no errors, no unexpected 'pending' sections.

#### `computer-constraints.xspec`


| CONSTRAINT TYPE    | empty(@target) (flags) | target="."  | target="path"
|---|---|---|---|
| allowed-values     |    |     |  |
| allowed-values[@allow-other='yes']     |    |     |  |
| matches/@regex     |
| matches/@datatype  |
| expect             |
| has-cardinality    |
| is-unique          |
| index              |
| index-has-key      |

#### Computer Model metaschema

| CONSTRAINT TYPE    | empty(@target) (flags) | target="."  | target="path"
|---|---|---|---|
| allowed-values     | expansion-card-state-rule_1   | motherboard-type-rule_1  | manufacture-date-rule_1  ata-socket-rule_1 ata-socket-rule_2 ata-socket-rule_3 manufacture-date-rule_1
| allowed-values[@allow-other='yes']     |    |     |  |
| matches/@regex     | id-naming-rule_1   | cpu-speed-rule_1   |
| matches/@datatype  |     |     | manufacture-date-rule_3
| expect             |     |     | manufacture-date-rule_2
| has-cardinality    | n/a | n/a |  |
| is-unique          |     |     |  |
| index              |     |     |  |
| index-has-key      |     |     |  |

tbd - markup-validation.xspec

markup line and markup-multiline validation

- unknown elements
- elements out of place
- text out of place
- weird edge cases e.g. in-xml
- extract these from XSD sources?