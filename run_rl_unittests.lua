math.randomseed(os.time())

util_tester = require 'unittest_util'
util_tester:run()

qv_tester = require 'unittest_qv'
qv_tester:run()

fe_tester = require 'unittest_featureextraction'
fe_tester:run()

agent_tester = require 'unittest_agent'
agent_tester:run()
