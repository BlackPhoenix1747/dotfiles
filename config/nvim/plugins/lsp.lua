local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local util = require("lspconfig/util")
local function on_attach(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true)
	end
end
lspconfig.nixd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "nixd" },
	filetypes = { "nix" },
	settings = {
		nixd = {
			autowatch = true,
			nixpkgs = {
				expr = 'imprt (builtins.getFlake "/home/cylis/cylisos").inputs.nixpkgs { }',
			},
			formatting = {
				command = { "nixfmt" },
			},
			options = {
				nixos = {
					expr = '(builtins.getFlake "/home/cylis/cylisos/").nixosConfigurations.based.options',
				},
			},
		},
	},
})
lspconfig.gopls.setup({
	capabiltes = capabilites,
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_dir = util.root_pattern("go.work", "go.mod", ".git"),
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = {
				unusedPArams = true,
			},
		},
	},
})
lspconfig.harper_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		["harper-ls"] = {
			linters = {
				spell_check = true,
				spelled_numbers = false,
				an_a = true,
				sentence_capitalization = true,
				unclosed_quotes = true,
				wrong_quotes = true,
				long_sentences = true,
				repeated_words = true,
				spaces = true,
				matcher = true,
				correct_number_suffix = true,
				number_suffix_capitalization = true,
				multiple_sequential_pronouns = true,
				linking_verbs = true,
				avoid_curses = false,
				terminating_conjuctions = true,
			},
		},
	},
})

lspconfig.html.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.basedpyright.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.marksman.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.rust_analyzer.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.yamlls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.bashls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.zls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.astro.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.clangd.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.denols.setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
lspconfig.elixirls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	cmd = { "elixir-ls" },
})
lspconfig.ts_ls.setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	cmd = { "typescript-language-server", "--stdio" },
})

vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { desc = "Hovering definition" })
vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Definition" })
vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, { desc = "Code Action" })
