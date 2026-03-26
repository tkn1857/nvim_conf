local group = vim.api.nvim_create_augroup("autosave", { clear = true })

local function can_save(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return false
  end

  if vim.bo[bufnr].modifiable == false or vim.bo[bufnr].readonly then
    return false
  end

  if vim.bo[bufnr].buftype ~= "" then
    return false
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return false
  end

  return vim.bo[bufnr].modified
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "TextChangedI", "BufLeave", "FocusLost" }, {
  group = group,
  callback = function(args)
    if can_save(args.buf) then
      vim.api.nvim_buf_call(args.buf, function()
        vim.cmd("silent! update")
      end)
    end
  end,
})
