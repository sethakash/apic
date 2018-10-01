
#!/bin/bash
###############################################################################
#                               Documentation                                 #
###############################################################################
#                                                                             #
# Description                                                                 #
#     :                                                                       #
#                                                                             #
#                                                                             #
#                                                                             #
###############################################################################
#                           Identify Script Home                              #
###############################################################################
#Find the script file home
pushd . > /dev/null
SCRIPT_DIRECTORY="${BASH_SOURCE[0]}";
while([ -h "${SCRIPT_DIRECTORY}" ]);
do
  cd "`dirname "${SCRIPT_DIRECTORY}"`"
  SCRIPT_DIRECTORY="$(readlink "`basename "${SCRIPT_DIRECTORY}"`")";
done
cd "`dirname "${SCRIPT_DIRECTORY}"`" > /dev/null
SCRIPT_DIRECTORY="`pwd`";
popd  > /dev/null
MODULE_HOME="`dirname "${SCRIPT_DIRECTORY}"`"
###############################################################################
#                           Import Dependencies                               #
###############################################################################

#Load common dependencies
. ${MODULE_HOME}/bin/constants.sh
. ${MODULE_HOME}/bin/log-functions.sh
. ${MODULE_HOME}/bin/common-functions.sh

###############################################################################
#                                                                             #
###############################################################################

module_script_file="${1}"

fn_assert_variable_is_set "module_script_file" "${module_script_file}"

if [ "${RUN_WITH_SUDO}" == "${BOOLEAN_TRUE}" ]
then

  fn_assert_variable_is_set "APPLICATION_USER" "${APPLICATION_USER}"

  sudo -u "${APPLICATION_USER}" -s "/bin/bash" "-c" "${1} ${*:2}"
  
else

  "/bin/bash" "-c" "${1} ${*:2}"

fi

exit_code=$?

success_message="Successfully executed module script ${module_script_file}"

failure_message="Failed to execute module script ${module_script_file}"

fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${BOOLEAN_TRUE}"

###############################################################################
#                                     End                                     #
###############################################################################
