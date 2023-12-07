let project = new Project('theKeyboardEditor');
project.localLibraryPath = 'vendor';
project.icon = 'assets/Icon.png';

project.addAssets('assets/**');
project.addShaders('shaders/**');
project.addSources('src');

// Libraries
project.addLibrary('haxeui-core');
await project.addProject('vendor/haxeui-kha');
await project.addProject('vendor/keyson/');
project.addLibrary('slide');

project.addDefine('message-reporting=pretty');
resolve(project);
