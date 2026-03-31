local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>pr', builtin.resume, {})

local function git_root_for_current_buffer()
  local file = vim.api.nvim_buf_get_name(0)
  local dir = file ~= "" and vim.fn.fnamemodify(file, ":p:h") or vim.uv.cwd()
  local cmd = "git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel"
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 or #out == 0 then
    return nil
  end
  return out[1]
end

local function git_grep_to_qf(query, use_extended_regex)
  local root = git_root_for_current_buffer()
  if not root then
    vim.notify("GitGrep: not inside a git repo", vim.log.levels.WARN)
    return
  end

  local regex_flag = use_extended_regex and "-E " or ""
  local cmd = "git -C " .. vim.fn.shellescape(root) .. " grep -n --column --no-color " .. regex_flag .. "-- " .. vim.fn.shellescape(query)
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 and #lines == 0 then
    vim.notify("GitGrep: no matches", vim.log.levels.INFO)
    return
  end
  vim.fn.setqflist({}, "r", {
    title = "GitGrep: " .. query,
    lines = lines,
    efm = "%f:%l:%c:%m",
  })
  vim.cmd("copen")
end

vim.api.nvim_create_user_command("GitGrep", function(opts)
  git_grep_to_qf(opts.args)
end, { nargs = 1 })

vim.keymap.set('n', '<leader>pg', function()
  local query = vim.fn.expand("<cword>")
  if query ~= "" then
    git_grep_to_qf(query)
  else
    vim.notify("GitGrep: no word under cursor", vim.log.levels.INFO)
  end
end, {})

vim.keymap.set('n', '<leader>pG', function()
  local query = vim.fn.input("GitGrep > ")
  if query ~= "" then
    git_grep_to_qf(query)
  end
end, {})

vim.keymap.set('n', '<leader>pc', function()
  local symbol = vim.fn.expand("<cword>")
  local pattern = "\\b" .. symbol .. "\\s*\\("
  git_grep_to_qf(pattern, true)
end, {})

vim.keymap.set('n', '<leader>pq', builtin.quickfix, {})
