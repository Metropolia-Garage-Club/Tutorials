local function toggle_comment()
  local comment_strings = {
    lua         = "--",
    sql         = "--",
    mysql       = "--",
    postgres    = "--",
    python      = "#",
    sh          = "#",
    bash        = "#",
    fish        = "#",
    zsh         = "#",
    hyprlang    = "#",
    ruby        = "#",
    perl        = "#",
    yaml        = "#",
    toml        = "#",
    conf        = "#",
    config      = "#",
    make        = "#",
    dockerfile  = "#",
    octave      = "#",
    terraform   = "#",
    hcl         = "#",
    nix         = "#",
    julia       = "#",
    nim         = "#",
    tcl         = "#",
    c           = "//",
    cpp         = "//",
    javascript  = "//",
    java        = "//",
    typescript  = "//",
    tsx         = "//",
    jsx         = "//",
    rust        = "//",
    go          = "//",
    jsonc       = "//",
    php         = "//",
    kotlin      = "//",
    scala       = "//",
    swift       = "//",
    dart        = "//",
    html        = "<!--",
    xml         = "<!--",
    markdown    = "<!--",
    css         = "/*",
    scss        = "/*",
    sass        = "/*",
    scheme      = ";;",
    clojure     = ";;",
    lisp        = ";;",
    elisp       = ";;",
    ini         = ";",
    vim         = '"',
    vimdoc      = '"',
    tex         = "%",
    matlab      = "%",
  }

  local ft = vim.bo.filetype
  local comment = comment_strings[ft]
  if not comment then
    vim.notify("No comment string for filetype: " .. ft, vim.log.levels.WARN)
    return
  end

  local line_nr = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_buf_get_lines(0, line_nr, line_nr + 1, false)[1]
  local indent, content = line:match("^(%s*)(.*)$")
  local escaped_comment = "^%s*" .. vim.pesc(comment)

    if line:match("^%s*" .. vim.pesc(comment)) then
        -- Uncomment
    local uncommented = line:gsub("^(%s*)" .. vim.pesc(comment) .. "%s?", "%1")
    vim.api.nvim_buf_set_lines(0, line_nr, line_nr + 1, false, { uncommented })
    else
    -- Comment
    local commented = comment .. " " .. line
    vim.api.nvim_buf_set_lines(0, line_nr, line_nr + 1, false, { commented })
    end

end

vim.keymap.set("n", "<leader>c", toggle_comment, { desc = "Toggle line comment" })

-- Utility to escape special characters in Lua patterns

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = {"*"},
    callback = function(ev)
        save_cursor = vim.fn.getpos(".")
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.setpos(".", save_cursor)
    end,
})
