return {
	"vimwiki/vimwiki",
    config = function ()
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
    end
}
