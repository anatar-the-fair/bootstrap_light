-- ~/github/dotfiles-latest/neovim/neobean/lua/config/modules/mini-files-km.lualocal

-- ~/github/dotfiles-latest/neovim/neobean/lua/config/modules/mini-files-km.lua

local M = {}

M.setup = function(opts)
  -- Create an autocmd to set buffer-local mappings when a mini.files buffer is opened
  vim.api.nvim_create_autocmd("User", {
    -- Updated pattern to match what Echasnovski has in the documentation
    -- https://github.com/echasnovski/mini.nvim/blob/c6eede272cfdb9b804e40dc43bb9bff53f38ed8a/doc/mini-files.txt#L508-L529
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Import 'mini.files' module
      local mini_files = require("mini.files")

      -- Ensure opts.custom_keymaps exists
      local keymaps = opts.custom_keymaps or {}

      -- Open the highlighted directory in a tmux pane on the right
      vim.keymap.set("n", keymaps.open_tmux_pane, function()
        local curr_entry = mini_files.get_fs_entry()
        if curr_entry and curr_entry.fs_type == "directory" then
          require("config.keymaps").tmux_pane_function(curr_entry.path)
        else
          vim.notify("Not a directory or no entry selected", vim.log.levels.WARN)
        end
      end, { buffer = buf_id, noremap = true, silent = true })

      -- Copy current file/directory to system clipboard (macOS only)
      vim.keymap.set("n", keymaps.copy_to_clipboard, function()
        local curr_entry = mini_files.get_fs_entry()
        if curr_entry then
          local path = curr_entry.path
          local cmd = string.format([[osascript -e 'set the clipboard to POSIX file "%s"' ]], path)
          local result = vim.fn.system(cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("Copy failed: " .. result, vim.log.levels.ERROR)
          else
            vim.notify(vim.fn.fnamemodify(path, ":t"), vim.log.levels.INFO)
            vim.notify("Copied to system clipboard", vim.log.levels.INFO)
          end
        else
          vim.notify("No file or directory selected", vim.log.levels.WARN)
        end
      end, { buffer = buf_id, noremap = true, silent = true, desc = "[P] Copy file/directory to clipboard" })

      -- Zip current file/directory and copy to clipboard (macOS only)
      vim.keymap.set("n", keymaps.zip_and_copy, function()
        local curr_entry = mini_files.get_fs_entry()
        if curr_entry then
          local path = curr_entry.path
          local name = vim.fn.fnamemodify(path, ":t")
          local parent_dir = vim.fn.fnamemodify(path, ":h")
          local timestamp = os.date("%y%m%d%H%M%S")
          local zip_path = string.format("/tmp/%s_%s.zip", name, timestamp)
          local zip_cmd = string.format(
            "cd %s && zip -r %s %s",
            vim.fn.shellescape(parent_dir),
            vim.fn.shellescape(zip_path),
            vim.fn.shellescape(name)
          )
          local result = vim.fn.system(zip_cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to create zip file: " .. result, vim.log.levels.ERROR)
            return
          end
          local copy_cmd = string.format([[osascript -e 'set the clipboard to POSIX file "%s"' ]], vim.fn.fnameescape(zip_path))
          local copy_result = vim.fn.system(copy_cmd)
          if vim.v.shell_error ~= 0 then
            vim.notify("Failed to copy zip file to clipboard: " .. copy_result, vim.log.levels.ERROR)
            return
          end
          vim.notify(zip_path, vim.log.levels.INFO)
          vim.notify("Zipped and copied to clipboard", vim.log.levels.INFO)
        else
          vim.notify("No file or directory selected", vim.log.levels.WARN)
        end
      end, { buffer = buf_id, noremap = true, silent = true, desc = "[P] Zip and copy to clipboard" })

      -- Paste from system clipboard into current mini.files directory (macOS only)
      vim.keymap.set("n", keymaps.paste_from_clipboard, function()
        if not mini_files then
          vim.notify("mini.files module not loaded.", vim.log.levels.ERROR)
          return
        end
        local curr_entry = mini_files.get_fs_entry()
        if not curr_entry then
          vim.notify("Failed to retrieve current entry in mini.files.", vim.log.levels.ERROR)
          return
        end
        local curr_dir = curr_entry.fs_type == "directory" and curr_entry.path or vim.fn.fnamemodify(curr_entry.path, ":h")
        local script = [[
          tell application "System Events"
            try
              set theFile to the clipboard as alias
              set posixPath to POSIX path of theFile
              return posixPath
            on error
              return "error"
            end try
          end tell
        ]]
        local output = vim.fn.system("osascript -e " .. vim.fn.shellescape(script))
        if vim.v.shell_error ~= 0 or output:find("error") then
          vim.notify("Clipboard does not contain a valid file or directory.", vim.log.levels.WARN)
          return
        end
        local source_path = output:gsub("%s+$", "")
        if source_path == "" then
          vim.notify("Clipboard is empty or invalid.", vim.log.levels.WARN)
          return
        end
        local dest_path = curr_dir .. "/" .. vim.fn.fnamemodify(source_path, ":t")
        local copy_cmd = vim.fn.isdirectory(source_path) == 1 and { "cp", "-R", source_path, dest_path } or { "cp", source_path, dest_path }
        local result = vim.fn.system(copy_cmd)
        if vim.v.shell_error ~= 0 then
          vim.notify("Paste operation failed: " .. result, vim.log.levels.ERROR)
          return
        end
        mini_files.synchronize()
        vim.notify("Pasted successfully.", vim.log.levels.INFO)
      end, { buffer = buf_id, noremap = true, silent = true, desc = "[P] Paste from clipboard" })

      -- Copy relative path (to home) of current entry to clipboard
      vim.keymap.set("n", keymaps.copy_path, function()
        local curr_entry = mini_files.get_fs_entry()
        if curr_entry then
          local home_dir = vim.fn.expand("~")
          local relative_path = curr_entry.path:gsub("^" .. home_dir, "~")
          vim.fn.setreg("+", relative_path)
          vim.notify(vim.fn.fnamemodify(relative_path, ":t"), vim.log.levels.INFO)
          vim.notify("Path copied to clipboard", vim.log.levels.INFO)
        else
          vim.notify("No file or directory selected", vim.log.levels.WARN)
        end
      end, { buffer = buf_id, noremap = true, silent = true, desc = "[P] Copy relative path to clipboard" })
    end,
  })
end

return M


