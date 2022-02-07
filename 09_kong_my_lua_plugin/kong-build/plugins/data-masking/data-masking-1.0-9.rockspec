package = "data-masking"
version = "1.0-9"


supported_platforms = {"linux", "macosx"}
source = {
  url = "http://github.com/beatsbears/kong-plugin-blog",
  tag = "0.1.0"
}

description = {
  summary = ".....",
  homepage = "..",
  license = ".."
}

dependencies = {
}

local pluginName = "data-masking"
build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "./src/handler.lua",
    ["kong.plugins."..pluginName..".access"] = "./src/access.lua",
    ["kong.plugins."..pluginName..".schema"] = "./src/schema.lua",
  }
}