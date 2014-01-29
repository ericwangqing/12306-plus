var async, database, http, debug, _, FIXTURE_PATH, AllDoneWaiter, loadFixture, openCleanDbAndLoadFixtures, prepareCleanTestDb, closeDb;
async = require('async');
database = require('../bin/database');
http = require('http');
debug = require('debug')('12306');
_ = require('underscore');
FIXTURE_PATH = __dirname + '/../test-bin/';
AllDoneWaiter = (function(){
  AllDoneWaiter.displayName = 'AllDoneWaiter';
  var prototype = AllDoneWaiter.prototype, constructor = AllDoneWaiter;
  function AllDoneWaiter(done){
    this.done = done;
    this.check = bind$(this, 'check', prototype);
    this.addWaitingFunction = bind$(this, 'addWaitingFunction', prototype);
    this.setDone = bind$(this, 'setDone', prototype);
    this.runningFunctions = 0;
  }
  prototype.setDone = function(done){
    return this.done = done;
  };
  prototype.addWaitingFunction = function(fn){
    var this$ = this;
    this.runningFunctions += 1;
    return function(){
      if (fn) {
        fn.apply(null, arguments);
      }
      this$.runningFunctions -= 1;
      this$.check();
    };
  };
  prototype.check = function(){
    if (this.runningFunctions === 0) {
      this.done();
    }
  };
  return AllDoneWaiter;
}());
loadFixture = function(dataName){
  return eval(require('fs').readFileSync(FIXTURE_PATH + dataName + '.js', {
    encoding: 'utf-8'
  }));
};
openCleanDbAndLoadFixtures = function(config, done){
  var store, datanames;
  store = database.get().store;
  store.flushdb();
  datanames = _.keys(config);
  async.each(datanames, function(dataname, next){
    async.each(_.values(config[dataname]), function(keyValues, _next){
      async.each(_.keys(keyValues), function(key, __next){
        var value;
        store.set(key, value = keyValues[key], function(err, docs){
          if (err) {
            console.log('error: ', err);
          }
          __next();
        });
      }, function(){
        return _next();
      });
    }, function(){
      return next();
    });
  }, function(){
    return done();
  });
};
prepareCleanTestDb = function(done){
  openCleanDbAndLoadFixtures({
    '京九线': loadFixture("京九线")
  }, done);
};
closeDb = function(done){
  var store;
  store = database.get().store;
  store.quit();
};
module.exports = {
  AllDoneWaiter: AllDoneWaiter,
  loadFixture: loadFixture,
  openCleanDbAndLoadFixtures: openCleanDbAndLoadFixtures,
  prepareCleanTestDb: prepareCleanTestDb,
  closeDb: closeDb
};
function bind$(obj, key, target){
  return function(){ return (target || obj)[key].apply(obj, arguments) };
}