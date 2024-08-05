local status_ok, _ = pcall(require, 'lspconfig')
if not status_ok then
  print 'lol no lspconfig'
  return
end

require('user.lsp.lsp-installer')
require('user.lsp.handlers').setup()

