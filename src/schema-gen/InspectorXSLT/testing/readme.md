# Testing Metaschema XSLT Inspector XSLT

See the [Testing](../Testing.md) docs for Inspector XSLT for explanation of how these resources can be used.

## If you have a metaschema that you wish to use

## Working with the trial (model) metaschema

### XSpecing the computer model

A number of XSpec files in this folder should all complete successfully and report "all green" -- no warnings, no errors, no unexpected 'pending' sections.

#### `computer-constraints.xspec`


| CONSTRAINT TYPE    | code | empty(@target) (flags) | target="."  | target="path"
|---|---|---|---|
| allowed-values     | AVCV   |  x | x | x |
| allowed-values[@allow-other='yes']     |    |     |  |
| matches/@regex     | MRCV |
| matches/@datatype  | MDCV (equivalent to VDSX) |
| expect             | XPKT
| has-cardinality    | HCCV | n/a | n/a |
| is-unique          | UNIQ
| index              | 
| index-has-key      | NDXK

exists($s) and empty($s[2])

```
<xsl:variable name="m:is-singleton" as="function(*)"
      select="function($seq as item()*) as xs:boolean { exists($seq) and empty($seq[2]) }"/>
```

#### Computer Model metaschema

| CONSTRAINT TYPE    | empty(@target) (flags) | target="."  | target="path"
|---|---|---|---|
| allowed-values     | expansion-card-state-rule_1   | motherboard-type-rule_1  | manufacture-date-rule_1  ata-socket-rule_1 ata-socket-rule_2 ata-socket-rule_3 manufacture-date-rule_1
| allowed-values[@allow-other='yes']     |    |     |  |
| matches/@regex     | id-naming-rule_1   | cpu-speed-rule_1   |
| matches/@datatype  |     |     | manufacture-date-rule_3
| expect             |     | **byte-size-test_1** memory-rule_1   | **manufacture-date-rule_2**
| has-cardinality    | n/a | n/a |  |
| is-unique          |     |     |  |
| index              |     |     |  |
| index-has-key      |     |     |  |

for is-unique - generate key that matches targets using value
  ensure
     $sec :=key('keyname',$val,$scope) exists($seq) and empty($seq[2])

tbd - markup-validation.xspec

markup line and markup-multiline validation

- unknown elements
- elements out of place
- text out of place
- weird edge cases e.g. in-xml
- extract these from XSD sources?