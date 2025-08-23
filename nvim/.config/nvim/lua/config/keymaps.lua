local M = {}

-- Basic Keyboard Shortcuts (Existing Normal-Mode Mappings)

vim.keymap.set("n", "<leader>tv", ":terminal<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>c", ":close<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>ll", ":Lazy <CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>a", ":Alpha<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>tp", ":SoftPencil<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>tz", ":ZenMode<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>tg", ":Goyo<CR>", { noremap = true, silent = true})

-- Normal mode toggle comment
vim.keymap.set("n", "<leader><Tab>", function()
  require("Comment.api").toggle.linewise.current()
end, { noremap = true, silent = true, desc = "Toggle Comment" })

-- Visual mode toggle comment
vim.keymap.set("v", "<leader><Tab>", function()
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, { noremap = true, silent = true, desc = "Toggle Comment" })


-- Select the hunk under the cursor, excluding trailing blank line
vim.keymap.set("n", "<M-2>", function()
  require("mini.diff").textobject()
  -- Get the current line content
  local current_line = vim.api.nvim_get_current_line()
  -- If we're on a blank line, move up
  if current_line == "" then
    vim.cmd("normal! k")
  end
end, { desc = "Select Current Hunk in Visual Mode" })

-- Restart Neovim
vim.keymap.set({ "n", "v", "i" }, "<M-R>", function()
  -- Save all modified buffers, autosave may not have kicked in sometimes
  vim.cmd("wall")
  -- Check if a right pane exists, if it does close it
  local has_panes = vim.fn.system("tmux list-panes | wc -l"):gsub("%s+", "") ~= "1"
  if has_panes then
    vim.fn.system("tmux kill-pane -t :.+")
  end
  os.execute('open "btt://execute_assigned_actions_for_trigger/?uuid=481BDF1F-D0C3-4B5A-94D2-BD3C881FAA6F"')
end, { desc = "Restart Neovim via BTT" })

-- Disable this keymap overriding it with a no-operation function (noop)
-- Otherwise when by mistake press <M-r> to restart neovim, it does "r" to
-- replace
vim.keymap.set({ "n", "v", "i" }, "<M-r>", "<Nop>", { desc = " Disabled No operation for <M-r>" })

-- By default, CTRL-U and CTRL-D scroll by half a screen (50% of the window height)
-- Scroll by 35% of the window height and keep the cursor centered
local scroll_percentage = 0.35
-- Scroll by a percentage of the window height and keep the cursor centered
vim.keymap.set("n", "<C-d>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
  vim.cmd("normal! " .. lines .. "jzz")
end, { noremap = true, silent = true })
vim.keymap.set("n", "<C-u>", function()
  local lines = math.floor(vim.api.nvim_win_get_height(0) * scroll_percentage)
  vim.cmd("normal! " .. lines .. "kzz")
end, { noremap = true, silent = true })

-- Quit or exit neovim, easier than to do <leader>qq
vim.keymap.set({ "n", "v", "i" }, "<M-q>", "<cmd>wqa<cr>", { desc = "Quit All" })

vim.keymap.set({ "n", "v", "i" }, "<M-h>", function()
  -- require("noice").cmd("history")
  require("noice").cmd("all")
end, { desc = "Noice History" })

-- Dismiss noice notifications
vim.keymap.set({ "n", "v", "i" }, "<M-d>", function()
  require("noice").cmd("dismiss")
end, { desc = "Dismiss All" })

vim.keymap.set("n", "<leader>uk", '<cmd>lua require("kubectl").toggle()<cr>', { noremap = true, silent = true })

-- use gh to move to the beginning of the line in normal mode
-- use gl to move to the end of the line in normal mode
vim.keymap.set({ "n", "v" }, "gh", "^", { desc = "Go to the beginning line" })
vim.keymap.set({ "n", "v" }, "gl", "$", { desc = "Go to the end of the line" })
--

-- In visual mode, after going to the end of the line, come back 1 character
vim.keymap.set("v", "gl", "$h", { desc = "Go to the end of the line" })

