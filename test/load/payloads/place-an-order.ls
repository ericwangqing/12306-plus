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
