% Author: @GizemKucukoglu
% March 2015
% Example code for D. Brainard. Renders a sphere using a light field. 
%% Render the LightFieldSphere scene .
% light probe taken from: http://dativ.at/lightprobes/

% Usage notes: 
%     The .dae file needs to have a hemi-light
%     The light field needs to be rectangular format
%% Choose example files, make sure they're on the Matlab path.
% Set preferences
setpref('RenderToolbox3', 'workingFolder', '/users2/gizem/Documents/Research/LightFieldExample-RT3');

parentSceneFile = 'LightFieldSphere3.dae';
mappingsFile = 'LightFieldSphereMappings.txt';
% conditionsFile = 'LightFieldSphereConditions.txt';


% Make sure all illuminants are added to the path. 
addpath(genpath(pwd))
%% Choose batch renderer options.
% which materials to use, [] means all
hints.whichConditions = [];

% pixel size of each rendering
hints.imageWidth = 320;
hints.imageHeight = 240;

% put outputs in a subfolder named like this script
hints.recipeName = mfilename();
ChangeToWorkingFolder(hints);

%% Render with Mitsuba and PBRT.

% how to convert multi-spectral images to sRGB
toneMapFactor = 100;
isScaleGamma = true;

% make a montage and sensor images with each renderer
for renderer = {'Mitsuba'}
    
    % choose one renderer
    hints.renderer = renderer{1};
    
    % make 3 multi-spectral renderings, saved in .mat files
    nativeSceneFiles = MakeSceneFiles(parentSceneFile, '', mappingsFile, hints);
    radianceDataFiles = BatchRender(nativeSceneFiles, hints);
    
    % condense multi-spectral renderings into one sRGB montage
    montageName = sprintf('LightFieldSphere (%s)', hints.renderer);
    montageFile = [montageName '.png'];
    [SRGBMontage, XYZMontage] = ...
        MakeMontage(radianceDataFiles, montageFile, toneMapFactor, isScaleGamma, hints);
    
    % display the sRGB montage
    ShowXYZAndSRGB([], SRGBMontage, montageName);
    
end

