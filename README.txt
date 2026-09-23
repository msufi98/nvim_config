How the files load

~/.config/nvim/init.lua is the only file Neovim runs on its own. It calls require("moiyyad"), which runs lua/moiyyad/init.lua. That file runs set, remap, then lazy_init, in that order. remap sets the leader key, and it has to run before lazy.nvim, because plugin files read <leader> at the moment they define mappings.

lua/moiyyad/init.lua

R(name) reloads a Lua module without restarting Neovim. Useful when editing your config: :lua R("moiyyad.remap").
The TextYankPost autocmd flashes yanked text for 40ms so you see what you copied.
The BufWritePre autocmd deletes trailing spaces from every line when you save.

set.lua — editor options

guicursor = "": block cursor in all modes.
nu + relativenumber: current line shows its real number, others show distance from the cursor. You read "7" and type 7j.
tabstop/softtabstop/shiftwidth = 4, expandtab: Tab inserts 4 spaces.
smartindent: auto-indents after { and similar.
wrap = false: long lines scroll sideways.
swapfile/backup off, undofile on: Neovim writes undo history to ~/.vim/undodir, so u still works after you close and reopen a file.
hlsearch off, incsearch on: search jumps as you type, and matches don't stay highlighted afterward.
termguicolors: 24-bit color. Colorschemes need it.
scrolloff = 8: keeps 8 lines visible above and below the cursor.
signcolumn = "yes": reserves the left gutter for error markers so text doesn't jump when one appears.
isfname:append("@-@"): gf (open file under cursor) treats @ as part of a filename, for paths like @scope/package.
updatetime = 50: how long Neovim waits after you stop typing before firing idle events. Faster diagnostics.
colorcolumn = "80": vertical line at column 80.

remap.lua — keymaps

<leader>pv: netrw file browser.
Visual J/K: move selected lines down/up, re-indenting as they go.
J (normal): joins the next line onto this one; the mz/`z part returns the cursor to where it started.
<C-d>/<C-u>, n/N: same as default, then zz recenters the screen.
Visual <leader>p: paste over a selection. Normal p would put the replaced text into your register; this sends it to _ (the black hole register) so your clipboard keeps what you copied.
<leader>y/<leader>Y: yank to system clipboard (+) instead of Neovim's internal register.
<leader>d: delete without overwriting your register.
<C-c> in insert: acts as Esc. Plain <C-c> skips some autocmds.
Q: disabled. Default enters Ex mode, which is easy to hit by accident.
<C-f>: tmux-sessionizer. Does nothing until you install tmux.
<C-k>/<C-j>: next/previous entry in the quickfix list (search results, compiler errors). <leader>k/<leader>j: same for the location list.
<leader>s: prefills :%s/word/word/gI with the word under the cursor, cursor placed on the replacement. Type the new name, Enter.
<leader>x: chmod +x the current file.

lazy_init.lua

Checks whether lazy.nvim exists in ~/.local/share/nvim/lazy/. If not, git clones it. Then tells it to load each file in lua/moiyyad/lazy/ as a plugin spec. Each spec file returns a table: the plugin's GitHub name, its dependencies, and a config function lazy runs after install.

Plugins

rose-pine: colorscheme. ColorMyPencils() sets the background to none so your terminal's background shows.
telescope: fuzzy finder. <leader>pf files, <C-p> files tracked by git, <leader>ps grep prompt, <leader>pws grep the word under cursor, <leader>vh search help docs.
treesitter: parses code into a syntax tree for accurate highlighting and indentation. ensure_installed lists the language parsers to compile; auto_install fetches others when you open that filetype.
harpoon: bookmarks up to 4 files. <leader>a adds the current file, <C-e> shows the list, <C-h>/<C-t>/<C-n>/<C-s> jump to slots 1–4. Faster than telescope for files you bounce between.
undotree: <leader>u shows undo history as a tree. Vim keeps branches when you undo then make a new edit; this lets you get back to them.
fugitive: git inside Neovim. <leader>gs opens status; s stages a file, cc commits.
trouble: <leader>tt lists all diagnostics in a panel. [t/]t jump between them.
zen-mode: <leader>zz centers the buffer at 90 columns and hides clutter. <leader>zZ also hides line numbers.

lsp.lua

mason: downloads language server binaries to ~/.local/share/nvim/mason/. :Mason to browse.
mason-lspconfig: installs the servers in ensure_installed and turns them on.
nvim-lspconfig: ships default settings for each server (command to run, how to find the project root).
vim.lsp.config("*", ...): applies nvim-cmp's completion settings to all servers. The lua_ls block tells the Lua server that vim is a known global, which stops warnings in your config files.
nvim-cmp + sources: the completion menu. <C-n>/<C-p> move, <C-y> accepts, <C-Space> opens it manually. Sources pull from the LSP, snippets, and words in the current buffer.
LuaSnip: snippet engine cmp needs to expand LSP snippets.
fidget: spinner in the corner while a language server starts up.
vim.diagnostic.config: shows errors inline at the end of the line, with a rounded border on popups.

Built-in 0.11 LSP keys: grn rename, gra code action, grr references, gri implementation, K hover docs. For manual format, <leader>f isn't in this config — Prime's version removed it. Add to remap.lua if you want it:

lua
vim.keymap.set("n", "<leader>f", vim.lsp)

tmux-commands
C-b % — split side by side
C-b " — split top and bottom
C-b + arrow key — move between panes
C-b z — zoom the current pane to full size and back
C-b x — close the current pane (or type exit)
