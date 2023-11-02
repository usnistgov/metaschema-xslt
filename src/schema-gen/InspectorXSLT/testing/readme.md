# Testing Metaschema XSLT Inspector XSLT

See the [Testing](../Testing.md) docs for Inspector XSLT for explanation of how these resources can be used.

## If you have a metaschema that you wish to use

Use the script to produce your Inspector XSLT, or run the pipeline directly, not skipping composition, (Even a self-containted schema module in one file needs to be composed to link up definitions with their uses.)

[Apply your new Inspector XSLT to your metaschema-defined XML](../readme.md), either directly with an XSLT engine or using adapted versions of the scripts provided for the demo. Please consider reporting what you learn.

## Working with the trial (model) metaschema

`computer_metaschema.xml` has been provided with some outlandish rules and constraints, enabling it as a testbed for the application of constraints to arbitrary metaschema-defined data (specifically XML for this application).

Some [known-valid](valid/) and [known-invalid](invalid/) instances are also provided, serving as examples and out-of-line tests.

### XSpec demonstrating correctness of the Inspector

An Inspector can be generated from the metaschema `computer_model.xml` and tested against known inputs to demonstrate that the tests performed by the Inspector bring the correct results.

Exercising these tests, a number of XSpec files in this folder calling `current/computer_inspector.xsl` should all complete successfully and report "all green" -- no warnings, no errors, no unexpected 'pending' sections.

See the [Testing](../Testing.md) docs for more information.

#### Next up

Nov 2 - (not necessarily in priority order)

- [ ] Complete constraints feature set
   - [x] `index`
   - [x] `index-has-key`
   - [x] `is-unique`
   - [ ] align `allow-values` with current/best?
     - [ ] develop an example 
     - [ ] XSpec the retrieval function returning (rule/value)*
   - [ ] check back, anything missed?
- [ ] Test out other aspects
   - [ ] interesting assembly/field settings, use-name etc
   - [ ] markup-line and markup-multiline
   - [ ] MX to HTML to Markdown
   - [ ] Anthology example for some of these?
- [ ] Review specs with eye to contributions
- [ ] OSCAL implementation
   - [ ] Publishing considerations
   - [ ] Pages / platform
- [ ] CSX version
   - [ ] CI/CD support for deployment from updated metaschema sources?
- [ ] Release plans and considerations
- [ ] Review opportunities for unit tests: reuse / pubs / pool 

Coverage notes follow.

#### `computer-constraints.xspec`


| CONSTRAINT TYPE    | code | empty(@target) (flags) | target="."  | target="path"
|---|---|:---:|:---:|:---:|
| allowed-values     | AVCV   |  x | x | x |
| allowed-values[@allow-other='yes']   |    |     |  |
| matches/@regex     | MRCV | x | x |  | 
| matches/@datatype  | MDCV (equivalent to VDSX) | | | x |
| expect             | XPKT | | x | x |
| has-cardinality    | HCCV | n/a | n/a |
| is-unique          | UNIQ
| index              | 
| index-has-key      | NDXK

#### Computer Model metaschema

| CONSTRAINT TYPE    | empty(@target) (flags) | target="."  | target="path"
|---|---|---|---|
| allowed-values     | expansion-card-state-rule_1   | motherboard-type-rule_1  | manufacture-date-rule_1  ata-socket-rule_1 ata-socket-rule_2 ata-socket-rule_3 manufacture-date-rule_1
| allowed-values[@allow-other='yes']     |    |     |  |
| matches/@regex     | id-naming-rule_1   | cpu-speed-rule_1   |
| matches/@datatype  |     |     | manufacture-date-rule_3
| expect             |     | byte-size-test_1 memory-rule_1   | manufacture-date-rule_2
| has-cardinality    | n/a | n/a |  |
| is-unique          |     |     |  |
| index              |     |     |  |
| index-has-key      |     |     |  |

for is-unique - generate key that matches targets using value
  ensure
     $sec :=key('keyname',$val,$scope) exists($seq) and empty($seq[2])


exists($s) and empty($s[2])
test= exists(key(...) except .)

bare XPath is best for transparency

```
<xsl:variable name="m:is-singleton" as="function(*)"
      select="function($seq as item()*) as xs:boolean { exists($seq) and empty($seq[2]) }"/>
```

### Test coverage

Working edges:
  Wrapped and unwrapped markup-multiline
  grouped and ungrouped elements and their siblings
  absolute target paths
  broken paths (graceful prevention?)
  INFO and WARNING level tests
  key scoping for index and is-unique
poll metaschema w/ reference to XSpecs

for each constraint ensuring it has an @id locate all x:scenario//mx:report with that rule-id

tbd - markup-validation.xspec

markup line and markup-multiline validation

- unknown elements
- elements out of place
- text out of place
- weird edge cases e.g. in-xml
- extract these from XSD sources?