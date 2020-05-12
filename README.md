# mimic-npm-install
Simulate npm install of local packages during React Native development.

## Explanation
The React Native toolchain does not support working with symlinks to npm packages that are being developer locally, in another directory. Because of this, doing a simple **`npm install <path-to-my-local-package>`** doesn't work, which becomes an issue when developing a package and a project that depends on that package, locally.

Simply copying a local package to the project's **node_modules** and working from there does not work, because with every **`npm install`**, the package is removed from **node_modules**, since it's not registered in the project's **package.json**.

What we want, ideally, is to mimic what the end-user will do, when using our new package in their React Native project. Specifically, we want them to run **`npm install <our_published_package>`**, and have npm install and register the package properly, as well as have our dependencies placed in the proper areas (either in the **node_modules** of the project, or in the **node_modules** of the package).

This is the purpose of this tool.

Given a node package, in development, in **/path/to/my/package**

and a project, in development, in **/path/to/my/project**

calling **`mimic-npm-install.sh /path/to/my/package /path/to/my/project`** will mimic the behavior of the user calling **`npm install`** on the package, from the project, as if the package was published. The package will be registered in the project and installed into the project's **node_modules**, with all its dependencies downloaded and placed in the correct directories.
