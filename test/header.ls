'''
测试文件的头部。本文件代码在项目编译前，被添加到所有测试代码（test**.ls）的最前面。这样，避免了在多个测试文件中写一样的头部。
'''
require! {should, supertest, async, _: underscore, './utils', '../bin/server', '../bin/database'}

debug = require('debug')('12306')
can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can。虽然在LiveScript 1.2.0中可以用 (...)->的方式，避免用it作为缺省参数；但是，我们依然用can，因为这样的描述性更好。

