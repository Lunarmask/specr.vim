" SPECR PLUGIN


function! specr#run(...) abort
  if empty(a:000)
    call DirectSpec(expand('%'))
  else
    call DirectSpec(a:1)
  end
endfunction


function! DirectSpec(argpath) abort
  " Example of true statement: spec/folder1/folder2/controller_spec.rb (exists)

  if and(split(a:argpath, '/')[0] == 'spec', a:argpath[-7:-1] == 'spec.rb')
    call RenderSpec( a:argpath )
  else
    call FindSpecLiteral(a:argpath)
  endif
endfunction


function! FindSpecLiteral(argpath) abort
  " Example of true statement: app/folder1/controller.rb -> spec/folder1/controller_spec.rb (exists)

  let l:lookup_filename = join([split(split(a:argpath, '/')[-1], '\.')[0]] + ["_spec.rb"], '')
  let l:lookup_filepath = join(['spec'] + split(a:argpath, '/')[1:-2] + [l:lookup_filename], '/')

  if filereadable(l:lookup_filepath)
    call RenderSpec( l:lookup_filepath )
  else
    call FindSpecGlob(a:argpath)
  endif
endfunction


function! FindSpecGlob(argpath) abort
  " Example of true statement app/folder1/builder.rb -> spec/folder1/builder_part_spec.rb (exists)

  let l:lookup_glob = join([split(split(a:argpath, '/')[-1], '\.')[0]] + ["*spec.rb"], '')
  let l:lookup_globpath = join(['spec'] + split(a:argpath, '/')[1:-2] + [l:lookup_glob], '/')
  let l:lookup_string = join(['`ls ', l:lookup_globpath,'`'], '')
  let l:lookup_result = glob(l:lookup_string)

  if filereadable(l:lookup_result)
    call RenderSpec( l:lookup_result )
  else
    call RenderSpec( FindSpecDir(a:argpath) )
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

