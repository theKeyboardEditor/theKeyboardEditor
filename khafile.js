let project = new Project('theKeyboardEditor');
project.localLibraryPath = 'vendor';

project.addAssets('assets/**');
project.addShaders('shaders/**');
project.addSources('src');
// Libraries
project.addLibrary('zui');

resolve(project);
