package = "rl"
version = "scm-1"

source = {
   url = "git://github.com/vpong/torch-rl.git",
   tag = "v1.1"
}

description = {
   summary = "A package for basic reinforcement learning algorithms.",
   detailed = [[
        A package for basic reinforcement learning algorithms
   ]],
   homepage = "https://github.com/vpong/torch-rl"
}

dependencies = {
   "lua ~> 5.1",
   "torch >= 7.0"
}

build = {
   type = "none",
   install = {
        lua = {
            "rl.lua",
            "AllActionsEqualPolicy.lua",
            "analyze_lin_sarsa.lua",
            "analyze_nn_sarsa.lua",
            "analyze_sarsa.lua",
            "analyze_table_sarsa.lua",
            "constants.lua",
            "ConstExplorer.lua",
            "ControlFactory.lua",
            "Control.lua",
            "DecayTableExplorer.lua",
            "EpisodeBuilder.lua",
            "Evaluator.lua",
            "Explorer.lua",
            "generate_q_mc.lua",
            "GreedyPolicy.lua",
            "hellomodule.lua",
            "io_util.lua",
            "LinSarsaFactory.lua",
            "LinSarsa.lua",
            "MdpConfig.lua",
            "Mdp.lua",
            "MdpSampler.lua",
            "mdputil.lua",
            "MonteCarloControl.lua",
            "NNSarsaFactory.lua",
            "NNSarsa.lua",
            "Policy.lua",
            "q2.lua",
            "QApprox.lua",
            "QFunc.lua",
            "QHash.lua",
            "QLin.lua",
            "QNN.lua",
            "QVAnalyzer.lua",
            "rl.lua",
            "SAFeatureExtractor.lua",
            "SarsaAnalyzer.lua",
            "SarsaFactory.lua",
            "Sarsa.lua",
            "show_policies.lua",
            "TableSarsaFactory.lua",
            "TableSarsa.lua",
            "tensorutil.lua",
            "TestMdp.lua",
            "TestMdpQVAnalyzer.lua",
            "test_montecarlo.lua",
            "TestPolicy.lua",
            "TestSAFE.lua",
            "test_tablesarsa.lua",
            "test_thresholdpolicy.lua",
            "util_for_unittests.lua",
            "util.lua",
            "ValueIteration.lua",
            "VFunc.lua",
            "VHash.lua"
        }
   },
   copy_directories = { "doc" , "test"}
}
