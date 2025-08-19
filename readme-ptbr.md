# Neovim como editor de códigos 
Conteúdo:
* [O que é Neovim?](#o-que-é-neovim)
* [Por que Neovim?](#por-que-neovim)
* [Instalando e criando pasta de configuração](#instalando-e-criando-pasta-de-configuração)
* [O que será feito?](#o-que-será-feito)
* [Criando a fundação](#criando-a-fundação)
* [Primeiras configurações](#primeiras-configurações)
* [Instalando o Package Manager de Plugins](#instalando-o-package-manager-de-plugins)
* [Implementando demais funcionalidades](#implementando-demais-funcionalidades)
	* [Mason](#mason)
	* [lspconfig](#lspconfig)
	* [Treesitter](#treesitter)
	* [Telescope](#telescope)
	* [Formatação de código](#formatação-de-código)
	* [Sugestão de código](#sugestão-de-código)
	* [Debug](#debug)

## O que é Neovim?
**Neovim** é um *fork* do Vim, editor de código open-source muito simples, prático e veloz, utilizado diretamente em um terminal de comandos.
Com o **Neovim** é possível utilizar Lua para realizar configurações no seu editor e até desenvolver plugins para aumentar as suas funcionalidade, com o intuito de criar um ambiente de desenvolvimento completamente customizado, se adequando ao gosto do usuário e não o contrário.

## Por que Neovim?
Quando um usuário instala uma *IDE* como JetBrains ou um Visual Studio, recebe um editor de código com diversas funcionalidades embutidas, entregando um pacote de desenvolvimento completo e pronto para começar, porém, ao utilizar o **Neovim** pela primeira vez, o usuário irá perceber que funcionalidades básicas como *syntax highlighting*, formatação de código, etc, não estarão lá por padrão, sendo necessários configurá-las manualmente.

**- Então porquê raios utilizar um editor de código como esses?**
E a minha resposta para esta pergunta é: customização, rapidez e um entendimento mais completo sobre as ferramentas de desenvolvimento!

## O que será feito?
Neste tutorial irei implementar algumas das funcionalidades que julgo como básicas de um editor e algumas opcionais, que dependem diretamente do gosto do usuário e do ambiente em que ele trabalha.

Dentre as funcionalidades, teremos:
* *Syntax highlighting*
* Formatação de código
* Sugestão de código
* *Telescope* para navegação e pesquisa
* Debugger
* Configuração inicial para LSPs
* *Package Manager* de Plugins
* *Package Manager* de LSPs, DAPs, Linters e Formatters

## Instalando e criando pasta de configuração
Para instalar o **Neovim**, basta utilizar o *package manager* da tua preferência, caso você esteja usando alguma distribuição Linux *Arch-based* assim como eu, basta utilizar o seguinte comando no teu terminal e seguir o passo-a-passo da instalação: `sudo pacman -S nvim`.
Para realizar a customização do **Neovim** é necessário criar uma pasta dentro do diretório de configuração `.config` padrão do Linux. Para tal, utilize o seguinte comando no terminal `mkdir ~/.config/nvim`.

## Criando a fundação
O **Neovim** carregar os seus arquivos de configuração através do arquivo `init.lua`  localizado na pasta de configuração no seguinte caminho: `~/.config/nvim`.
Dito isto, iremos utilizar este `init.lua` como arquivo de entrada para carregarmos nossas configurações, que estarão divididas em diversos arquivos classificados por funcionalidade, com intuito de manter uma boa organização.

```
.
├── init.lua
└── lua
    ├── autocmd.lua
    ├── editor.lua
    ├── lazy_init.lua
    ├── remap.lua
    └── plugins
        ├── dap
        │   ├── c.lua
        │   └── typescript.lua
        ├── completion.lua
        ├── dap.lua
        ├── formatter.lua
        ├── lsp.lua
        ├── mason.lua
        ├── telescope.lua
        ├── theme.lua
        └── treesitter.lua
```

Para criar todos os arquivos e pastas, basta utilizar o seguinte comando:
```
cd ~/.config/nvim &&
touch init.lua &&
mkdir ./lua &&
touch ./lua/autocmd.lua &&
touch ./lua/editor.lua &&
touch ./lua/lazy_init.lua &&
touch ./lua/remap.lua &&
mkdir ./lua/plugins &&
touch ./lua/plugins/completion.lua &&
touch ./lua/plugins/dap.lua &&
touch ./lua/plugins/formatter.lua &&
touch ./lua/plugins/lsp.lua &&
touch ./lua/plugins/mason.lua &&
touch ./lua/plugins/telescope.lua &&
touch ./lua/plugins/theme.lua &&
touch ./lua/plugins/treesitter.lua &&
mkdir ./lua/plugins/dap &&
touch ./lua/plugins/dap/c.lua &&
touch ./lua/plugins/dap/typescript.lua
```

O próximo passo é indicar no arquivo de entrada `init.lua` quais arquivos ele deve carregar ao iniciar o **Neovim**.
Para isso, basta dar um *require* nos módulos utilizados.

No meu caso, o meu arquivo `init.lua` ficou desta forma:
```
require("editor")
require("remap")
require("autocmd")
require("lazy_init")
```

## Primeiras configurações
Abaixo está as minhas configurações para os arquivos `remap.lua`, `editor.lua` e `autocmd.lua`.
O código acompanha comentário que explica as funcionalidades, caso o comando não seja auto-explicativo.

Caso você tenha interesse em aumentar ainda mais as funcionalidades, uma pesquisa no google ou uma olhada no [Quickrefs](https://neovim.io/doc/user/quickref.html#option-list) deve resolver o problema!

O arquivo `remap.lua` contempla as configurações relacionadas aos comandos e funcionalidades do **Neovim**, como por exemplo, escolher a tecla *leader*, comportamentos do *Vim Motion*, entre outros.

```remap.lua
vim.g.mapleader = " "
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Opens the file explorer
vim.keymap.set("n", "<leader>pv", "<cmd>Ex<CR>")

-- Move focus between panes
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")

-- Move while in insert mode
vim.keymap.set("i", "<C-b>", "<Esc>^i")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-l>", "<Right>")

-- Move visual selected block
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- Centering screen when moving page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Centering screen when navigating searched words
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without overwritting the yanked text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Comment/uncomment selected block
vim.keymap.set("n", "<leader>/", "gcc", { remap = true })
vim.keymap.set("v", "<leader>/", "gc", { remap = true })
```

O arquivo `editor.lua` reserva as configurações relacionadas ao editor, como por exemplo, a cor de fundo, *indentação*, numeração nas linhas, entre outros.

```editor.lua
vim.o.background = "dark"

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.opt.incsearch = true

-- Enables the in-line error/warning message
vim.diagnostic.config({ virtual_text = true })
```

Autocommands contém funções que são executadas quando um certo evento acontece. Algum destes eventos podem ser encontrado no tópico [autocmd da documentação](https://neovim.io/doc/user/autocmd.html) .

Aqui no meu arquivo eu tenho três funcionalidades: 
1. Marcação do texto copiado ao realizar o *Yank* (cópia).
2. *Yanks* no Neovim são copiados na área de transferência do Windows, funcionalidade que não vem por padrão ao utilizar WSL2.

```autocmd.lua
-- Highlight on yank
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- (WSL) Yank directly to Window's clipboard
local clip = "/mnt/c/Windows/System32/clip.exe"
if vim.fn.executable(clip) then
  local opts = {
    callback = function()
      if vim.v.event.operator ~= "y" then
        return
      end
      vim.fn.system(clip, vim.fn.getreg(0))
    end,
  }
  opts.group = vim.api.nvim_create_augroup("WSLYank", {})
  vim.api.nvim_create_autocmd("TextYankPost", { group = opts.group, callback = opts.callback })
end
```

## Instalando o *Package Manager* de Plugins
Para carregar dependências terceiras de uma forma fácil, eu utilizo o *Package Manager* [lazy.nvim](https://github.com/folke/lazy.nvim).\
*Obs: lazy.nvim e LazyVim são coisas distintas, portanto há uma possibilidade de confusão ao verificar as documentações destes pacotes.*

Para realizar a implementação do lazy.nvim basta copiar o código a seguir para dentro do nosso arquivo `lazy_init.lua` e reiniciar o **Neovim**.

```lazy_init.lua
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)


-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  checker = { enabled = true },
})

```
Basicamente este código baixa o pacote diretamente do repositório do GitHub, caso já não tenha sido baixado anteriormente, realiza o carregamento e o setup do **lazy.nvim**, importando os arquivos `init.lua` que estão dentro dos subdiretórios encontrados dentro do diretório `plugins`.

## Implementando demais funcionalidades
Agora que temos o **lazy.nvim** instalado, conseguimos prosseguir para a instalação das demais funcionalidades através de plugins!

### Mason
O [Mason](https://github.com/mason-org/mason.nvim) é um *package manager* para instalar e gerenciar LSPs, DAPs, linters e formatadores diretamente no Neovim. Ele simplifica a instalação de ferramentas externas, garantindo que estejam disponíveis para uso com outros plugins, como `nvim-lspconfig` e `nvim-dap`.

Para evitar a instalação dos pacotes de forma manual, utilizo o [mason-tool-installer](https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim), que possibilita uma fácil migração das configuração para diferentes setups.

```plugins/mason.lua
return {
  "williamboman/mason.nvim",
  config = true,
  dependencies = {
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = {
          "lua_ls",
          "clangd",
          "typescript-language-server",
          "stylua",
          "clang-format",
          "prettier",
          "eslint_d",
          "codelldb",
          "js-debug-adapter"
        },
        auto_update = true,
        run_on_start = true,
        start_delay = 1000,
      },
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim"
      }
    }
  }
}
```

### lspconfig
O [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) fornece configurações prontas para servidores LSP, permitindo suporte para algumas funcionalidades padrões.

```plugins/lsp.lua
return {
  "neovim/nvim-lspconfig",
  lazy = false,
  dependencies = {
    "hrsh7th/cmp-nvim-lsp"
  },
  keys = {
    { "gd", vim.lsp.buf.definition, { silent = true } },
    { "gr", vim.lsp.buf.references },
    { "K", vim.lsp.buf.hover },
    { "<leader>r", function(replace_with) vim.lsp.buf.rename(replace_with) end }
  },
  config = function()
    local lspconfig = require("lspconfig")
    local default_capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

    lspconfig.lua_ls.setup {
      capabilities = default_capabilities
    }

    lspconfig.clangd.setup {
      capabilities = default_capabilities,
      cmd = { "clangd", "--background-index", "--log=verbose" },
    }

    lspconfig.ts_ls.setup {
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities),
    }
  end
}
```

### Treesitter
[Treesitter](https://github.com/nvim-treesitter/nvim-treesitter) é uma biblioteca geradora de *parsers* e de *parsing* incremental que cria em tempo real uma árvore de syntax do código que está sendo escrito. **Treesitter** possibilita um universo completo de funcionalidades, mas ela será responsável pelo *syntax highlighting* do nosso código.

```plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  opts = {
    ensure_installed = {
      "vimdoc",
      "markdown",
      "markdown_inline",
      "bash",
      "lua",
      "c",
      "cpp",
      "make",
      "cmake",
      "javascript",
      "typescript",
      "tsx",
      "html",
      "css",
      "prisma",
      "http",
      "json",
      "graphql",
      "editorconfig",
      "gitignore"
    },
    auto_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    }
  }
}
```

### Telescope
O [Telescope](https://github.com/nvim-telescope/telescope.nvim) é um fuzzy finder extremamente modulável e altamente customizável.
A seguinte configuração contempla as seguintes funcionalidades:
1. Abrir arquivos.
2. Navegar entre *buffers* carregados.
3. Fazer pesquisa de sentenças no código.
4. Navegar entre arquivos git.
5. Pesquisar help tags.

```plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  opts = {
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--color", "never", "--no-require-git" }
      }
    }
  },
  keys = {
    { "<leader>ff", function() require("telescope.builtin").find_files() end },
    { "<leader>fa", function() require("telescope.builtin").find_files({ follow = true, no_ignore = true, hidden = true }) end },
    { "<leader>fg", function() require("telescope.builtin").git_files() end },
    { "<leader>fw", function() require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ") }) end },
    { "<leader>fh", function() require("telescope.builtin").help_tags() end },
    { "<Tab>", function() require("telescope.builtin").buffers() end },
  }
}
```

### Formatação de código
Para formatação do código, utilizo o [Conform](https://github.com/stevearc/conform.nvim) com a seguinte configuração:
*obs: adeque a configuração à sua necessidade, incluindo formatações em filetypes que você trabalha ou removendo os que não trabalha.*

```plugins/formatter.lua
return {
  {
    "windwp/nvim-autopairs",
    opts = {
      map_cr = true
    }
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        { lua = "stylua" },
        { c = "clang-format" },
        { cpp = "clang-format" },
        { cmake = "cmake-format" },
        { html = "prettier" },
        { css = "prettier" },
        { javascript = "prettier" },
        { typescript = "prettier" },
        { tsx = "prettier" },
        { prisma = "prisma" },
        { json = "prettier" },
        { graphql = "prettier" },
        { markdown = "prettier" },
        { markdown_inline = "prettier" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      }
    },
    keys = {
      { "<leader>i", function() require("conform").format({ async = true, lsp_fallack = true })  end}
    }
  }
}
```

### Sugestão de código
Para sugestão de código e snippets, utilizo o [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) com a seguinte configuração:

```plugins/completion.lua
return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip"
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-c>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(
          function(fallback)
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif cmp.visible() then
            cmp.select_next_item()
          else
            fallback()
          end
        end,
        { "i", "s" }),
      }),
      sources = cmp.config.sources(
        {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
        {
          { name = "buffer" },
        }),
    })
  end,
}
```

### Debug
Para criar um ambiente de debugging, utilizo os plugins [nvim-dap](https://github.com/mfussenegger/nvim-dap) e [nvim-dap-ui](https://github.com/rcarriga/nvim-dap-ui). Enquanto o `nvim-dap` gerencia  *Debugging Adapters Protocols*, o `nvim-dap-ui` fornece a interface visual para visualizarmos os dados e definirmos alguns parâmetros durante a depuração.

```plugins/dap.lua
return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
  },
  keys = {
    { "<leader>dd", function() require("dapui").toggle({}) end },
    { "<leader>db", function() require("dap").toggle_breakpoint() end },
    { "<F5>",       function() require("dap").continue() end },
    { "<F6>",       function() require("dap").step_into() end },
    { "<F7>",       function() require("dap").step_over() end },
    { "<F8>",       function() require("dap").step_out() end },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("plugins.dap-typescript").setup(dap)
    require("plugins.dap-c").setup(dap)

    dapui.setup()

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end
}
```

Para manter a organização, eu separo os blocos de configurações dos *Debug Adapters* em arquivos separados, para facilitar na inclusão de novas configurações sem alterar as configurações do `nvim-dap` e `nvim-dap-ui`.

```plugins/dap/typescript.lua
return {
  setup = function(dap)
    local debug_adapter_path = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

    for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "pwa-extensionHost", }) do
      dap.adapters[adapter] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            debug_adapter_path,
            "${port}"
          },
        },
      }
    end

    for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        }
      }
    end
  end
}
```

```plugins/dap/c.lua
return {
  setup = function(dap)
    local debugger_path = vim.fn.exepath("codelldb")

    dap.adapters.codelldb = {
      type = "server",
      port = "${port}",
      executable = {
        command = debugger_path,
        args = { "--port", "${port}" },
      }
    }

    for _, language in ipairs({ "c", "cpp" }) do
      dap.configurations[language] = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            local exe_path = vim.fn.glob(vim.fn.getcwd() .. "/build/*") or vim.fn.glob(vim.fn.getcwd() .. "/bin/*")
            if exe_path ~= "" then
              return exe_path
            else
              return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/build/", "file")
            end
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {}
        },
      }
    end
  end
}
```