-- -- yank selected text into system clipboard
-- -- Vim/Neovim has two clipboards: unnamed register (default) and system clipboard.
-- --
-- -- Yanking with `y` goes to the unnamed register, accessible only within Vim.
-- -- The system clipboard allows sharing data between Vim and other applications.
-- -- Yanking with `"+y` copies text to both the unnamed register and system clipboard.
-- -- The `"+` register represents the system clipboard.
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to system clipboard" })

-- yank/copy to end of line
vim.keymap.set("n", "Y", "y$", { desc = "Yank to end of line" })

-- Move lines up and down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down in visual mode" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up in visual mode" })

-- When you do joins with J it will keep your cursor at the beginning instead of at the end
vim.keymap.set("n", "J", "mzJ`z")

-- When searching for stuff, search results show in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Launch, limiting search/replace to current file
-- https://github.com/MagicDuck/grug-far.nvim?tab=readme-ov-file#-cookbook
vim.keymap.set(
  { "v" },
  "<leader>s1",
  '<cmd>lua require("grug-far").open({ prefills = { paths = vim.fn.expand("%") } })<cr>',
  { noremap = true, silent = true }
)

-- Replaces the word I'm currently on, opens a terminal so that I start typing the new word
-- It replaces the word globally across the entire file
vim.keymap.set(
  "n",
  "<leader>su",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Replace word I'm currently on GLOBALLY" }
)

-- Toggle executable permission on current file, previously I had 2 keymaps, to
-- add or remove exec permissions, now it's a toggle using the same keymap
vim.keymap.set("n", "<leader>fx", function()
  local file = vim.fn.expand("%")
  local perms = vim.fn.getfperm(file)
  local is_executable = string.match(perms, "x", -1) ~= nil
  local escaped_file = vim.fn.shellescape(file)
  if is_executable then
    vim.cmd("silent !chmod -x " .. escaped_file)
    vim.notify("Removed executable permission", vim.log.levels.INFO)
  else
    vim.cmd("silent !chmod +x " .. escaped_file)
    vim.notify("Added executable permission", vim.log.levels.INFO)
  end
end, { desc = "Toggle executable permission" })

-- If this is a bash script, make it executable, and execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>cb", function()
  local file = vim.fn.expand("%") -- Get the current file name
  local first_line = vim.fn.getline(1) -- Get the first line of the file
  if string.match(first_line, "^#!/") then -- If first line contains shebang
    local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands
    -- Execute the script on a tmux pane on the right. On my mac I use zsh, so
    -- running this script with bash to not execute my zshrc file after
    -- vim.cmd("silent !tmux split-window -h -l 60 'bash -c \"" .. escaped_file .. "; exec bash\"'")
    -- `-l 60` specifies the size of the tmux pane, in this case 60 columns
    vim.cmd(
      "silent !tmux split-window -h -l 60 'bash -c \""
        .. escaped_file
        .. "; echo; echo Press any key to exit...; read -n 1; exit\"'"
    )
  else
    vim.cmd("echo 'Not a script. Shebang line not found.'")
  end
end, { desc = "BASH, execute file" })

-- If this is a .go file, execute it in a tmux pane on the right
-- Using a tmux pane allows me to easily select text
-- Had to include quotes around "%" because there are some apple dirs that contain spaces, like iCloud
vim.keymap.set("n", "<leader>cg", function()
  local file = vim.fn.expand("%") -- Get the current file name
  if string.match(file, "%.go$") then -- Check if the file is a .go file
    local file_dir = vim.fn.expand("%:p:h") -- Get the directory of the current file
    -- local escaped_file = vim.fn.shellescape(file) -- Properly escape the file name for shell commands
    -- local command_to_run = "go run " .. escaped_file
    local command_to_run = "go run *.go"
    -- `-l 60` specifies the size of the tmux pane, in this case 60 columns
    local cmd = "silent !tmux split-window -h -l 60 'cd "
      .. file_dir
      .. ' && echo "'
      .. command_to_run
      .. '\\n" && bash -c "'
      .. command_to_run
      .. "; echo; echo Press enter to exit...; read _\"'"
    vim.cmd(cmd)
  else
    vim.cmd("echo 'Not a Go file.'") -- Notify the user if the file is not a Go file
  end
end, { desc = "GOLANG, execute file" })

