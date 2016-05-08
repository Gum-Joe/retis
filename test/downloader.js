/*eslint no-case-declarations: 0*/
/*eslint no-empty-pattern: 0*/
/*eslint-env es6*/
// Tests src/downloader.coffee
/**
 * Module dependencies
 */
const app = require('../lib/downloader');
const chai = require('chai');
const fs = require('fs');
// Default opts
const options = {
  silent: true,
  file: 'example/.retis.yml'
};
// Fix rm of console.log, due to silent option
const oldConsole = console.log;
// The test
describe("Downloader.coffee tests", () => {
  // Fix rm of console.log, due to silent option
  afterEach(() => {
    console.log = oldConsole;
  });
  // Check if can download
  it("should check if downloader can download a file successfully", (done) => {
    const testurl = "https://raw.githubusercontent.com/jakhu/retis-ci/master/README.md";
    app.get(testurl, ".TEST.md", options, () => {
      // Check if success
      fs.stat(".TEST.md", (err, stat) => {
        // RM
        fs.unlinkSync(".TEST.md")
        if (err) {
          done(err)
        } else {
          done()
        }
      })
    })
    // Fix rm of console.log, due to silent option
    console.log = oldConsole;
  });
});
