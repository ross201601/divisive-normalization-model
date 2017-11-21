function  M = DMPL_stim_prepareSpecs(M)

%DMPL_stim_prepareSpecs - Fill in the derivable stimulus-related Dimple specs
%
% M = DMPL_stim_defaultSpecs(M)
%
% The input M is a specification structure (aka "model") generated by
% DMPL_prepareSpecs.m or some equivalent function.
% DMPL_stim_prepareSpecs fills in certain additional fields to M.stim_spec.
%
% DMPL_stim_prepareSpecs implements level 1 of the DMPL_prepareSpecs pipeline.
%
% Input arguments:  ----------------------
% M -- Seed struct produced by (or compatible with) DMPL_prepareSpecs level 0.
%
% Return value:  -------------------------
% M -- A copy of M in which the following fields have been modified:
%  M.prepare_level -- Updated to max(M.prepare_level,1)
%  M.stim_spec -- Augmented with additional fields shown in the example below
%
% Example:
% M = DMPL_defaultSpecs([],0,1);  % make a level-1 seed structure
% M = DMPL_prepareSpecs(M,0,0);   % prepare up to level 0
% M = DMPL_stim_prepareSpecs(M) , stim_spec = M.stim_spec
%   M = 
%        descriptor: 'DMPL_defaultSpecs ver. 0sa, 16-Jun-2013 10:53:51'
%       model_level: 1
%         stim_spec: [1x1 struct]
%          preparer: 'DMPL_prepareSpecs, 16-Jun-2013 11:49:02'
%     prepare_level: 1
%
%   stim_spec = 
%           descriptor: 'DMPL_stim_defaultSpecs, 16-Jun-2013 10:58:04'
%     coordinatesStyle: 'xy'
%        imageSize_pix: [64 64]
%          degPerPixel: 0.0450
%               minLum: 0
%                bgLum: 0.5000
%               maxLum: 1
%             preparer: 'DMPL_stim_prepareSpecs, 16-Jun-2013 12:20:04'
%             rangeLum: 1
%           num_pixels: 4096
%          domainX_deg: [1x64 double]
%          domainY_deg: [64x1 double]
%            gridX_deg: [64x64 double]
%            gridY_deg: [64x64 double]
%
% See also DMPL_stim_defaultSpecs, DMPL_prepareSpecs, DMPL_EarlyVis_prepareSpecs

% (c) Laboratory for Cognitive Modeling and Computational Cognitive
% Neuroscience at the Ohio State University, http://cogmod.osu.edu
%
% 1.0.1 2013-06-17 AAP: Envorce that (bgLum==(maxLum-minLum)/2) is always true.
% 1.0.0 2013-06-16 AAP: Wrote it based on Dimple0k/DMPL_EarlyVis_Specs.m


%% Check seed struct for consistency
%assert(isstruct(M))
assert(M.model_level >= 1)
assert(M.prepare_level >= 0)



%% Retrieve the foundational stimulus specifications
imageSize_pix = M.stim_spec.imageSize_pix;

minLum = M.stim_spec.minLum;
bgLum  = M.stim_spec.bgLum;   % background luminance
maxLum = M.stim_spec.maxLum;

degPerPixel = M.stim_spec.degPerPixel;  % degrees per pixel


%% Consistency checks
% These reflect theoretical commitments of the model.
% See the comments in DMPL_stim_defaultSpecs.m for details.
assert(maxLum > minLum)
assert(bgLum == (maxLum-minLum)/2)


%% Prepare grids
xaxis = 2;  % in 'xy' image format, the x coordinate grows with the second index
yaxis = 1;
iaxis = yaxis;
jaxis = xaxis;

minYX = -floor(imageSize_pix./2);

%- Linear grids
domainX_deg = ((0:imageSize_pix(xaxis)-1) +minYX(xaxis)) .* degPerPixel; % deg
domainY_deg = ((0:imageSize_pix(yaxis)-1)'+minYX(yaxis)) .* degPerPixel; % deg

%- 2D grids
[gridX_deg,gridY_deg] = meshgrid(domainX_deg,domainY_deg); % deg


%% Add new fields to M.stim_spec
M.stim_spec.preparer = sprintf('%s, %s', mfilename(), datestr(now));
M.stim_spec.rangeLum = maxLum - minLum;
M.stim_spec.num_pixels = prod(imageSize_pix);
M.stim_spec.domainX_deg = domainX_deg;
M.stim_spec.domainY_deg = domainY_deg;
M.stim_spec.gridX_deg = gridX_deg;
M.stim_spec.gridY_deg = gridY_deg;


%% Update M.prepare_level and return
M.prepare_level = max(M.prepare_level,1);


%%% Return M
end  %%% of file