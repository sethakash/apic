
#!/bin/bash
###############################################################################
#                               Documentation                                 #
###############################################################################
#                                                                             #
# Description                                                                 #
#     : This script consists of all the common utility functions.             #
#                                                                             #
# Note                                                                        #
#     : 1) If function argument ends with * then its required argument.       #
#       2) If function argument ends with ? then its optional argument.       #
#                                                                             #
###############################################################################
#                             Function Definitions                            #
###############################################################################


###
# Exit with given code
#
# Arguments:
#   exit_code*
#     - Exit code
#
function fn_exit(){

  exit_code=$1

  exit ${exit_code}

}


###
# Utility method to support unit testing to mock exit codes
# All functions should pass the exit code to this function and
# use the value return to check the exit code.
# Arguments:
#   exit_code*
#     - Exit code
#
function fn_get_exit_code(){

  exit_code=$1

  echo ${exit_code}

}

###
# Assert if given variable is set.
# If variable is,
#    Set - Do nothing
#    Empty - Exit with failure message
#
# Arguments:
#   variable_name*
#     - Name of the variable
#   variable_value*
#     - Value of the variable
#
function fn_assert_variable_is_set(){

  variable_name=$1

  variable_value=$2

  if [ "${variable_value}" == "" ]
  then

    exit_code=${EXIT_CODE_VARIABLE_NOT_SET}

    failure_messages="${variable_name} variable is not set"

    fn_exit_with_failure_message "${exit_code}" "${failure_messages}"

  fi

}

###
# Log given failure message and exit the script
# with given exit code
#
# Arguments:
#   exit_code*
#     - Exit code to be used to exit with
#   failure_message*
#     - Failure message to be logged
#
function fn_exit_with_failure_message(){

  exit_code=$1

  failure_message=$2

  fn_log_error "${failure_message}"

  fn_exit ${exit_code}

}


###
# Check the exit code.
# If exit code is,
#   Success - Log the success message and return
#   Failure - Log the failure message and exit with
#             the same exit code based on flag.
#
# Arguments:
#   exit_code*
#     - Exit code to be checked
#   success_message*
#     - Message to be logged if the exit code is zero
#   failure_message*
#     - Message to be logged if the exit code is non-zero
#   fail_on_error?
#     - If this flag is set then exit with the same exit code
#       Else write error message and return.
#
function fn_handle_exit_code(){

  exit_code=$1

  success_message=$2

  failure_message=$3

  fail_on_error=$4

  if [ "${exit_code}" != "$EXIT_CODE_SUCCESS" ]
  then

    fn_log_error "${failure_message}"

    if [ "${fail_on_error}" != "$EXIT_CODE_SUCCESS" ]
    then

      fn_exit ${exit_code}

    fi

  else

    fn_log_info "${success_message}"

  fi

}


###
# Check if the executable/command exists or not
#
# Arguments:
#   exit_code*
#     - Exit code to be checked
#   fail_on_error?
#     - If this flag is set then exit with the same exit code
#       Else write error message and return.
#
function fn_assert_executable_exists() {

  executable=$1

  fail_on_error=$2

  if ! type "${executable}" > /dev/null; then

    fn_log_error "Executable ${executable} does not exists"

    if [ "${fail_on_error}" == "${BOOLEAN_TRUE}" ];
    then

      fn_exit ${EXIT_CODE_EXECUTABLE_NOT_PRESENT}

    fi
  fi

}

###
# check if the file exist
#
# Arguments:
#   File path
#     - The path that needs to be checked
#   fail_on_error?
#     - If this flag is set then exit with the same exit code
#       Else write error message and return.
#
function fn_assert_file_exists() {

  file_path="$1"

  fail_on_error=$2

  if [ ! -f "${file_path}" ]; then

    fn_log_error "File ${file_path} does not exists"

    if [ "${fail_on_error}" == "${BOOLEAN_TRUE}" ];
    then

      fn_exit ${EXIT_CODE_FILE_DOES_NOT_EXIST}

    fi
  fi

}

###
# check if the file is empty
#
# Arguments:
#   File path
#     - The path that needs to be checked
#   fail_on_error?
#     - If this flag is set then exit with the same exit code
#       Else write error message and return.
#
function fn_assert_file_not_empty(){

  file_to_be_checked="${1}"

  fn_assert_variable_is_set "file_to_be_checked" "${file_to_be_checked}"

  fn_assert_file_exists "${file_to_be_checked}" "${BOOLEAN_TRUE}"

  if [ ! -s "${file_to_be_checked}" ]; then

    fn_log_error "File ${file_to_be_checked} is empty"

    fn_exit ${EXIT_CODE_FILE_IS_EMPTY}

  fi

}

###
# runs the java code
#
# Arguments:
#   module_home
#     - The path to the modules home
#   variables
#     - External variable to be passed to the java code
#
function fn_run_java(){

  fn_assert_executable_exists "java" "${BOOLEAN_TRUE}"

  module_home="${1}"

  fn_assert_variable_is_set "MODULE_HOME" "${module_home}"

  MODULE_CLASSPATH=""

  for i in $module_home/lib/*.jar; do
    MODULE_CLASSPATH=$MODULE_CLASSPATH:$i
  done

  MODULE_CLASSPATH=`echo $MODULE_CLASSPATH | cut -c2-`

  java -cp "${MODULE_CLASSPATH}" ${@:2}

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully executed java command for module ${module_home}"

  failure_message="Failed to execute java command for module ${module_home} ${@:2}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# chown the local directory
#
# Arguments:
#   Directory path
#     - The path that needs to be owned
#   User Name
#     - Name of the user to own the directory
#   recursively
#     - If to be done recursively
#
#
function fn_chown_local_directory(){

  directory_path="$1"

  user_name="$2"

  recursively="$3"

  fail_on_error="$4"

  fn_assert_variable_is_set "directory_path" "${directory_path}"

  fn_assert_variable_is_set "user_name" "${user_name}"

  RECURSIVELY=""

  if [ "${recursively}" == "${BOOLEAN_TRUE}" ]; then

    RECURSIVELY="-R"

  fi

  chown ${RECURSIVELY} "${user_name}" "${directory_path}"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully changed ownership of directory ${directory_path} to ${user_name}"

  failure_message="Failed to change ownership of directory ${directory_path} to ${user_name}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# create local directory
#
# Arguments:
#   File path
#     - The path that needs to be created
#   fail_on_error?
#     - If this flag is set then exit with the same exit code
#       Else write error message and return.
#
function fn_create_local_directory(){

  directory_path="$1"

  fail_on_error="$2"

  fn_assert_variable_is_set "directory_path" "${directory_path}"

  mkdir -p "${directory_path}"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully created directory ${directory_path}"

  failure_message="Failed to create directory ${directory_path}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

################################################################################
#                                     End                                      #
################################################################################

