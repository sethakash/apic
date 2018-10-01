
#!/bin/bash
###############################################################################
#                               Documentation                                 #
###############################################################################
#                                                                             #
# Description                                                                 #
#     : This script contains declaration of all the constants.                #
#                                                                             #
# Note                                                                        #
#     : 1) Do not modify values of constants declared as final.               #
#       2) Exit code shall always be be greater than 0 and less               #
#          than 256.                                                          #
#                                                                             #
#                                                                             #
###############################################################################
#                             Constant Declarations                           #
###############################################################################

###
# Integer representation of boolean true
# @Type  : Integer
# @Final : true
BOOLEAN_TRUE=1

###
# Integer representation of boolean false
# @Type  : Integer
# @Final : true
BOOLEAN_FALSE=0

###
# Constant to represent flag to fail in case of
# some error situation.
# @Type  : Integer
# @Final : true
FAIL_ON_ERROR=1

###
# Constant to represent exit code returned by
# successful execution of command/function
# @Type  : Integer
# @Final : true
EXIT_CODE_SUCCESS=0

###
# Constant to represent exit code returned by
# un-successful execution of command/function
# @Type  : Integer
# @Final : true
EXIT_CODE_FAIL=1

###
# Constant to represent exit code that should be
# returned when value for a required variable is
# not set.
# @Type  : Integer
# @Final : true
EXIT_CODE_VARIABLE_NOT_SET=2


###
# Constant to represent exit code that should be
# returned when a file is found to be empty
# @Type  : Integer
# @Final : true
EXIT_CODE_FILE_IS_EMPTY=3


###
# Constant to represent exit code that should be
# returned when file does not exists
# @Type  : Integer
# @Final : true
EXIT_CODE_FILE_DOES_NOT_EXIST=4


###############################################################################
#                                     End                                     #
###############################################################################
