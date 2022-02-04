package = "hello-world"
version = "1.1-1"


supported_platforms = {"linux", "macosx"}
source = {
  url = "http://github.com/beatsbears/kong-plugin-blog",
  tag = "0.1.0"
}

description = {
  summary = "hello is a plugin for removing potentially sensitive security token headers from responses.",
  homepage = "http://github.com/beatsbears/kong-plugin-blog",
  license = "MIT"
}

dependencies = {
}

local pluginName = "hello-world"
build = {
  type = "builtin",
  modules = {
    ["kong.plugins."..pluginName..".handler"] = "./src/handler.lua",
    ["kong.plugins."..pluginName..".schema"] = "./src/schema.lua",
    ["kong.plugins."..pluginName..".header_filter"] = "./src/header_filter.lua",
  }
}