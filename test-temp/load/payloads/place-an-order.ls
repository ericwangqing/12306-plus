'''
测试文件的头部。本文件代码在项目编译前，被添加到所有测试代码（test**.ls）的最前面。这样，避免了在多个测试文件中写一样的头部。
'''
require! {should, supertest, async, _: underscore, './utils', '../bin/server', '../bin/database'}

debug = require('debug')('12306')
can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can。虽然在LiveScript 1.2.0中可以用 (...)->的方式，避免用it作为缺省参数；但是，我们依然用can，因为这样的描述性更好。

request = order = # 用户信息（usre-id）在session里
  id: 'xxx-xx' # 订单号，系统生成
  day: '2013-03-01'
  train-no: 'K953'
  tid: 'xxxxx' # 12306+系统生成、维护，用于查询车次基本信息（经停、时刻、座位编排等）
  departure: '北京' 
  travelers: 
    * uid: 'xxx-xxx' # 12306+系统生成、维护，用于和用户系统集成
      name: '张三'
      id-type: '身份证'
      terminal: '周口' # 多个旅客同行，可乘一趟列车，比邻而坐，在不同目的地下车
      ticket-type: '硬座' # 同行旅客可选择不同类型座位和等级
      ticket-class: '一等'
      discount: '学生'
    * uid: 'xxx-xxx' # 12306+系统生成、维护，用于和用户系统集成
      name: '李四'
      id-type: '军官证'
      terminal: '郑州' # 多个旅客同行，可乘一趟列车，比邻而坐，在不同目的地下车
      ticket-type: '硬座' # 同行旅客可选择不同类型座位和等级
      ticket-class: '一等'
  is-all-together: '无所谓' # '无所谓'(default) | '必同行' (不能同行，就不出行)
