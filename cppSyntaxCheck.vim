" ======================================================================================
" File         : cppSpellCheck.vim
" Author       : Yang Fengjia
" Last Change  : 09/03/2012 | 14:15:04 PM | Monday,September
" Description  : A cpp language spell check script
" ======================================================================================

"g++
if(!exists("g:include_path"))
    let g:include_path=' '
endif
if(!exists("g:compile_flag"))
    let g:compile_flag=' '
endif
if(!exists("g:cpp_compiler"))
    let g:cpp_compiler='LC_MESSAGES=en_US g++ -Wall'
endif
if(!exists("g:enable_warning"))
    let g:enable_warning=0
endif
if(!exists("g:longest_text"))
    let g:longest_text=100
endif

sign define GCCError text=>> texthl=Error
sign define GCCWarning text=>> texthl=Todo
let g:error_list = {}
let g:warning_list = {}
let g:buffer_name=''

function! s:ShowErrC()
    call s:ClearErr()

    let b:error_list={}
    let buf_name=bufname("%")
    let dir_tree=split(buf_name, '/')
    let file_name=dir_tree[len(dir_tree)-1]
    let include_path=substitute(g:include_path, ':', " -I", "g")

    "show error    
    let buf_name_split=split(file_name, '\.')
    if ( 'h' == buf_name_split[len(buf_name_split)-1] )
        let compile_cmd=g:cpp_compiler . ' -o .tmpobject -c ' . buf_name . ' ' 
                    \. g:compile_flag . ' ' . include_path . 
                    \'     >.err 2>&1'
    elseif ('hpp' == buf_name_split[len(buf_name_split)-1])
        let compile_cmd=g:cpp_compiler . ' -o .tmpobject -c ' . buf_name . ' ' 
                    \. g:compile_flag . ' ' . include_path . 
                    \'     >.err 2>&1'
    else
        let compile_cmd=g:cpp_compiler . ' -x c++ -fsyntax-only ' . buf_name . ' ' 
                    \. g:compile_flag . ' ' . include_path . 
                    \'     >.err 2>&1'
    endif
    call system(compile_cmd)
    let show_cmd = 'cat .err |grep error|grep ' .file_name
    let compile_result=system(show_cmd)
    let line_list=split(compile_result, '\n')

    for error_str in line_list
    "echo error_str
        let split_list=split(error_str,':')
        if len(split_list) < 3
            continue
        endif
        let item={}
        let item["lnum"]= split_list[1]
        let item["text"] = error_str
        let b:error_list[item.lnum]=item
        let g:error_list[buf_name]=b:error_list
    endfor

    "show warning
    if g:enable_warning!=0
        let b:warning_list={}
        let show_cmd = 'cat .err |grep warning|grep ' .file_name
        let compile_result=system(show_cmd)
        let line_list=split(compile_result, '\n')
        for warning_str in line_list
            let split_list=split(warning_str,':')
            if len(split_list) < 3
                continue
            endif
            let item={}
            let item["lnum"]=split_list[1]
            let item["text"] = error_str
            let b:warning_list[item.lnum]=item
            let g:warning_list[buf_name]=b:warning_list
        endfor
    endif
    call s:SignErrWarn()
    if ( len(b:error_list) > 0 )
        execute 'silent cfile .err' 
    elseif ( len(b:warning_list) > 0 )
        execute 'silent cfile .err' 
    endif

    "remove file created
    let rm_cmd='rm .err .tmpobject > /dev/null 2>&1'
    call system(rm_cmd)
endfunction

"Clear the dictionary of error
function! s:ClearErr()
    let buf_name=bufname("%")
    sign unplace *
    let b:error_list={}
    let b:warning_list={}
    let g:error_list[buf_name]=b:error_list
    let g:warning_list[buf_name]=b:warning_list
    echo
endfunction

function! s:SignErrWarn()
    sign unplace *
    let b:next_sign_id=1
    let buf_name=bufname("%")
    if has_key(g:error_list, buf_name)
        let b:error_list=get(g:error_list, buf_name)
    else
        let b:error_list={}
    endif
    if has_key(g:warning_list, buf_name)
        let b:warning_list=get(g:warning_list, buf_name)
    else
        let b:warning_list={}
    endif
    for error_key in keys(b:error_list)
        let item=b:error_list[error_key]
        execute "sign place"  b:next_sign_id "line=" . item.lnum "name=GCCError " "file=" . expand("%:p")
        let b:next_sign_id+=1
    endfor
    for warning_key in keys(b:warning_list)
        let item=b:warning_list[warning_key]
        execute "sign place"  b:next_sign_id "line=" . item.lnum "name=GCCWarning " "file=" . expand("%:p")
        let b:next_sign_id+=1
    endfor
endfunction

"Show syntax error
function! s:ShowErrMsg()
    let buf_name=bufname("%")
    if buf_name!=g:buffer_name
        call s:SignErrWarn()
        if has_key(g:error_list, buf_name)
            let b:error_list=get(g:error_list, buf_name)
        else
            let b:error_list={}
        endif
        if has_key(g:warning_list, buf_name)
            let b:warning_list=get(g:warning_list, buf_name)
        else
            let b:warning_list={}
        endif
        let g:buffer_name=buf_name
    endif
    let pos=getpos(".")
    if has_key(b:error_list, pos[1])
        let item = get(b:error_list, pos[1])
        if ( len(item.text) < g:longest_text )
            echo item.text
        else
            echo strpart( item.text, 0 ,g:longest_text )
        endif
    else
        echo
    endif
    if has_key(b:warning_list, pos[1])
        let item = get(b:warning_list, pos[1])
        if ( len(item.text) < g:longest_text )
            echo item.text
        else
            echo strpart( item.text, 0 ,g:longest_text )
        endif
    else
        echo
    endif
endfunction

autocmd BufWritePost *.cpp,*.c,*.h,*.hpp,*.cc call s:ShowErrC()
autocmd CursorHold *.cpp,*.h,*.c,*.hpp,*.cc call s:ShowErrMsg()
autocmd CursorMoved *.cpp,*.h,*.c,*.hpp,*.cc call s:ShowErrMsg()
map <Leader>s :cn<cr>
