math.randomseed(os.time())

util_tester = require 'unittest_util'
util_tester:run()

qhash_tester = require 'unittest_qhash'
qhash_tester:run()

vhash_tester = require 'unittest_vhash'
vhash_tester:run()

fe_tester = require 'unittest_featureextraction'
fe_tester:run()

mdpsampler_tester = require 'unittest_mdpsampler'
mdpsampler_tester:run()
