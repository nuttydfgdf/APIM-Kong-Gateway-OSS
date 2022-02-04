local kong = kong

-- Import our class for removing sensitive headers
local hf = require "kong.plugins.hello-world.header_filter"

-- Import the base kong plugin
local BasePlugin = require "kong.plugins.base_plugin"

-- Extend our plugin from the base plugin
local HelloHandler = BasePlugin:extend()

-- Setting this very early to avoid logging any service-tokens
HelloHandler.PRIORITY = 5

-- creates a new instance of the plugin
function HelloHandler:new()
  HelloHandler.super.new(self, "hello-world")
end

-- plugin built-in method to handle response header filtering
function HelloHandler:header_filter(conf)

  HelloHandler.super.header_filter(self)

  -- Add our logic
  hf.filter(conf, kong.response.get_headers())

  kong.response.set_header("X-Hello", "Hello world.!!!")
end

-- return the plugin class
return HelloHandler