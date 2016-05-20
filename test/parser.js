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

  // Check YAML file
  it("should check if parser can parse a YAML script file", (done) => {
    // Customise
    options.file = "example/.retis.yml";
    const returned = app.parseConfig(options);
    expect(returned).to.be.a('object');
    done();
  });
});
