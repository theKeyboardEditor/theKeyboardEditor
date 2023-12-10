# theKeyboardEditor

![GitHub](https://img.shields.io/github/license/theKeyboardEditor/theKeyboardEditor?style=for-the-badge)

A theoretical keyboard layout editor software.

## Dependencies
- `node`: Used for the build system

## Setup
```
# Start by cloning theKeyboardEditor and all its submodules
git clone --shallow-submodules -j8 https://github.com/theKeyboardEditor/theKeyboardEditor && cd theKeyboardEditor
# Get Kha dependencies
./Kha/get_dlc
```

## Compilation
```
# First compile to the web target, for other targets look at the Kha wiki
$ node Kha/make html5 --compile
# Then start a **development** web server
$ node Kha/make html5 --server
# Now take a peek at http://localhost:8080 and you should see the editor!
```

## License
theKeyboardEditor is licensed under the permissive MIT license. For more information check [LICENSE](https://raw.githubusercontent.com/theKeyboardEditor/theKeyboardEditor/master/LICENSE).
