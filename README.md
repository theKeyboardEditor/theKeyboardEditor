# theKeyboardEditor

![GitHub](https://img.shields.io/github/license/theKeyboardEditor/theKeyboardEditor?style=for-the-badge)

A work in progress keyboard layout editor software.

## Dependencies
For the kha build system to work you will need ``nodejs`` any other dependencies should be included.

## Setup
```
# Start by cloning theKeyboardEditor and all its submodules
$ git clone --recurse-submodules -j8 https://github.com/theKeyboardEditor/theKeyboardEditor
# Now move into it
$ cd theKeyboardEditor
```

## Compilation
```
# First compile to the web target, for other targets look at the Kha wiki
$ node vendor/Kha/make html5
# Then start a **development** web server
$ node vendor/Kha/make html5 --server
# If you look at localhost:8080 you should see theKeyboardEditor!
```

## License
theKeyboardEditor is licensed under the permissive MIT license. For more information check [LICENSE](https://raw.githubusercontent.com/theKeyboardEditor/theKeyboardEditor/master/LICENSE).
