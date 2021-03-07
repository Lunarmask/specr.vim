" SPECR PLUGIN


" RUN
function! specr#run(...) abort
  if empty(a:000)
    let s:found_filepath = call DirectSpec(expand('%'))
  else
    let s:found_filepath = call DirectSpec(a:1)
  end
  call RenderSpec(s:found_filepath)
endfunction


" COPY
function! specr#copy(...) abort
  let l:found_filepath = call DirectSpec(expand('%'))
  +=l:found_filepath
endfunction


function! DirectSpec(argpath) abort
  " Example of true statement: spec/folder1/folder2/controller_spec.rb (exists)

  if and(split(a:argpath, '/')[0] == 'spec', a:argpath[-7:-1] == 'spec.rb')
    return a:argpath
  else
    return FindSpecLiteral(a:argpath)
  endif
endfunction


function! FindSpecLiteral(argpath) abort
  " Example of true statement: app/folder1/controller.rb -> spec/folder1/controller_spec.rb (exists)

  let l:lookup_filename = join([split(split(a:argpath, '/')[-1], '\.')[0]] + ["_spec.rb"], '')
  let l:lookup_filepath = join(['spec'] + split(a:argpath, '/')[1:-2] + [l:lookup_filename], '/')

  if filereadable(l:lookup_filepath)
    return l:lookup_filepath
  else
    return FindSpecGlob(a:argpath)
  endif
endfunction


function! FindSpecGlob(argpath) abort
  " Example of true statement app/folder1/builder.rb -> spec/folder1/builder_part_spec.rb (exists)

  let l:lookup_glob = join([split(split(a:argpath, '/')[-1], '\.')[0]] + ["*spec.rb"], '')
  let l:lookup_globpath = join(['spec'] + split(a:argpath, '/')[1:-2] + [l:lookup_glob], '/')
  let l:lookup_string = join(['`ls ', l:lookup_globpath,'`'], '')
  let l:lookup_result = glob(l:lookup_string)

  if filereadable(l:lookup_result)
    return l:lookup_result
  else
    return FindSpecDir(a:argpath)
  endif
endfunction


function! FindSpecDir(argpath) abort
  " Example of true statement: app/folder1/class/module.rb -> spec/folder1/class/ (exists)

  let b:testpath = join(['spec'] + split(a:argpath, '/')[1:-2], '/')

  while !isdirectory(b:testpath)
    let b:testpath = join(split(b:testpath, '/')[0:-2], '/')
  endwhile

  return b:testpath
endfunction


function! RenderSpec(argpath) abort
  vnew
  let $specr_final = a:argpath
  term eval "echo -e '\nRunning tests for path: $specr_final\n\n'; bundle exec rspec $specr_final"
  normal! G
endfunction

