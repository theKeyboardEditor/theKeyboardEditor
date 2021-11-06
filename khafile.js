let project = new Project('theKeyboardEditor');

// Configration
project.localLibraryPath = 'vendor';
project.icon = 'assets/Icon.png';

// Paths
project.addAssets('assets/**');
project.addShaders('shaders/**');
project.addSources('src');

// Libraries
project.addLibrary('zui');
project.addLibrary('cornerContour');
await project.addProject('vendor/keyson');

resolve(project);
