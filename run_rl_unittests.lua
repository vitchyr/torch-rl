math.randomseed(os.time())

util_tester = require 'unittest_util'
util_tester:run()

qhash_tester = require 'unittest_qhash'
qhash_tester:run()

fe_tester = require 'unittest_featureextraction'
fe_tester:run()

agent_tester = require 'unittest_agent'
agent_tester:run()
