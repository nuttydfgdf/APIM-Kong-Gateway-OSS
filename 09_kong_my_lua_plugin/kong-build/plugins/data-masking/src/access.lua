local multipart = require "multipart"
local cjson = require "cjson"
local pl_template = require "pl.template"
local pl_tablex = require "pl.tablex"

local table_insert = table.insert
local get_uri_args = kong.request.get_query
local set_uri_args = kong.service.request.set_query
local clear_header = kong.service.request.clear_header
local get_header = kong.request.get_header
local set_header = kong.service.request.set_header
local get_headers = kong.request.get_headers
local set_headers = kong.service.request.set_headers
local set_method = kong.service.request.set_method
local set_path = kong.service.request.set_path
local get_raw_body = kong.request.get_raw_body
local set_raw_body = kong.service.request.set_raw_body
local encode_args = ngx.encode_args
local ngx_decode_args = ngx.decode_args
local type = type
local str_find = string.find
local pcall = pcall
local pairs = pairs
local error = error
local rawset = rawset
local pl_copy_table = pl_tablex.deepcopy

local _M = {}
local template_cache = setmetatable( {}, { __mode = "k" })
local template_environment

local DEBUG = ngx.DEBUG
local CONTENT_LENGTH = "content-length"
local CONTENT_TYPE = "content-type"
local HOST = "host"
local JSON, MULTI, ENCODED = "json", "multi_part", "form_encoded"
local EMPTY = pl_tablex.readonly({})


local compile_opts = {
  escape = "\xff", -- disable '#' as a valid template escape
}


local function parse_json(body)
  if body then
    local status, res = pcall(cjson.decode, body)
    if status then
      return res
    end
  end
end

local function decode_args(body)
  if body then
    return ngx_decode_args(body)
  end
  return {}
end

local function get_content_type(content_type)
  if content_type == nil then
    return
  end
  if str_find(content_type:lower(), "application/json", nil, true) then
    return JSON
  elseif str_find(content_type:lower(), "multipart/form-data", nil, true) then
    return MULTI
  elseif str_find(content_type:lower(), "application/x-www-form-urlencoded", nil, true) then
    return ENCODED
  end
end

-- meta table for the sandbox, exposing lazily loaded values
local __meta_environment = {
  __index = function(self, key)
    local lazy_loaders = {
      headers = function(self)
        return get_headers() or EMPTY
      end,
      query_params = function(self)
        return get_uri_args() or EMPTY
      end,
      uri_captures = function(self)
        return (ngx.ctx.router_matches or EMPTY).uri_captures or EMPTY
      end,
      shared = function(self)
        return ((kong or EMPTY).ctx or EMPTY).shared or EMPTY
      end,
    }
    local loader = lazy_loaders[key]
    if not loader then
      -- we don't have a loader, so just return nothing
      return
    end
    -- set the result on the table to not load again
    local value = loader()
    rawset(self, key, value)
    return value
  end,
  __newindex = function(self)
    error("This environment is read-only.")
  end,
}

template_environment = setmetatable({
  -- here we can optionally add functions to expose to the sandbox, eg:
  -- tostring = tostring,  -- for example
  -- because headers may contain array elements such as duplicated headers
  -- type is a useful function in these cases. See issue #25.
  type = type,
}, __meta_environment)

local function clear_environment(conf)
  rawset(template_environment, "headers", nil)
  rawset(template_environment, "query_params", nil)
  rawset(template_environment, "uri_captures", nil)
  rawset(template_environment, "shared", nil)
end

local function iter(config_array)
  return function(config_array, i, previous_name, previous_value)
    i = i + 1
    local current_pair = config_array[i]
    if current_pair == nil then -- n + 1
      return nil
    end

    local current_name, current_value = current_pair:match("^([^:]+):*(.-)$")

    if current_value == "" then
      return i, current_name
    end

    local res, err = param_value(current_value, config_array)
    if err then
      return error("[request-transformer] failed to render the template " ..
                    current_value .. ", error:" .. err)
    end

    kong.log.debug("[request-transformer] template `", current_value,
                    "` rendered to `", res, "`")

    return i, current_name, res
  end, config_array, 0
end

  

local function append_value(current_value, value)
  local current_value_type = type(current_value)

  if current_value_type  == "string" then
    return { current_value, value }
  elseif current_value_type  == "table" then
    table_insert(current_value, value)
    return current_value
  else
    return { value }
  end
end

local function transform_json_body(conf, body, content_length)
  local removed, renamed, replaced, added, appended = false, false, false, false, false
  local content_length = (body and #body) or 0
  local parameters = parse_json(body)
  if parameters == nil then
    if content_length > 0 then
      return false, nil
    end
    parameters = {}
  end

  if content_length > 0 then
    parameters["creditcard"] = "123456XXXXXX9876"
    parameters["password"] = "*********"
    replaced = true
  end


  if removed or renamed or replaced or added or appended then
    return true, cjson.encode(parameters)
  end
end

local function data_masking_body(conf)
    local content_type_value = get_header(CONTENT_TYPE)
    local content_type = get_content_type(content_type_value)

    -- Call req_read_body to read the request body first
    local body = get_raw_body()
    local is_body_transformed = false
    local content_length = (body and #body) or 0
  
    if content_type == JSON then
      is_body_transformed, body = transform_json_body(conf, body, content_length)
    end
  
    if is_body_transformed then
      set_raw_body(body)
      set_header(CONTENT_LENGTH, #body)
    end
  end


function _M.execute(conf)
  clear_environment()
--   transform_body(conf)
  data_masking_body(conf)
end

return _M