call plug#begin('~/.vim/plugged')
Plug 'rust-lang/rust.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'pappasam/coc-jedi', {'do': 'yarn install --frozen-lockfile && yarn build', 'branch': 'main' }
Plug 'vuciv/vim-bujo'
call plug#end()

" Show line number
set number
