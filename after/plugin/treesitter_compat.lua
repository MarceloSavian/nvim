-- Compatibility patch for nvim-treesitter on Neovim 0.12+
--
-- In Neovim 0.12, `add_directive` and `add_predicate` dropped the `all`
-- option: match[capture_id] now ALWAYS returns TSNode[] (an array).
-- nvim-treesitter's query_predicates.lua still treats it as a single TSNode,
-- causing "attempt to call method 'range' (a nil value)" when opening
-- markdown files (or any file with injected languages).
--
-- This file re-registers the broken directives/predicates to unwrap the
-- array before operating on the node.

if vim.fn.has("nvim-0.12") ~= 1 then
    return
end

local ok, query = pcall(require, "vim.treesitter.query")
if not ok then
    return
end

-- Helper: unwrap TSNode[] → TSNode (nvim 0.12 always returns arrays)
local function unwrap(node)
    if type(node) == "table" and not node.range then
        return node[1]
    end
    return node
end

local non_filetype_match_injection_language_aliases = {
    ex = "elixir",
    pl = "perl",
    sh = "bash",
    uxn = "uxntal",
    ts = "typescript",
}

local html_script_type_languages = {
    ["importmap"] = "json",
    ["module"] = "javascript",
    ["application/ecmascript"] = "javascript",
    ["text/ecmascript"] = "javascript",
}

local function get_parser_from_markdown_info_string(injection_alias)
    local match = vim.filetype.match({ filename = "a." .. injection_alias })
    return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
end

query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = unwrap(match[capture_id])
    if not node then
        return
    end
    local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
    metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
end, { force = true })

query.add_directive("set-lang-from-mimetype!", function(match, _, bufnr, pred, metadata)
    local capture_id = pred[2]
    local node = unwrap(match[capture_id])
    if not node then
        return
    end
    local type_attr_value = vim.treesitter.get_node_text(node, bufnr)
    local configured = html_script_type_languages[type_attr_value]
    if configured then
        metadata["injection.language"] = configured
    else
        local parts = vim.split(type_attr_value, "/", {})
        metadata["injection.language"] = parts[#parts]
    end
end, { force = true })

query.add_directive("downcase!", function(match, _, bufnr, pred, metadata)
    local id = pred[2]
    local node = unwrap(match[id])
    if not node then
        return
    end
    local text = vim.treesitter.get_node_text(node, bufnr, { metadata = metadata[id] }) or ""
    if not metadata[id] then
        metadata[id] = {}
    end
    metadata[id].text = string.lower(text)
end, { force = true })

query.add_predicate("kind-eq?", function(match, _pattern, _bufnr, pred)
    local node = unwrap(match[pred[2]])
    if not node then
        return true
    end
    local types = { unpack(pred, 3) }
    return vim.tbl_contains(types, node:type())
end, { force = true })

query.add_predicate("nth?", function(match, _pattern, _bufnr, pred)
    local node = unwrap(match[pred[2]])
    local n = tonumber(pred[3])
    if node and node:parent() and node:parent():named_child_count() > n then
        return node:parent():named_child(n) == node
    end
    return false
end, { force = true })
