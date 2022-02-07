local access = require "kong.plugins.data-masking.access"


local DatamaskingHandler = {
  VERSION  = "1.0",
  PRIORITY = 506,
}


function DatamaskingHandler:access(conf)
  access.execute(conf)
end


return DatamaskingHandler