from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

import os.path

from ansible.plugins.action import ActionBase

class ActionModule(ActionBase):

    def run(self, tmp=None, task_vars=dict()):
        ''' handler for install_archive operations '''

        name = self._task.args.get('name', None)
        path = self._task.args.get('path', None)
        into = self._task.args.get('into', None)

        if name is None or path is None or into is None:
            return dict(failed=True, msg="Required argument is missing.")

        find = self._execute_module(
            module_name='find',
            module_args=dict(
                    paths=into,
                 patterns=name+'*',
                file_type='directory',
                  recurse='no'),
            task_vars=task_vars)

        if find.get('matched', 0):
            return dict(
                changed=False,
                    msg=name + " is already installed.",
                   path=find['files'][0]['path'])

        unarchive = self._execute_module(
            module_name='unarchive',
            module_args=dict(
                       src=path,
                      dest=into,
                      copy='no',
                list_files='yes'),
            task_vars=task_vars)

        if unarchive.get('failed', False):
            return unarchive
            # return dict(failed=True, msg="Unarchive failed.")

        files = unarchive.get('files', [])

        if not files:
            return dict(failed=True, msg="Archive is empty.")

        extract_root = lambda path: path.split('/')[0]

        root_dir = extract_root(files[0])

        if any(extract_root(f) != root_dir for f in files):
                return dict(failed=True, msg= "Archive does not contain "
                "single root directory.")

        arch_home = os.path.join(into, root_dir)
        arch_home = arch_home[:-1] if arch_home[-1] == '/' else arch_home

        return dict(changed=True, path=arch_home)
