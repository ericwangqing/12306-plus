'''
测试文件的头部。本文件代码在项目编译前，被添加到所有测试代码（test**.ls）的最前面。这样，避免了在多个测试文件中写一样的头部。
'''
require! {should, supertest, async, _: underscore, './utils', '../bin/server', '../bin/database'}

debug = require('debug')('12306')
can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can。虽然在LiveScript 1.2.0中可以用 (...)->的方式，避免用it作为缺省参数；但是，我们依然用can，因为这样的描述性更好。

describe '测试place-an-order', !->
  can '正确跑通测试框架', (done)!->
    should(5).be.exactly(5)
    done!

  can '订购G71北京西到郑州东', (done)!->
    order-request = utils.load-fixture '北京西-郑州东-order-request'
    debug "order-request: ", order-request
    supertest(server.app)
      .post '/orders'
      .send order-request
      .set 'Content-Type', 'application/json'
      .expect 'Content-Type', /json/
      .expect 200, done
    # utils.post '/orders', order-request, done


  before-each (done)!->
    utils.prepare-clean-test-db !->
      debug 'prepare-clean-test-db complete'
      done!

  after-each (done)!->
    # utils.close-db! # DON'T QUIT,  flushdb in before is enough!
    done!
