return {
    "vimwiki/vimwiki",
    dependencies = {
        'mattn/calendar-vim',
    },
    config = function()
        vim.g.vimwiki_list = {
            {
                path = '~/Repos/vimwiki',
                syntax = 'markdown',
                ext = '.md'
            },
            {
                path = '~/Repos/buch',
                syntax = 'markdown',
                ext = '.md'
            },
        }

        local api = vim.api
        api.nvim_create_user_command('Diary', 'VimwikiDiaryIndex', {})

        local vimwikigroup = api.nvim_create_augroup('vimwikigroup', { clear = true })

        api.nvim_create_autocmd("FileType", {
            group = vimwikigroup,
            pattern = "vimwiki",
            command = 'setlocal shiftwidth=6 tabstop=6 noexpandtab'
        })

        -- automatically update links on read diary
        api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
            group = vimwikigroup,
            pattern = "diary.wiki",
            command = "VimwikiDiaryGenerateLinks",
        })

        -- insert diary entry header
        api.nvim_create_autocmd("BufNewFile", {
            group = vimwikigroup,
            pattern = "*/diary/[0-9]*.(wiki|md)",
            command = 'call append(0,[ "# " . strftime("%d.%m.%Y"), "", "## Tagebuch", "", "", "## Erkenntnis des Tages", "" ])',
        })
    end
}

