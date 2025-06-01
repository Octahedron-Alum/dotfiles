vim.o.clipboard = "unnamedplus"

vim.g.clipboard = 'osc52'

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

