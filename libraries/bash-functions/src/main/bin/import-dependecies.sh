
#!/bin/bash
###############################################################################
#                               Documentation                                 #
###############################################################################
#                                                                             #
# Description                                                                 #
#     : This script contains declaration of all dependent scripts             #
#                                                                             #
#                                                                             #
#                                                                             #
###############################################################################
#                               Declarations                                  #
###############################################################################

if [ "${CONFIG_HOME}" == "" ]
then
  PROJECT_HOME="`dirname "${MODULE_HOME}"`"
  CONFIG_HOME="${PROJECT_HOME}/config"
fi

. ${MODULE_HOME}/bin/constants.sh
. ${CONFIG_HOME}/bash-env.properties
. ${MODULE_HOME}/bin/log-functions.sh
. ${MODULE_HOME}/bin/common-functions.sh
. ${MODULE_HOME}/bin/hadoop-functions.sh

###############################################################################
#                                     End                                     #
###############################################################################

