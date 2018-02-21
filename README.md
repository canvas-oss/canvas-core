# canvas-oss / canvas-core
## canvas
CANVAS Common Application & Network Vulnerability Assessment System is a computer program whose purpose is to to identify and assess known vulnerabilities on an information system.

## canvas-core
CANVAS CORE is a component of CANVAS. It include the CANVAS's database and include the assessment engine.

## License
CANVAS including all its components is distributed under the CeCILL licence. Please see the [LICENSE.CECILL-FR](https://github.com/canvas-oss/canvas-core/blob/master/LICENSE.CECILL-FR) and [LICENSE-CECILL-EN](https://github.com/canvas-oss/canvas-core/blob/master/LICENSE.CECILL-EN) documents for more informations.

## Documentation
The CANVAS general documentation is available at the main [repository's wiki]().
A specific documentation is available on this [repository's wiki]().

## Installation steps
### Dependencies
Mo - Mustache Templates in Bash is required in order to make SQL source files. You can find information about Mo at [Mo - Mustache Templates in Bash](https://github.com/tests-always-included/mo). No installation of Mo is required.

### Steps
- You have to clone this repository including git submodule:
```
# git submodule init
# git submodule update
```
- Then you have to make SQL files (you can edit the main Makefile in order to customize database names). Make files from root directory:
```
# make
```
- Some SQL files will be generated into the ```database/canvas_data``` directory
- Finally import them as SQL script into your DBMS

## Contribution guidelines

## Contact

### Issues
