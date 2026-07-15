3D Printing
=

A collection of 3d printing related files

This repository does rely on submodules for things like YAPP and BOSL2.  To get those in your repository run the following command after checking out the repository

```bash
git submodule update --init --recursive
```

If you want to update them to their latest versions later down the line you can run

```bash
git submodule update --remote --merge --recursive
```

or 

```bash
git pull --recurse-submodules
```
