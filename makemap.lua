local json = require "json"

local function load_json(filename)
  local f = io.open(filename, "r")
  if not f then return nil, "Cannot load " .. filename end
  local data = f:read("*all")
  return json.decode(data)
end

local cslfields = load_json("cslfieldstobiblatex.json")
local languages = load_json("languages.json")
local pubstates = load_json("pubstates.json")
local bibtypes  = load_json("bibtypes.json")
for k,v in pairs(cslfields) do
  print(k,v)
end
