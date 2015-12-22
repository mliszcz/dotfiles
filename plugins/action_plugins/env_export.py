from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

from ansible.plugins.action import ActionBase
from ansible.plugins.action.copy import ActionModule as CopyActionModule

class ActionModule(ActionBase):

    # TODO consider copy-paste-ing these functions from CopyActionModule
    # as their interface may chage some day

    def _create_content_tempfile(self, content):
        return CopyActionModule._create_content_tempfile.im_func(self, content)

    def _remove_tempfile_if_content_defined(self, content, content_tempfile):
        try:
            return CopyActionModule._remove_tempfile_if_content_defined \
            .im_func(self, content, content_tempfile)
        except OSError:
            return None

    def run(self, tmp=None, task_vars=dict()):
        ''' handler for env_export operations '''

        exports = self._task.args.get('vars', None)

        if exports is None:
            return dict(failed=True, msg="Missing 'vars' argument.")

        template_data = (
            '{% for entry in exports %}'
            '{% for key, value in entry.iteritems() %}'
            'export {{key}}="{{value}}"\n'
            '{% endfor %}'
            '{% endfor %}'
        )

        try:
            old_vars = self._templar._available_variables
            self._templar.set_available_variables(dict(exports=exports))
            content = self._templar.template(template_data,
                                             preserve_trailing_newlines=False)
            self._templar.set_available_variables(old_vars)
        except Exception as e:
            return dict(failed=True, msg=type(e).__name__ + ": " + str(e))

        # Manually write content to the tempfile.
        # This shall normally be handled by copy's action plugin,
        # but it seems that plugins are not executed when module
        # is run from another plugin.

        content_tempfile = self._create_content_tempfile(content)

        new_module_args = self._task.args.copy()
        new_module_args['src'] = content_tempfile
        new_module_args.pop('vars', None)

        copy_result = self._execute_module(
            module_name='copy',
            module_args=new_module_args,
            task_vars=task_vars)

        self._remove_tempfile_if_content_defined(content, content_tempfile)

        return copy_result
