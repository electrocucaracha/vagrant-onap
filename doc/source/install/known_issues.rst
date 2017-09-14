============
Known Issues
============

Virtualbox guest additions conflict with shared directories
-----------------------------------------------------------

If the **vagrant-vbguest** plugin is installed on the host, then an
updated version of the Virtualbox guest additions will be installed
on the guest in the /opt directory.  Once this projects Vagrantfile
mounts the ./opt directory on the host to the /opt directory on the
guest during the provisioning process, the guest addtions on the
guest are hidden and subsequent mounts of shared directories with the
host will fail.

The simplest workaround appears to be uninstalling the
*vagrant-vbguest* plugin on the host system.  This has been observed
to work on a Windows 10 host using virtualbox 5.1.26.

Check if vagrant-vbguest plugin is installed

- Linux or Mac

.. code-block:: console

    $ vagrant plugin list
.. end

- Windows

.. code-block:: console

    C:\> vagrant plugin list
.. end

Remove vagrant-vbguest plugin

- Linux or Mac

.. code-block:: console

    $ vagrant plugin uninstall vagrant-vbguest
.. end

- Windows

.. code-block:: console

    C:\> vagrant plugin uninstall vagrant-vbguest
.. end
