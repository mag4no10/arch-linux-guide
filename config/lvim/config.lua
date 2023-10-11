-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

local function open_nvim_tree()
    require("nvim-tree.api").tree.open()
end
    vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })