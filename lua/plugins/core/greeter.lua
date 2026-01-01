local get_config = function()
  local utils = require("alpha.utils")

  local path_ok, plenary_path = pcall(require, "plenary.path")
  if not path_ok then
    return
  end

  local dashboard = require("alpha.themes.dashboard")
  local if_nil = vim.F.if_nil

  local file_icons = {
    enabled = true,
    highlight = true,
    provider = "mini",
  }

  local function icon(fn)
    if file_icons.provider ~= "mini" then
      vim.notify("Alpha: Invalid file icons provider: " .. file_icons.provider .. ", disable file icons", vim.log.levels.WARN)
      file_icons.enabled = false
      return "", ""
    end

    local ico, hl = utils.get_file_icon(file_icons.provider, fn)
    if ico == "" then
      file_icons.enabled = false
      vim.notify("Alpha: Mini icons get icon failed, disable file icons", vim.log.levels.WARN)
    end
    return ico, hl
  end

  local function file_button(fn, sc, short_fn, autocd)
    short_fn = short_fn or fn
    local ico_txt
    local fb_hl = {}

    if file_icons.enabled then
      local ico, hl = icon(fn)
      local hl_option_type = type(file_icons.highlight)
      if hl_option_type == "boolean" then
        if hl and file_icons.highlight then
          table.insert(fb_hl, { hl, 0, #ico })
        end
      end
      if hl_option_type == "string" then
        table.insert(fb_hl, { file_icons.highlight, 0, #ico })
      end
      ico_txt = ico .. "  "
    else
      ico_txt = ""
    end
    local cd_cmd = (autocd and " | cd %:p:h" or "")
    local file_button_el =
      dashboard.button(sc, ico_txt .. short_fn, "<cmd>e " .. vim.fn.fnameescape(fn) .. cd_cmd .. " <CR>")
    local fn_start = short_fn:match(".*[/\\]")
    if fn_start ~= nil then
      table.insert(fb_hl, { "Keyword", #ico_txt - 2, #fn_start + #ico_txt })
    end
    file_button_el.opts.hl = fb_hl
    return file_button_el
  end

  local default_mru_ignore = { "gitcommit" }

  local mru_opts = {
    ignore = function(path, ext)
      return (string.find(path, "COMMIT_EDITMSG")) or (vim.tbl_contains(default_mru_ignore, ext))
    end,
    autocd = false,
  }

  local function mru(start, cwd, items_number, opts)
      opts = opts or mru_opts
      items_number = if_nil(items_number, 10)

      local oldfiles = {}
      for _, v in pairs(vim.v.oldfiles) do
          if #oldfiles == items_number then
              break
          end
          local cwd_cond
          if not cwd then
              cwd_cond = true
          else
              cwd_cond = vim.startswith(v, cwd)
          end
          local ignore = (opts.ignore and opts.ignore(v, utils.get_extension(v))) or false
          if (vim.fn.filereadable(v) == 1) and cwd_cond and not ignore then
              oldfiles[#oldfiles + 1] = v
          end
      end
      local target_width = 45 

      local tbl = {}
      for i, fn in ipairs(oldfiles) do
          local short_fn
          if cwd then
              short_fn = vim.fn.fnamemodify(fn, ":.")
          else
              short_fn = vim.fn.fnamemodify(fn, ":~")
          end

          if #short_fn > target_width then
              short_fn = plenary_path.new(short_fn):shorten(1, { -2, -1 })
              if #short_fn > target_width then
                  short_fn = plenary_path.new(short_fn):shorten(1, { -1 })
              end
          end

          local shortcut = tostring(i + start - 1)

          local file_button_el = file_button(fn, shortcut, short_fn, opts.autocd)
          tbl[i] = file_button_el
      end
      return {
          type = "group",
          val = tbl,
          opts = {},
      }
  end

  local header = {
      type = "text",
      val = {
        [[     s                                                                                      .         s   ]],
        [[    :8      .uef^"                 .uef^"                                                  @88>      :8   ]],
        [[   .88    :d88E                  :d88E                     .u    .      ..    .     :      %8P      .88   ]],
        [[  :888ooo `888E            .u    `888E            .u     .d88B :@8c   .888: x888  x888.     .      :888ooo]],
        [[-*8888888  888E .z8k    ud8888.   888E .z8k    ud8888.  ="8888f8888r ~`8888~'888X`?888f`  .@88u  -*8888888]],
        [[  8888     888E~?888L :888'8888.  888E~?888L :888'8888.   4888>'88"    X888  888X '888>  ''888E`   8888   ]],
        [[  8888     888E  888E d888 '88%"  888E  888E d888 '88%"   4888> '      X888  888X '888>    888E    8888   ]],
        [[  8888     888E  888E 8888.+"     888E  888E 8888.+"      4888>        X888  888X '888>    888E    8888   ]],
        [[ .8888Lu=  888E  888E 8888L       888E  888E 8888L       .d888L .+     X888  888X '888>    888E   .8888Lu=]],
        [[ ^%888*    888E  888E '8888c. .+  888E  888E '8888c. .+  ^"8888*"     "*88%""*88" '888!`   888&   ^%888*  ]],
        [[  'Y"    m888N= 888>  "88888%   m888N= 888>  "88888%       "Y"         `~    "    `"`     R888"    'Y"    ]],
        [[          `Y"   888     "YP'     `Y"   888     "YP'                                        ""             ]],
        [[               J88"                   J88"                                                                ]],
        [[               @%                     @%                                                                  ]],
        [[              :"                     :"                                                                   ]]
      },
      opts = {
        position = "center",
        hl = "Keyword",
      },
  }

  local section_mru = {
    type = "group",
    val = {
      {
        type = "text",
        val = "Recent files",
        opts = {
          hl = "Keyword",
          shrink_margin = false,
          position = "center",
        },
      },
      { type = "padding", val = 1 },
      {
        type = "group",
        val = function()
          return { mru(1, vim.fn.getcwd(), 6) }
        end,
        opts = { shrink_margin = false },
      },
    },
  }

   local buttons = {
    type = "group",
    val = {
      { type = "text", val = "Quick links", opts = { hl = "Keyword", position = "center" } },
      { type = "padding", val = 1 },
      dashboard.button("e",       "+ New file", "<cmd>ene<CR>"),
      dashboard.button("SPC p v", "≡ File explorer"),
      dashboard.button("SPC f f", "󰈞 Find file"),
      dashboard.button("SPC f g", "󰊄 Live grep"),
      dashboard.button("c",       "⚙️Configuration", '<cmd>lua require("yazi").yazi({}, ' .. 'vim.fn.stdpath("config"))' .. '<CR>'),
      dashboard.button("u",       "⬆️Update plugins", "<cmd>Lazy sync<CR>"),
      dashboard.button("q",       "󰅚 Quit", "<cmd>qa<CR>"),
    },
    position = "center",
  }

  local config = {
    layout = {
      { type = "padding", val = 2 },
      header,
      { type = "padding", val = 1 },
      section_mru,
      { type = "padding", val = 1 },
      buttons,
    },
    opts = {
      margin = 2,
      setup = function()
        vim.api.nvim_create_autocmd('DirChanged', {
          pattern = '*',
          group = "alpha_temp",
          callback = function ()
            require('alpha').redraw()
            vim.cmd('AlphaRemap')
          end,
          })
      end,
    },
  }

  return {
    header = header,
    buttons = buttons,
    mru = mru,
    config = config,
    mru_opts = mru_opts,
    leader = dashboard.leader,
    file_icons = file_icons,
    nvim_web_devicons = file_icons,
  }
end

return {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-mini/mini.icons",
      "nvim-lua/plenary.nvim"
    },
    config = function ()
      local greeter = get_config()
      require("alpha").setup(greeter.config)
    end
};
