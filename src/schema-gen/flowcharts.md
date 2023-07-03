# 

scripts - NW
XSLTs
XProcs
Metaschema site PR
  redirect XSLTs with message?
Wiki - flowchart diagrams
AG - Metaschema meetings?

Mermaid code delivered by XProc Visualizer and adjusted by hand.


## XProc METASCHEMA-ALL-SCHEMAS.xpl

Adjustments:
- Moved `serialize-json_stylesheet_document` to the end


```mermaid
---
METASCHEMA-ALL-SCHEMAS.xpl
---
%%{ init: {
  'flowchart': { 'curve': 'linear' },
  'themeVariables': {
    'primaryColor':       'whitesmoke',
    'secondaryColor':     'lavender',
    'tertiaryColor':      'gainsboro',
    'primaryTextColor':   'black',
    'primaryBorderColor': 'black',
    'lineColor':          'black' },
   'theme':'base' }
}%%
flowchart TB

serialize-json_xslt -. OUTPUT .-> OUT_json-schema_output([output port 'OUT_json-schema'])
make-xsd_xslt -. OUTPUT .-> OUT_xml-schema_output([output port 'OUT_xml-schema'])
input_port_METASCHEMA ===>|SOURCE|input_identity[IDENTITY 'input']
input_identity ===>|SOURCE|compose_metaschema-compose{{METASCHEMA-COMPOSE 'compose'}}
compose_metaschema-compose ===>|SOURCE|composed_identity[IDENTITY 'composed']
make-xsd_stylesheet_document[/document 'XSD/make-metaschema-xsd.xsl'/] -->|STYLESHEET|make-xsd_xslt[[XSLT 'make-xsd']]
composed_identity ===>|SOURCE|make-xsd_xslt[[XSLT 'make-xsd']]
composed_identity ===>|SOURCE|make-json-schema-xml_xslt[[XSLT 'make-json-schema-xml']]
make-json-schema-xml_stylesheet_document[/document 'JSON-schema/make-json-schema-metamap.xsl'/] -->|STYLESHEET|make-json-schema-xml_xslt[[XSLT 'make-json-schema-xml']]
make-json-schema-xml_xslt ===>|SOURCE|serialize-json_xslt[[XSLT 'serialize-json']]
input_port_METASCHEMA[(input port 'METASCHEMA')]
input_port_parameters[(input port 'parameters')]
input_identity -. OUTPUT .-> IN_0_echo-input_output([output port 'IN_0_echo-input'])
composed_identity -. OUTPUT .-> IN_1_composed-metaschema_output([output port 'IN_1_composed-metaschema'])
make-json-schema-xml_xslt -. OUTPUT .-> OUT_json-schema-xml_output([output port 'OUT_json-schema-xml'])
serialize-json_stylesheet_document[/document '../common/xpath-json-to-json.xsl'/] -->|STYLESHEET|serialize-json_xslt[[XSLT 'serialize-json']]
```


