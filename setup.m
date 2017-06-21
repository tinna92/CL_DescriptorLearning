function setup(varargin)

addpath(genpath('.'));
% addpath(genpath('../data/.'));

addpath('../external/matconvnet/matconvnet-1.0-beta12/matlab');
addpath('../external/vlfeat/vlfeat-0.9.20new/toolbox/');
run vl_setup ;
run vl_setupnn ;
addpath examples ;
% run vlfeat/toolbox/vl_setup ;
% run matconvnet/matlab/vl_setupnn ;
% addpath matconvnet/examples ;

opts.useGpu = false ;
opts.verbose = false ;
opts = vl_argparse(opts, varargin) ;

try
  vl_nnconv(single(1),single(1),[]) ;
catch
  warning('VL_NNCONV() does not seem to be compiled. Trying to compile it now.') ;
  vl_compilenn('enableGpu', opts.useGpu, 'verbose', opts.verbose) ;
end

if opts.useGpu
  try
    vl_nnconv(gpuArray(single(1)),gpuArray(single(1)),[]) ;
  catch
    vl_compilenn('enableGpu', opts.useGpu, 'verbose', opts.verbose) ;
    warning('GPU support does not seem to be compiled in MatConvNet. Trying to compile it now') ;
  end
end
