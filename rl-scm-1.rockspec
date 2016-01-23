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
   type = "builtin",
   modules = {
       rl = "rl.lua"
   },
    install = {
        lua = {
            rl = "rl.lua"
        }
   },
   copy_directories = { "doc" }
}
