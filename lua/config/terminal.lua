-- Terminal orchestrator.
--
-- Each "slot" (split, vsplit, tab, fullscreen) is a single window that can
-- hold a stack of terminal buffers you cycle through, instead of a window
-- being tied to exactly one terminal. Plain `:terminal` buffers are used
-- directly (not Snacks.terminal) so buffers can be freely swapped into a
-- slot's window while cycling without fighting Snacks' own show/hide state.

local M = {}

vim.api.nvim_set_hl(0, 'TermNavbarActive', { link = 'TabLineSel', default = true })
vim.api.nvim_set_hl(0, 'TermNavbarInactive', { link = 'TabLine', default = true })

local slots = {
    split = { open = function() vim.cmd('botright split') end },
    vsplit = { open = function() vim.cmd('botright vsplit') end },
    tab = { open = function() vim.cmd('tabnew') end },
    fullscreen = { open = nil }, -- takes over whatever window is current
}

for _, slot in pairs(slots) do
    slot.terms = {} -- ordered list of terminal buffers
    slot.idx = 0 -- 1-based index into slot.terms currently shown
    slot.win = nil
end

local function new_term_buf()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_call(buf, function()
        vim.fn.jobstart(vim.o.shell, { term = true })
    end)
    return buf
end

local function ensure_window(slot)
    if slot.win and vim.api.nvim_win_is_valid(slot.win) then
        vim.api.nvim_set_current_win(slot.win)
        return slot.win
    end
    if slot.open then
        slot.open()
    end
    slot.win = vim.api.nvim_get_current_win()
    -- Buffers are created off-window (nvim_buf_call, before nvim_win_set_buf
    -- puts them here), so the TermOpen autocmd's `vim.wo.number = false`
    -- etc. lands on whatever window was current at creation time, not this
    -- one. These are window-local, so set them once for this window instead.
    vim.wo[slot.win].number = false
    vim.wo[slot.win].relativenumber = false
    vim.wo[slot.win].signcolumn = 'no'
    vim.api.nvim_create_autocmd('WinClosed', {
        pattern = tostring(slot.win),
        once = true,
        callback = function()
            slot.win = nil
        end,
    })
    return slot.win
end

-- Nav bar: a clickable `winbar` on each slot's window listing its terminals
-- (" 1:zsh  2:npm run dev  3:zsh "), current one highlighted. `click_targets`
-- maps the small int embedded in the winbar's click region back to which
-- slot/index to jump to; rebuilt on every render, so stale ids from a
-- previous render simply get overwritten.
local click_targets = {}

local function term_label(buf)
    if not vim.api.nvim_buf_is_valid(buf) then
        return '...'
    end
    -- term_title starts out mirroring the raw `term://` buffer name until
    -- the shell reports a real title (e.g. via OSC or running a command),
    -- so fall back to the shell's basename rather than showing that.
    local title = vim.b[buf].term_title
    if title and title ~= '' and not title:match('^term://') then
        return title
    end
    return vim.fn.fnamemodify(vim.o.shell, ':t')
end

local function render_winbar(name, slot)
    local parts = {}
    for i, buf in ipairs(slot.terms) do
        local id = #click_targets + 1
        click_targets[id] = { slot = name, idx = i }
        local hl = (i == slot.idx) and 'TermNavbarActive' or 'TermNavbarInactive'
        parts[#parts + 1] = string.format(
            '%%#%s#%%%d@v:lua.__term_navbar_click@ %d:%s %%X',
            hl,
            id,
            i,
            term_label(buf):gsub('%%', '%%%%')
        )
    end
    return table.concat(parts) .. '%#TermNavbarInactive#'
end

--- Redraw the winbar of every currently open slot window.
local function refresh_winbars()
    click_targets = {}
    for name, slot in pairs(slots) do
        if slot.win and vim.api.nvim_win_is_valid(slot.win) then
            vim.api.nvim_set_option_value('winbar', render_winbar(name, slot), { win = slot.win })
        end
    end
end

--- Click handler for the nav bar (referenced from 'winbar' as v:lua.*, so it
--- must be a plain global, not a module-local function).
function _G.__term_navbar_click(id)
    local target = click_targets[id]
    if target then
        M.jump(target.slot, target.idx)
    end
end

local function show(slot, idx, insert)
    local win = ensure_window(slot)
    slot.idx = idx
    vim.api.nvim_win_set_buf(win, slot.terms[idx])
    vim.api.nvim_set_current_win(win)
    refresh_winbars()
    if insert then
        vim.cmd('startinsert')
    end
end

