First off, thank you for considering contributing to ONAP on Vagrant project.
It's people like you that make it such a great tool.

ONAP on Vagrant is an open source project and we love to receive contributions
from our community — you! There are many ways to contribute, from writing
tutorials or blog posts, improving the documentation, submitting bug reports and
feature requests or writing code which can be incorporated into ONAP on Vagrant
itself.

Unit Testing
============

The _tests_ folder contains scripts that ensure the proper implementation of the
functions created on _lib_ folder.  In order to execute all the Unit Tests
defined for this project, you must run the following commands:

    $ export DEPLOY_MODE=testing
    $ ./helpers/cleanup.sh testing
