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
