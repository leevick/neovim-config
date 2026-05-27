# Neovim Config

**Leader key:** `Space`

## Keybindings

### General

| Key          | Mode     | Action                  |
| ------------ | -------- | ----------------------- |
| `<C-s>`      | n/i/v    | Save                    |
| `<leader>fm` | n        | Format buffer           |
| `<leader>fm` | v/V/`^V` | Format selection        |
| `<leader>mp` | n        | Markdown preview toggle |

### SSHFS

| Key          | Action                  |
| ------------ | ----------------------- |
| `<leader>mm` | Mount SSH host          |
| `<leader>mu` | Unmount SSH host        |
| `<leader>mU` | Unmount all SSH hosts   |
| `<leader>me` | Explore mounted path    |
| `<leader>md` | Change to mount dir     |
| `<leader>mo` | Run command on mount    |
| `<leader>mc` | Edit SSH config         |
| `<leader>mr` | Reload SSH config       |
| `<leader>mf` | Browse remote files     |
| `<leader>mg` | Grep mounted files      |
| `<leader>mF` | Live find over SSH      |
| `<leader>mG` | Live grep over SSH      |
| `<leader>mt` | Open SSH terminal       |

### LSP — buffer-local on attach

| Key          | Action                 |
| ------------ | ---------------------- |
| `gd`         | Go to definition       |
| `gi`         | Go to implementation   |
| `gy`         | Go to type definition  |
| `gr`         | References             |
| `K`          | Hover docs             |
| `<leader>rn` | Rename                 |
| `<leader>ca` | Code action            |
| `<leader>e`  | Show diagnostics float |
| `]d` / `[d`  | Next / prev diagnostic |

### Telescope

| Key                    | Action            |
| ---------------------- | ----------------- |
| `<leader>ff` / `<C-p>` | Find files        |
| `<leader>fg`           | Live grep         |
| `<leader>fb`           | Buffers           |
| `<leader>fh`           | Help tags         |
| `<leader>fo`           | Recent files      |
| `<leader>fr`           | LSP references    |
| `<leader>fs`           | Document symbols  |
| `<leader>fw`           | Workspace symbols |
| `<leader>fd`           | Diagnostics       |
| `<leader>fc`           | Git commits       |

### Gitsigns — buffer-local on attach

| Key                         | Mode | Action               |
| --------------------------- | ---- | -------------------- |
| `]h` / `[h`                 | n    | Next / prev hunk     |
| `<leader>hs` / `<leader>hr` | n/v  | Stage / reset hunk   |
| `<leader>hS` / `<leader>hR` | n    | Stage / reset buffer |
| `<leader>hu`                | n    | Undo stage hunk      |
| `<leader>hp`                | n    | Preview hunk         |
| `<leader>hb`                | n    | Blame line           |
| `<leader>hd`                | n    | Diff this            |

### Fugitive

| Key          | Action            |
| ------------ | ----------------- |
| `<leader>gs` | Git status        |
| `<leader>gd` | Git diff (vsplit) |
| `<leader>gb` | Git blame         |
| `<leader>gl` | Git log           |

### nvim-cmp — insert mode

| Key                          | Action                        |
| ---------------------------- | ----------------------------- |
| `<C-Space>` / `<C-n>`        | Trigger completion            |
| `<Tab>` / `<C-j>` / `<Down>` | Next item / expand snippet    |
| `<S-Tab>` / `<C-k>` / `<Up>` | Prev item / jump snippet back |
| `<CR>`                       | Confirm                       |
| `<C-e>` / `<Esc>`            | Abort                         |
| `<C-d>` / `<C-f>`            | Scroll docs up / down         |

### Copilot — insert mode (plugin defaults)

| Key               | Action                 |
| ----------------- | ---------------------- |
| `<Tab>`           | Accept suggestion      |
| `<M-]>` / `<M-[>` | Next / prev suggestion |
| `<C-]>`           | Dismiss                |

## Plugins

| Plugin                                                                               | Purpose                              |
| ------------------------------------------------------------------------------------ | ------------------------------------ |
| [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                           | LSP client configuration             |
| [mason.nvim](https://github.com/williamboman/mason.nvim)                             | LSP/tool installer                   |
| [mason-lspconfig](https://github.com/williamboman/mason-lspconfig.nvim)              | Mason + lspconfig bridge             |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                                      | Completion engine                    |
| [LuaSnip](https://github.com/L3MON4D3/LuaSnip)                                       | Snippet engine                       |
| [conform.nvim](https://github.com/stevearc/conform.nvim)                             | Formatter                            |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                   | Fuzzy finder                         |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                          | Git hunk indicators                  |
| [vim-fugitive](https://github.com/tpope/vim-fugitive)                                | Git integration                      |
| [copilot.vim](https://github.com/github/copilot.vim)                                 | GitHub Copilot                       |
| [markdown-preview.nvim](https://github.com/iamcco/markdown-preview.nvim)             | Browser preview with Mermaid support |
| [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim) | Inline markdown rendering in Neovim  |
| [sshfs.nvim](https://github.com/uhs-robert/sshfs.nvim)                               | SSHFS remote mounts and SSH actions  |

## SSHFS Notes

- Requires `sshfs` to be installed on the system.
- Uses Telescope as the preferred local and remote picker.
- Reads hosts from your existing `~/.ssh/config`.

## LSP Servers

| Language                | Server  | Formatter              |
| ----------------------- | ------- | ---------------------- |
| C / C++                 | clangd  | clangd                 |
| Python                  | pyright | ruff                   |
| Verilog / SystemVerilog | verible | verible-verilog-format |
| Markdown                | —       | prettier               |