local function slot_for_name(name)
    local slot = slots[name]
    assert(slot, 'unknown terminal slot: ' .. tostring(name))
    return slot
end

--- Name + table of whichever slot's window currently has focus, if any.
local function slot_of_current_win()
    local win = vim.api.nvim_get_current_win()
    for name, slot in pairs(slots) do
        if slot.win == win then
            return name, slot
        end
    end
end

--- Open (or focus) a slot, creating its first terminal on demand. Enters
--- insert mode, since this is "I want to type into a terminal now".
function M.open(name)
    local slot = slot_for_name(name)
    if #slot.terms == 0 then
        table.insert(slot.terms, new_term_buf())
    end
    show(slot, slot.idx > 0 and slot.idx or 1, true)
end

--- Append a new terminal right after the current one. Defaults to whichever
--- slot the cursor is currently in, falling back to `split`. Enters insert
--- mode, same reasoning as `open`.
function M.new(name)
    local slot = slot_for_name(name or slot_of_current_win() or 'split')
    table.insert(slot.terms, slot.idx + 1, new_term_buf())
    show(slot, slot.idx + 1, true)
end

--- Jump straight to a given terminal in a slot (used by nav bar clicks).
function M.jump(name, idx)
    local slot = slot_for_name(name)
    if slot.terms[idx] then
        show(slot, idx, true)
    end
end

--- Cycle to the next (dir=1) / previous (dir=-1) terminal in a slot, wrapping
--- around. Defaults to whichever slot the cursor is currently in. Lands in
--- normal mode (you're browsing, not necessarily about to type); press `i`
--- or `<CR>` to enter the terminal.
function M.cycle(dir, name)
    local slot = name and slot_for_name(name) or select(2, slot_of_current_win())
    if not slot or #slot.terms == 0 then
        return
    end
    show(slot, ((slot.idx - 1 + dir) % #slot.terms) + 1, false)
end

--- Close the terminal currently shown in a slot, dropping it from the stack
--- (and closing the slot's window if that was the last one). Defaults to
--- whichever slot the cursor is currently in.
function M.close(name)
    local slot = name and slot_for_name(name) or select(2, slot_of_current_win())
    if not slot or slot.idx == 0 then
        return
    end
    local buf = slot.terms[slot.idx]
    table.remove(slot.terms, slot.idx)
    if #slot.terms == 0 then
        if slot.win and vim.api.nvim_win_is_valid(slot.win) then
            vim.api.nvim_win_close(slot.win, true)
        end
        slot.win, slot.idx = nil, 0
    else
        show(slot, math.min(slot.idx, #slot.terms), false)
    end
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.api.nvim_buf_delete(buf, { force = true })
    end
end

--- Fuzzy-pick any open terminal across every slot (via vim.ui.select, which
--- Snacks renders through its own picker since picker.enabled = true).
function M.pick()
    local items = {}
    for name, slot in pairs(slots) do
        for i, buf in ipairs(slot.terms) do
            if vim.api.nvim_buf_is_valid(buf) then
                table.insert(items, {
                    slot = name,
                    idx = i,
                    text = string.format(
                        '%s #%d  %s',
                        name,
                        i,
                        vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~')
                    ),
                })
            end
        end
    end
    if #items == 0 then
        vim.notify('No terminals open', vim.log.levels.INFO)
        return
    end
    vim.ui.select(items, {
        prompt = 'Terminals',
        format_item = function(item)
            return item.text
        end,
    }, function(item)
        if item then
            show(slots[item.slot], item.idx, true)
        end
    end)
end

--- Drop stale terminal buffers whose cwd sits under `path` from every slot's
--- stack. Used by the worktrees.nvim `on_switch` hook after a worktree
--- switch so cycling/picker never point at a buffer that no longer exists.
function M.prune_under(path)
    for _, slot in pairs(slots) do
        for i = #slot.terms, 1, -1 do
            local buf = slot.terms[i]
            local cwd = vim.api.nvim_buf_is_valid(buf)
                and vim.api.nvim_buf_get_name(buf):match('^term://(.-)//')
            if not cwd or vim.startswith(cwd, path) then
                table.remove(slot.terms, i)
                if i <= slot.idx then
                    slot.idx = math.max(slot.idx - 1, 0)
                end
                if vim.api.nvim_buf_is_valid(buf) then
                    pcall(vim.api.nvim_buf_delete, buf, { force = true })
                end
            end
        end
        if #slot.terms == 0 and slot.win and vim.api.nvim_win_is_valid(slot.win) then
            vim.api.nvim_win_close(slot.win, true)
            slot.win = nil
        end
    end
    refresh_winbars()
end

return M
