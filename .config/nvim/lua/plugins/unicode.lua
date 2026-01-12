--[===[
Plugin for searching and inserting unicode characters
URL: http://github.com/chrisbra/unicode.vim
--]===]

return {
   'chrisbra/unicode.vim',
   enabled = true,
   cmd = {
      'UnicodeName',
      'UnicodeSearch',
      'UnicodeTable',
      'Digraphs',
      'DownloadUnicode',
      'UnicodeCache',
   },
}