-- HACK: Neovim Toggle Terminal on Tmux Pane at the Bottom (or Right)
-- https://youtu.be/33gQ9p-Zp0I
--
-- Toggle a tmux pane on the right in zsh, in the same directory as the current file
--
-- Notice I'm setting the variable DISABLE_PULL=1, because in my zshrc file,
-- I check if this variable is set, if it is, I don't pull github repos, to save time
--
-- I keep track of the opened dir lamw25wmal, and if it changes, the next time I
-- bring up the tmux pane, it will open the path of the new dir
--
-- I defined it as a function, because I call this function from the
-- mini.files plugin to open the highlighted dir in a tmux pane on the right
M.tmux_pane_function = function(dir)
  -- NOTE: variable that controls the auto-cd behavior
  local auto_cd_to_new_dir = true
  -- NOTE: Variable to control pane direction: 'right' or 'bottom'
  -- If you modify this, make sure to also modify TMUX_PANE_DIRECTION in the
  -- zsh-vi-mode section on the .zshrc file
  -- Also modify this in your tmux.conf file if you want it to work when in tmux
  -- copy-mode
  local pane_direction = vim.g.tmux_pane_direction or "right"
  -- NOTE: Below, the first number is the size of the pane if split horizontally,
  -- the 2nd number is the size of the pane if split vertically
  local pane_size = (pane_direction == "right") and 60 or 15
  local move_key = (pane_direction == "right") and "C-l" or "C-k"
  local split_cmd = (pane_direction == "right") and "-h" or "-v"
  -- if no dir is passed, use the current file's directory
  local file_dir = dir or vim.fn.expand("%:p:h")
  -- Simplified this, was checking if a pane existed
  local has_panes = vim.fn.system("tmux list-panes | wc -l"):gsub("%s+", "") ~= "1"
  -- Check if the current pane is zoomed (maximized)
  local is_zoomed = vim.fn.system("tmux display-message -p '#{window_zoomed_flag}'"):gsub("%s+", "") == "1"
  -- Escape the directory path for shell
  local escaped_dir = file_dir:gsub("'", "'\\''")
  -- If any additional pane exists
  if has_panes then
    if is_zoomed then
      -- Compare the stored pane directory with the current file directory
      if auto_cd_to_new_dir and vim.g.tmux_pane_dir ~= escaped_dir then
        -- If different, cd into the new dir
        vim.fn.system("tmux send-keys -t :.+ 'cd \"" .. escaped_dir .. "\"' Enter")
        -- Update the stored directory to the new one
        vim.g.tmux_pane_dir = escaped_dir
      end
      -- If zoomed, unzoom and switch to the correct pane
      vim.fn.system("tmux resize-pane -Z")
      vim.fn.system("tmux send-keys " .. move_key)
    else
      -- If not zoomed, zoom current pane
      vim.fn.system("tmux resize-pane -Z")
    end
  else
    -- Store the initial directory in a Neovim variable
    if vim.g.tmux_pane_dir == nil then
      vim.g.tmux_pane_dir = escaped_dir
    end
    -- If no pane exists, open it with zsh and DISABLE_PULL variable
    vim.fn.system(
      "tmux split-window "
        .. split_cmd
        .. " -l "
        .. pane_size
        .. " 'cd \""
        .. escaped_dir
        .. "\" && DISABLE_PULL=1 zsh'"
    )
    vim.fn.system("tmux send-keys " .. move_key)
    -- Resolve zsh-vi-mode issue for first-time pane
    vim.fn.system("tmux send-keys Escape i")
  end
end
-- If I execute the function without an argument, it will open the dir where the
-- current file lives
vim.keymap.set({ "n", "v", "i" }, "<M-t>", function()
  M.tmux_pane_function()
end, { desc = "Terminal on tmux pane" })

