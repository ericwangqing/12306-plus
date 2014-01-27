## -------------------- 外部REST API -------------------- 

## 用户订票
## URL: /orders
## Method: POST
request = order =# 用户信息（usre-id）在session里
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
  # TODO: '相邻策略': '愿相邻' # '无所谓'(default) | '愿相邻' (排不到相邻，也可以接受) | '必相邻' (不相邻，不要票) ; 这里的相邻，系统将尽力比邻排座。如果不能比邻，将尝试同车厢排座，此时仍算满足相邻策略

response =
  '结果': '成功' # '成功', '无票', '出错' # 此处的出错，是业务逻辑上出现了错误，例如证件号码有误，或者旅客已有同时间出行的车票，各种系统错误（服务器问题、网络问题），都由HTTP的状态码表示
  '错误原因': '旅客李四已有2013-03-01 T90客票，旅行时间冲突，无法订票' ## ！！注意，前端要在本地缓存订票请求，以便重新加载后，便于用户修改
  '成功消息': '旅客张三、李四已经订到2013-03-01日K953客票，并将比邻而坐，旅客赵五未能订到，按照您的意愿（同行策略：无所谓），已经生成订单，请在半小时内支付。'

## 进入支付平台
## URL: /payments/go-to-pay/:pay-platform-id/:order-id
## Method: GET
## 条件：需要session中有对应的 loggin-user-id == order.user-id
## 参数：
##    order-id: 订单号
##    pay-platform-id: 用户选择的第三方支付平台id
response = 
  pay-url: 'xxxxxx' # 将在新窗口打开，用户去完成支付

## 显示订票结果 / 查询订单状态
## URL: /orders/:order-id
## Method: GET
## 条件：需要session中有对应的 loggin-user-id == order.user-id
## 参数：
##    order-id: 订单号
response = order



## -------------------- 内部 API ------------------------ 
book-tickets = (order)->
  train-key = get-train-key order.day, order.train-id ## ！！后台要有维护进程，清理余票数据库，进行放票（修改对于列车余票），和将已经执行的列车archive
  booked-travelers = []
  for traveler in travelers
    train-ticket-key = get-train-ticket-key train-key, travel.ticket-type, travel.ticket-class 
    departure-terminal-mask = get-departure-terminal-mask order.train-id, order.departure, traveler.terminal
    try
      book-ticket train-key, departure-terminal-mask
      booked-travelers.push traveler
    catch error
      throw error if error.message isnt 'out-of-tickets' or order.is-all-together
      cancel-ticket train-key, booked-travelers
  return {'结果': '失败', '错误原因': '无票了'} if booked-travelers.length is 0
  cache-order-result order, booked-travelers
  assign-seats booked-travelers, order # 开始异步排座
  {'结果': '失败', '成功消息': get-response order, booked-travelers}

start-payment = (order-id, pay-platform-id)->
  order-result = get-order-result order-id
  order-reuslt.bill = generate-bill order-result, pay-platform-id
  order-reuslt.bill.payment-url


payment-successfule-callback = (pay-platform-id, bill-id)->
  order = get-order-by-bill-id pay-platform-id, bill-id
  [traveler.record-order order for traveler in order.booked-travelers]
  order.state = 'done'

payment-failed-callback = (pay-platform-id, bill-id)->
  order = get-order-by-bill-id pay-platform-id, bill-id
  cancel-order order




    