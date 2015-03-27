% Author: @GizemKucukoglu
% March 2015
% Example code for D. Brainard. Renders a sphere using a light field. 
%% Render the LightFieldSphere scene .
% light probe taken from: http://dativ.at/lightprobes/

% Usage notes: 
%     The .dae file needs to have a hemi-light
%     The light field needs to be in rectangular format.
%     The conditions file has various values for alpha parameter. To make
%     the sphere a mirror, set alpha to be very small. But do not set it to
%     zero. 

%% Choose example files, make sure they're on the Matlab path.

parentSceneFile = 'LightFieldSphere.dae';
mappingsFile = 'LightFieldSphereMappings.txt';
conditionsFile = 'LightFieldSphereConditions.txt';


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
    nativeSceneFiles = MakeSceneFiles(parentSceneFile, conditionsFile, mappingsFile, hints);
    radianceDataFiles = BatchRender(nativeSceneFiles, hints);
    
    % condense multi-spectral renderings into one sRGB montage
    montageName = sprintf('LightFieldSphere (%s)', hints.renderer);
    montageFile = [montageName '.png'];
    [SRGBMontage, XYZMontage] = ...
        MakeMontage(radianceDataFiles, montageFile, toneMapFactor, isScaleGamma, hints);
    
    % display the sRGB montage
    ShowXYZAndSRGB([], SRGBMontage, montageName);
    
end