-- This will add 3 lines:
-- 1. File path with the wordname Filename: first, then the path, and Go project name
-- 2. Just the filepath
-- 3. Name that I will use with `go mod init`
vim.keymap.set({ "n", "v", "i" }, "<M-z>", function()
  local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
  local fileName = vim.fn.expand("%:t") -- Gets the name of the file
  local goProjectPath = filePath:gsub("^~/", ""):gsub("/[^/]+$", "") -- Removes the ~/ at the start and the filename at the end
  -- Add .com to github and insert username
  goProjectPath = goProjectPath:gsub("github", "github.com/anatar-the-fair")
  -- Add "go mod init" to the beginning
  goProjectPath = "go mod init " .. goProjectPath
  local lineToInsert = "Filename: " .. filePath
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0)) -- Get the current row number
  -- Insert line with 'Filename: ' and insert blank lines right after
  vim.api.nvim_buf_set_lines(0, row - 1, row - 0, false, { lineToInsert })
  vim.api.nvim_buf_set_lines(0, row, row, false, { "" }) -- blank line
  vim.api.nvim_buf_set_lines(0, row, row, false, { "" }) -- blank line
  vim.api.nvim_buf_set_lines(0, row, row, false, { "" }) -- blank line
  -- Insert second line with just the path
  vim.api.nvim_buf_set_lines(0, row, row + 1, false, { filePath })
  -- Check if the file is a main.go file
  if fileName == "main.go" then
    -- Insert third line with the Go project name
    vim.api.nvim_buf_set_lines(0, row + 1, row + 2, false, { goProjectPath })
    vim.cmd("normal! V2j")
    vim.cmd("normal gcc")
  else
    vim.cmd("normal! V1j")
    vim.cmd("normal gcc")
  end
end, { desc = "Insert filename with path and go project name at cursor" })

-- I save a lot, and normally do it with `:w<CR>`, but I guess this will be
-- easier on my fingers
-- Original lazyvim.org keymap for this was "Other Window", but I never used it
vim.keymap.set("n", "<M-w>", function()
  vim.cmd("write")
end, { desc = "Write current file" })

-- ############################################################################

-- Set up a keymap to refresh the current buffer
vim.keymap.set("n", "<leader>br", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  print("Buffer reloaded")
end, { desc = "Reload current buffer" })

-- Function to copy file path to clipboard
local function copy_filepath_to_clipboard()
  local filePath = vim.fn.expand("%:~") -- Gets the file path relative to the home directory
  vim.fn.setreg("+", filePath) -- Copy the file path to the clipboard register
  vim.notify(filePath, vim.log.levels.INFO)
  vim.notify("Path copied to clipboard: ", vim.log.levels.INFO)
end
-- Keymaps for copying file path to clipboard
-- vim.keymap.set("n", "<leader>fp", copy_filepath_to_clipboard, { desc = "Copy file path to clipboard" })
-- I couldn't use <M-p> because its used for previous reference
vim.keymap.set({ "n", "v", "i" }, "<M-c>", copy_filepath_to_clipboard, { desc = "Copy file path to clipboard" })


-- Copy the current line and all diagnostics on that line to system clipboard
vim.keymap.set("n", "yd", function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line_num = pos[1] - 1 -- 0-indexed
  local line_text = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
  local diagnostics = vim.diagnostic.get(0, { lnum = line_num })
  if #diagnostics == 0 then
    vim.notify("No diagnostic found on this line", vim.log.levels.WARN)
    return
  end
  local message_lines = {}
  for _, d in ipairs(diagnostics) do
    for msg_line in d.message:gmatch("[^\n]+") do
      table.insert(message_lines, msg_line)
    end
  end
  local formatted = {}
  table.insert(formatted, "Line:\n" .. line_text .. "\n")
  table.insert(formatted, "Diagnostic on that line:\n" .. table.concat(message_lines, "\n"))
  vim.fn.setreg("+", table.concat(formatted, "\n\n"))
  vim.notify("Line and diagnostic copied to clipboard", vim.log.levels.INFO)
end, { desc = "Yank line and diagnostic to system clipboard" })

