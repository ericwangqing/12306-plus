(function(){
  '测试文件的头部。本文件代码在项目编译前，被添加到所有测试代码（test**.ls）的最前面。这样，避免了在多个测试文件中写一样的头部。';
  var should, supertest, async, _, utils, server, database, debug, can;
  should = require('should');
  supertest = require('supertest');
  async = require('async');
  _ = require('underscore');
  utils = require('./utils');
  server = require('../bin/server');
  database = require('../bin/database');
  debug = require('debug')('12306');
  can = it;
  describe('测试place-an-order', function(){
    can('正确跑通测试框架', function(done){
      should(5).be.exactly(5);
      done();
    });
    can('订购G71北京西到郑州东', function(done){
      var orderRequest;
      orderRequest = utils.loadFixture('北京西-郑州东-order-request');
      debug("order-request: ", orderRequest);
      supertest(server.app).post('/orders').send(orderRequest).set('Content-Type', 'application/json').expect('Content-Type', /json/).expect(200, done);
    });
    beforeEach(function(done){
      utils.prepareCleanTestDb(function(){
        debug('prepare-clean-test-db complete');
        done();
      });
    });
    afterEach(function(done){
      done();
    });
  });
}).call(this);
