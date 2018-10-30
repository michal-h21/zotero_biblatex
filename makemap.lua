local json = require "json"
kpse.set_program_name "luatex"
local domobject = require "luaxml-domobject"


local function load_json(filename)
  local f = io.open(filename, "r")
  if not f then return nil, "Cannot load " .. filename end
  local data = f:read("*all")
  return json.decode(data)
end

local function load_xml(filename)
  local f = io.open(filename, "r")
  if not f then return nil, "Cannot load " .. filename end
  local data = f:read("*all")
  local dom = domobject.parse(data)
  return dom
end
local cslfields = load_json("cslfieldstobiblatex.json")
local languages = load_json("languages.json")
local pubstates = load_json("pubstates.json")
local bibtypes  = load_json("bibtypes.json")
local zotero_types = load_xml("zoterotypes.xml")

for _, field in ipairs(zotero_types:query_selector("cslFieldMap map")) do
  print(field:get_attribute("zfield"), field:get_attribute("cslfield"))
end
