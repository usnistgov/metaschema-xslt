const Ajv = require("ajv");
const addFormats = require("ajv-formats");
const schema = require("../../test_output/models_metaschema_schema.json");
const ajv = new Ajv();
const fs = require("fs");
addFormats(ajv);

/**
 * Creates a schema validator function from a JSON schema and writes it to a file.
 * @param {string} filePath - The path to the JSON schema file.
 * @param {string} schemaName - The name of the schema, used for naming the output file.
 */
const createSchemaValidator = (filePath, schemaName) => {
  // Compile the schema
  const validate = ajv.compile(schema);

  // Convert the compiled function to a string and add module.exports and export default
  const validateFunctionString = `const validate = ${validate.toString()};\nmodule.exports = validate;\nexport default validate;`;

  // Write the function string to a file
  fs.writeFileSync("validate-" + schemaName + ".js", validateFunctionString);
};

createSchemaValidator("../../test_output/models_metaschema_schema.json", "models");

console.log("Building schema validator");