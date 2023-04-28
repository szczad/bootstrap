" autocmd BufWrite <buffer> execute '%!jq .'
autocmd BufWrite <buffer> let b:winview = winsaveview() | execute '%!jq .' | call winrestview(b:winview) | unlet b:winview
