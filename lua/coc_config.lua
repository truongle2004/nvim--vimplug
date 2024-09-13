local map = vim.keymap.set

function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
map("i", "<c-j>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', opts)
map("i", "<c-k>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], opts)

map("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)

--map("i", "<c-j>", "<Plug>(coc-snippets-expand-jump)")
map("i", "<c-space>", "coc#refresh()", {silent = true, expr = true})
map("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
map("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

map("n", "gd", "<Plug>(coc-definition)", {silent = true})
map("n", "gy", "<Plug>(coc-type-definition)", {silent = true})
map("n", "gi", "<Plug>(coc-implementation)", {silent = true})
map("n", "gr", "<Plug>(coc-references)", {silent = true})


function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
map("n", "K", '<CMD>lua _G.show_docs()<CR>', {silent = true})

-- Highlight the symbol and its references on a CursorHold event(cursor is idle)
vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

-- Symbol renaming
map("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})


-- Formatting selected code
map("x", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})
map("n", "<leader>f", "<Plug>(coc-format-selected)", {silent = true})


-- Setup formatexpr specified filetype(s)
vim.api.nvim_create_autocmd("FileType", {
    group = "CocGroup",
    pattern = "typescript,json",
    command = "setl formatexpr=CocAction('formatSelected')",
    desc = "Setup formatexpr specified filetype(s)."
})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd("User", {
    group = "CocGroup",
    pattern = "CocJumpPlaceholder",
    command = "call CocActionAsync('showSignatureHelp')",
    desc = "Update signature help on jump placeholder"
})

local opts = {silent = true, nowait = true}
map("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
map("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

map("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
map("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
map("n", "<leader>qf", "<Plug>(coc-fix-current)", opts)

map("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
map("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
map("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
map("n", "<leader>cl", "<Plug>(coc-codelens-action)", opts)


map("x", "if", "<Plug>(coc-funcobj-i)", opts)
map("o", "if", "<Plug>(coc-funcobj-i)", opts)
map("x", "af", "<Plug>(coc-funcobj-a)", opts)
map("o", "af", "<Plug>(coc-funcobj-a)", opts)
map("x", "ic", "<Plug>(coc-classobj-i)", opts)
map("o", "ic", "<Plug>(coc-classobj-i)", pts)
map("x", "ac", "<Plug>(coc-classobj-a)", opts)
map("o", "ac", "<Plug>(coc-classobj-a)", opts)


local opts = {silent = true, nowait = true, expr = true}
map("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
map("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)
map("i", "<C-f>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(1)<cr>" : "<Right>"', opts)
map("i", "<C-b>",
       'coc#float#has_scroll() ? "<c-r>=coc#float#scroll(0)<cr>" : "<Left>"', opts)
map("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', opts)
map("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', opts)


map("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
map("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})


vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

vim.api.nvim_create_user_command("Fold", "call CocAction('fold', <f-args>)", {nargs = '?'})

vim.api.nvim_create_user_command("OR", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})


local opts = {silent = true, nowait = true}
map("n", "<space>a", ":<C-u>CocList diagnostics<cr>", opts)
map("n", "<space>e", ":<C-u>CocList extensions<cr>", opts)
map("n", "<space>c", ":<C-u>CocList commands<cr>", opts)
map("n", "<space>o", ":<C-u>CocList outline<cr>", opts)
map("n", "<space>s", ":<C-u>CocList -I symbols<cr>", opts)
map("n", "<space>j", ":<C-u>CocNext<cr>", opts)
map("n", "<space>k", ":<C-u>CocPrev<cr>", opts)
map("n", "<space>p", ":<C-u>CocListResume<cr>", opts)