-- See the comment in the keymap
local function md_inline_calculator(auto_trigger)
  local line = vim.api.nvim_get_current_line()
  local cursor_col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- 1-based column
  local mode = vim.api.nvim_get_mode().mode
  local expressions = {}
  -- Find all backtick-enclosed expressions
  local start_idx = 1
  while true do
    local expr_start, expr_end = line:find("`([^`]+)`", start_idx)
    if not expr_start then
      break
    end
    table.insert(expressions, {
      start = expr_start + 1,
      finish = expr_end - 1,
      closing = expr_end,
      content = line:sub(expr_start + 1, expr_end - 1),
    })
    start_idx = expr_end + 1
  end
  -- Automatic mode: Check last-closed backtick pair
  if mode == "i" then
    local last_char = line:sub(cursor_col - 1, cursor_col - 1)
    if last_char == "`" then
      for _, expr in ipairs(expressions) do
        if expr.closing == cursor_col - 1 then
          -- Check if content starts with ; and matches allowed characters
          if not expr.content:find("=") and expr.content:match("^;%s*[%d%+%-%*%/%%%s%.%(%)x÷]+$") then
            local success, result = pcall(function()
              return load("return " .. expr.content:gsub("x", "*"):gsub("÷", "/"):sub(2))()
            end)
            if success then
              local cleaned = expr.content:sub(2):gsub("^%s*", "")
              local replacement = string.format("%s=%s", cleaned, result)
              local new_line = line:sub(1, expr.start - 1) .. replacement .. line:sub(expr.finish + 1)
              vim.api.nvim_set_current_line(new_line)
              vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), expr.start + #replacement })
            end
          end
          return
        end
      end
    end
  end
  -- Manual mode: Check cursor position
  local handled = false
  for _, expr in ipairs(expressions) do
    if (cursor_col >= expr.start and cursor_col <= expr.finish) or (mode == "i" and cursor_col == expr.closing) then
      if expr.content:find("=") then
        vim.notify("Expression already calculated", vim.log.levels.INFO)
        return
      end
      local expression = expr.content:gsub("x", "*"):gsub("÷", "/")
      local success, result = pcall(function()
        return load("return " .. expression)()
      end)
      if success then
        local replacement = string.format("%s=%s", expression, result)
        local new_line = line:sub(1, expr.start - 1) .. replacement .. line:sub(expr.finish + 1)
        vim.api.nvim_set_current_line(new_line)
      else
        vim.notify("Invalid expression: " .. expression, vim.log.levels.ERROR)
      end
      handled = true
      return
    end
  end
  -- Handle incomplete backtick pairs in insert mode
  if not handled and (mode == "i" or not auto_trigger) then
    -- Find last opening backtick before cursor
    local open_pos = line:sub(1, cursor_col):find("`[^`]*$")
    if open_pos then
      local content = line:sub(open_pos + 1, cursor_col - 1)
      local pattern = auto_trigger and "^;%s*[%d%+%-%*%/%%%s%.%(%)x÷]+$" or "^[%d%+%-%*%/%%%s%.%(%)x÷]+$"
      if not content:find("=") and content:match(pattern) then
        local expr_to_eval = content:gsub("x", "*"):gsub("÷", "/")
        if auto_trigger then
          expr_to_eval = expr_to_eval:sub(2) -- Remove leading ';' for auto
        end
        local success, result = pcall(function()
          return load("return " .. expr_to_eval)()
        end)
        if success then
          local cleaned = expr_to_eval:gsub("^%s*", "")
          local replacement = string.format("`%s=%s`", cleaned, result)
          local new_line = line:sub(1, open_pos - 1) .. replacement .. line:sub(cursor_col)
          vim.api.nvim_set_current_line(new_line)
          -- Move cursor to end of replacement
          vim.api.nvim_win_set_cursor(0, { vim.fn.line("."), open_pos + #replacement - 1 })
        else
          vim.notify("Invalid expression: " .. content, vim.log.levels.ERROR)
        end
        return
      end
    end
  end
  if not auto_trigger then
    vim.notify("No expression under cursor", vim.log.levels.WARN)
  end
end

-- Replaces the current word with the same word in uppercase, globally
vim.keymap.set(
  "n",
  "<leader>sU",
  [[:%s/\<<C-r><C-w>\>/<C-r>=toupper(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "GLOBALLY replace word I'm on with UPPERCASE" }
)

-- Replaces the current word with the same word in lowercase, globally
vim.keymap.set(
  "n",
  "<leader>sL",
  [[:%s/\<<C-r><C-w>\>/<C-r>=tolower(expand('<cword>'))<CR>/gI<Left><Left><Left>]],
  { desc = "GLOBALLY replace word I'm on with lowercase" }
)

-- ############################################################################
--                         Begin of markdown section
-- ############################################################################

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Keymap to switch spelling language to English lamw25wmal
-- To save the language settings configured on each buffer, you need to add
-- "localoptions" to vim.opt.sessionoptions in the `lua/config/options.lua` file
vim.keymap.set("n", "<leader>msle", function()
  vim.opt.spelllang = "en"
  vim.cmd("echo 'Spell language set to English'")
end, { desc = "Spelling language English" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Keymap to switch spelling language to Swedish lamw25wmal
vim.keymap.set("n", "<leader>msls", function()
  vim.opt.spelllang = "sv"
  vim.cmd("echo 'Spell language set to Swedish'")
end, { desc = "Spelling language Swedish" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Keymap to switch spelling language to both Swedish and English lamw25wmal
vim.keymap.set("n", "<leader>mslb", function()
  vim.opt.spelllang = "en,sv"
  vim.cmd("echo 'Spell language set to Swedish and English'")
end, { desc = "Spelling language Swedish and English" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Show spelling suggestions / spell suggestions
vim.keymap.set("n", "<leader>mss", function()

  vim.cmd("normal! 1z=")

end, { desc = "Spelling suggestions" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- markdown good, accept spell suggestion
-- Add word under the cursor as a good word
vim.keymap.set("n", "<leader>msg", function()
  vim.cmd("normal! zg")
  -- I do a write so that harper is updated
  vim.cmd("silent write")
end, { desc = "Spelling add word to spellfile" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Undo zw, remove the word from the entry in 'spellfile'.
vim.keymap.set("n", "<leader>msu", function()
  vim.cmd("normal! zug")
end, { desc = "Spelling undo, remove word from list" })

-- HACK: neovim spell multiple languages
-- https://youtu.be/uLFAMYFmpkE
--
-- Repeat the replacement done by |z=| for all matches with the replaced word
-- in the current window.
vim.keymap.set("n", "<leader>msr", function()
  -- vim.cmd(":spellr")
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":spellr\n", true, false, true), "m", true)
end, { desc = "Spelling repeat" })

-- Remap 'gss' to 'gsa`' in visual mode
-- This surrounds with inline code, that I use a lot lamw25wmal
vim.keymap.set("v", "gss", function()
  -- Use nvim_replace_termcodes to handle special characters like backticks
  local keys = vim.api.nvim_replace_termcodes("gsa`", true, false, true)
  -- Feed the keys in visual mode ('x' for visual mode)
  vim.api.nvim_feedkeys(keys, "x", false)
  -- I tried these 3, but they didn't work, I assume because of the backtick character
  -- vim.cmd("normal! gsa`")
  -- vim.cmd([[normal! gsa`]])
  -- vim.cmd("normal! gsa\\`")
end, { desc = " Surround selection with backticks (inline code)" })

-- Keymap to delete the current file
vim.keymap.set("n", "<leader>fD", function()
  delete_current_file()
end, { desc = "Delete current file" })

vim.keymap.set("n", "<leader>mhD", function()
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  -- I'm using [[ ]] to escape the special characters in a command
  vim.cmd([[:g/^\s*#\{2,}\s/ s/^#\(#\+\s.*\)/\1/]])
  -- Restore the cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)
  -- Clear search highlight
  vim.cmd("nohlsearch")
end, { desc = "Decrease headings without confirmation" })

return M
