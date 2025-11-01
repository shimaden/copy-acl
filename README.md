# copy-acl
Copy the access permissions (ACLs) of the "Unknown User" to another user.

When Windows is clean-installed, files and directories on a drive used in the previous environment may have their access permissions assigned to an "Unknown User".
It is not possible to directly replace this "Unknown User" with the login user of the current Windows environment.
Therefore, while leaving the "Unknown User" entry intact, this operation copies the access permissions of the "Unknown User" to the login user that exists in the current environment.
