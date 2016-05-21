/*eslint no-case-declarations: 0*/
/*eslint no-empty-pattern: 0*/
/*eslint-env nodejs*/

// Test parser (src/parser.coffee)
process.env.NODE_ENV = 'test';
/**
 * Module dependencies
 */
const app = require('../lib/parser');
const chai = require('chai');
const expect = chai.expect;
// Default opts
const options = require('./util/constants').options;
// Fix rm of console.log, due to silent option
const oldConsole = console.log;

describe("Parser tests", () => {
  // Fix rm of console.log, due to silent option
  afterEach(() => {
    console.log = oldConsole;
  });

  beforeEach(() => {
    console.log = oldConsole;
  });

  // Check YAML file
  it("should check if parser can parse a YAML file", (done) => {
    // Customise
    options.file = "example/.retis.yml";
    const returned = app.parseConfig(options);
    expect(returned).to.be.a('object');
    done();
  });

  // Check JSON file
  it("should check if parser can parse a JSON file", (done) => {
    // Customise
    options.file = "package.json";
    const returned = app.parseConfig(options);
    expect(returned).to.be.a('object');
    done();
  });

  // Check CSON file
  it("should check if parser can parse a CSON file", (done) => {
    // Customise
    options.file = "example/plugintest.cson";
    const returned = app.parseConfig(options);
    expect(returned).to.be.a('object');
    done();
  });

  // Check Unknown file
  it("should check if parser throws an error is type is unreconised", (done) => {
    // Customise
    options.file = "test/parser.js";
    expect(() => app.parseConfig(options)).to.throw(TypeError, 'Type of build specification file was not reconised.');
    done();
  });
});
