# Planning

## Testing

- [x] Run CI/CD on forks?
  - [x] Refactor testing in this directory
  - [x] smoke-test: is a functional XSLT produced from a valid Metaschema
  - [x] unit-test:
    - current production tests (build out a little)
    - report (mx) format to HTML presentation XSLT
  - [x] spec-test: current functional tests 

## Inspector XSLT

- [ ] Revisit allowed-values semantics?
   - [ ] isolate an example (OSCAL?)
   - [ ] XSpec a retrieval function returning (rule/value)*
   - [ ] check back, anything missed?
- [ ] Address OSCAL functional gaps
   - [ ] OSCAL implementation in oscal-xslt repository
- [ ] More assertively test all constraints
- [ ] More assertively test markup-line and markup-multiline
- [ ] Test out other aspects
   - [ ] interesting assembly/field settings, use-name etc
   - [ ] XSpec MX to HTML to Markdown? functions?
   - [ ] Build out TINY to include constraints on insert (note-ref and term-ref)
- [ ] Review specs with eye to contributions
- [ ] CSX version
   - [ ] CI/CD support for deployment from updated metaschema sources?
- [ ] Release plans and considerations
- [ ] Review opportunities for unit tests: reuse / pubs / pool 

### Test coverage

Working edges:
- Wrapped and unwrapped markup-multiline
- grouped and ungrouped elements and their siblings
- absolute target paths
- broken paths (graceful prevention?)
- INFO and WARNING level tests
- key scoping for index and is-unique

Use constraint rule IDs to wrangle and cross-link constraints with tests

markup line and markup-multiline validation

- unknown elements
- elements out of place
- text out of place
- weird edge cases e.g. in-xml
- extract these from XSD sources?
- 
