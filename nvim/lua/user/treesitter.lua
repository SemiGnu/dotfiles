local config_status_ok, configs = pcall(require, 'nvim-treesitter.configs')
if not config_status_ok then
  return
end

configs.setup {
  ensure_installed = 'all',
  sync_install = false,
  ignore_install = { '' }, -- List of parsers to ignore installing
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { '' }, -- list of language that will be disabled
    additional_vim_regex_highlighting = true,

  },
  indent = { enable = true, disable = { 'yaml' } },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
}

local cc_status_ok, context_commentstring = pcall(require, 'ts_context_commentstring')
if not cc_status_ok then
  return
end

context_commentstring.setup {
  enable = true,
  enable_autocmd = true,
}

