let project = new Project('theKeyboardEditor');
project.localLibraryPath = 'vendor';
project.icon = 'assets/Icon.png';

project.addAssets('assets/**');
project.addShaders('shaders/**');
project.addSources('src');
// Libraries
project.addLibrary('zui');
project.addLibrary('firetongue');
resolve(project);
