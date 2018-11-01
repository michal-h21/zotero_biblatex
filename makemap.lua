local json = require "json"
kpse.set_program_name "luatex"
local domobject = require "luaxml-domobject"


local function load_json(filename)
  local f = io.open(filename, "r")
  if not f then return nil, "Cannot load " .. filename end
  local data = f:read("*all")
  return json.decode(data)
end

local function build_csl_fields(map)
  -- make map from CSL to BibLaTeX
  local t = {}
  for _, entry in pairs(map) do
    local csl = entry.csl
    if csl then
      local entries = t[csl] or {}
      table.insert(entries, entry)
      t[csl] = entries
    end
  end
  return t
end

local function load_xml(filename)
  local f = io.open(filename, "r")
  if not f then return nil, "Cannot load " .. filename end
  local data = f:read("*all")
  local dom = domobject.parse(data)
  return dom
end

local function get_zotero_descriptions(dom)
  -- make table with Zotero field types and descriptions
  local t = {}
  for _, entry in ipairs(dom:query_selector("vars var")) do
    local name = entry:get_attribute("name")
    local typ = entry:get_attribute("type")
    local description = entry:get_attribute("description")
    t[name]= {type=typ, description=description}
  end
  return t
end

local cslfields = build_csl_fields(load_json("cslfieldstobiblatex.json"))
local languages = load_json("languages.json")
local pubstates = load_json("pubstates.json")
local bibtypes  = load_json("bibtypes.json")
local zotero_types = load_xml("zoterotypes.xml")
local zotero_descriptions = get_zotero_descriptions(zotero_types)

for _, field in ipairs(zotero_types:query_selector("cslFieldMap map, cslCreatorMap map")) do
  local cslfield = field:get_attribute("cslfield")
  local biblatexmap = cslfields[cslfield] or {}
  local firstbiblatex = biblatexmap[1] or {}
  local biblatexfield = firstbiblatex.biblatex 
  local description = zotero_descriptions[cslfield] or {}
  -- if not biblatexfield then
  if #biblatexmap > 0 then
    -- debug mapping
    print(field:get_attribute("zfield"), cslfield, biblatexfield, #biblatexmap, description.description)
  end
end
