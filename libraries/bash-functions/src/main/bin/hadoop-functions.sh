
#!/bin/bash
###############################################################################
#                               Documentation                               #
###############################################################################
#                                                                             #
# Description                                                                 #
#     : This script consists of all the hadoop related utility functions.      #
#                                                                             #
# Note                                                                        #
#     : 1) If function argument ends with * then its required argument.       #
#       2) If function argument ends with ? then its optional argument.       #
#                                                                             #
###############################################################################
#                             Function Definitions                            #
###############################################################################

###
# Delete HDFS directory
#
# Arguments:
#   directory*
#     - path of the directory to be created
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_delete_hdfs_directory(){

  fn_assert_executable_exists "hdfs" "${BOOLEAN_TRUE}"

  directory=$1

  fail_on_error=$2

  fn_assert_variable_is_set "directory" "${directory}"

  hdfs dfs -test -e "${directory}"

  exit_code=`fn_get_exit_code $?`

  if [ "${exit_code}" == "$EXIT_CODE_SUCCESS" ]
  then

    hdfs dfs -rm -r "${directory}"

    exit_code=`fn_get_exit_code $?`

    success_message="Deleted hdfs directory ${directory}"

    failure_message="Failed to delete hdfs directory ${directory}"

    fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

  else

    fn_log_info "HDFS directory ${directory} does not exist"

  fi

}

###
# Create HDFS directory
#
# Arguments:
#   directory*
#     - path of the directory to be created
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_create_hdfs_directory(){

  fn_assert_executable_exists "hdfs" "${BOOLEAN_TRUE}"

  directory=$1

  fail_on_error=$2

  fn_assert_variable_is_set "directory" "${directory}"

  hdfs dfs -test -e "${directory}"

  exit_code=`fn_get_exit_code $?`

  if [ "${exit_code}" != "$EXIT_CODE_SUCCESS" ]
  then

    hdfs dfs -mkdir -p "${directory}"

    exit_code=`fn_get_exit_code $?`

    success_message="Created HDFS directory ${directory}"

    failure_message="Failed to create HDFS directory ${directory}"

    fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

  else

    fn_log_info "HDFS directory ${directory} already exists"

  fi
}

###
# Create HDFS directory
#
# Arguments:
#   directory*
#     - path of the directory to be created
#   dir_chmod
#     - chmod for the directory
#   recursive
#     - should it be recursive
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_chmod_hdfs_directory(){

  fn_assert_executable_exists "hdfs" "${BOOLEAN_TRUE}"

  directory=$1

  dir_chmod=$2

  recursive=$3

  fail_on_error=$4

  fn_assert_variable_is_set "directory" "${directory}"

  hdfs dfs -test -e "${directory}"

  exit_code=`fn_get_exit_code $?`

  if [ "${exit_code}" != "$EXIT_CODE_SUCCESS" ]
  then

    fn_log_warn "HDFS directory ${directory} does not exists"

  else

    if [ "${recursive}" != "$BOOLEAN_TRUE" ]
    then

      hdfs dfs -chmod ${dir_chmod} "${directory}"

    else

      hdfs dfs -chmod -R ${dir_chmod} "${directory}"

    fi

    exit_code=`fn_get_exit_code $?`

    success_message="Updated chmod for HDFS directory ${directory} to ${dir_chmod}"

    failure_message="Failed to update chmod for HDFS directory ${directory} to ${dir_chmod}"

    fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

  fi
}

###
# chown the hdfs directory
#
# Arguments:
#   Directory path
#     - The path that needs to be owned
#   User Name
#     - Name of the user to own the directory
#   recursively
#     - If to be done recursively
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_chown_hdfs_directory(){

  fn_assert_executable_exists "hdfs" "${BOOLEAN_TRUE}"

  directory=$1

  user_group=$2

  recursive=$3

  fail_on_error=$4

  fn_assert_variable_is_set "directory" "${directory}"

  hdfs dfs -test -e "${directory}"

  exit_code=`fn_get_exit_code $?`

  if [ "${exit_code}" != "$EXIT_CODE_SUCCESS" ]
  then

    fn_log_warn "HDFS directory ${directory} does not exists"

  else

    if [ "${recursive}" != "$BOOLEAN_TRUE" ]
    then

      hdfs dfs -chown ${user_group} "${directory}"

    else

      hdfs dfs -chown -R ${user_group} "${directory}"

    fi

    exit_code=`fn_get_exit_code $?`

    success_message="Updated chown for HDFS directory ${directory} to ${user_group}"

    failure_message="Failed to update chown for HDFS directory ${directory} to ${user_group}"

    fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

  fi
}


###
# Create Kafka Topic
#
# Arguments:
#
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_execute_kafka_topics_command(){

  fn_assert_variable_is_set "KAFKA_HOME" "${KAFKA_HOME}"

  fn_log_info "Executing kafka-topics.sh command with arguments $@"

  ${KAFKA_HOME}/bin/kafka-topics.sh "$@"

  exit_code=`fn_get_exit_code $?`

  fail_on_error=${BOOLEAN_TRUE}

  success_message="Successfully executed kafka-topics.sh command"

  failure_message="Failed to execute kafka-topics.sh command"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# create external hive database
#
# Arguments:
#   db_name
#     - Name of the Database
#   db_location
#     - Location of the Database
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_create_external_hive_database(){

  fn_assert_executable_exists "hive" "${BOOLEAN_TRUE}"

  db_name=$1

  db_location=$2

  fail_on_error=$3

  fn_assert_variable_is_set "db_name" "${db_name}"

  fn_assert_variable_is_set "db_location" "${db_location}"

  hive -i "${CONFIG_HOME}/hive-env.properties" -e "CREATE DATABASE IF NOT EXISTS ${db_name} LOCATION '${db_location}'"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully created ${db_name} database"

  failure_message="Failed to create ${db_name} database"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# run hive script
#
# Arguments:
#   module_home
#     - home path of the module
#   hive_initialization_script
#     - initialization of hive script
#   hive_script
#     - the script to be run
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_run_hive(){

  fn_assert_executable_exists "hive" "${BOOLEAN_TRUE}"

  module_home="${1}"

  fn_assert_variable_is_set "Module Home" "${1}"

  hive_initialization_script="$2"

  fn_assert_file_exists "${hive_initialization_script}" "${BOOLEAN_TRUE}"

  hive_script="$3"

  fn_assert_file_exists "${hive_script}" "${BOOLEAN_TRUE}"

  fail_on_error=$4

  fn_assert_variable_is_set "hive_script" "${hive_script}"

  hive -i "${CONFIG_HOME}/hive-env.properties" -i "${hive_initialization_script}" -f "${hive_script}"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully executed hive script ${hive_script}"

  failure_message="Failed to execute hive script ${hive_script}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# Update hive partition metadata
#
# Arguments:
#   hive_table
#     - name of the hive table
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_update_hive_partition_metadata(){

  fn_assert_executable_exists "hive" "${BOOLEAN_TRUE}"

  hive_table="$1"

  fn_assert_variable_is_set "hive_table" "${hive_table}"

  fail_on_error="$2"

  hive -i "${CONFIG_HOME}/hive-env.properties" -e "MSCK REPAIR TABLE ${hive_table}"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully updated hive table ${hive_table} partition metadata"

  failure_message="Failed to update hive table ${hive_table} partition metadata"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}


###
# Create Kafka Topic
#
# Arguments:
#
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_create_kafka_topic(){

  fn_assert_variable_is_set "KAFKA_HOME" "${KAFKA_HOME}"

  fn_assert_variable_is_set "KAFKA_ZOOKEEPER_CONNECTION_STRING" "${KAFKA_ZOOKEEPER_CONNECTION_STRING}"

  topic_name=$1

  no_of_partitions=$2

  replication_factor=$3

  fn_assert_variable_is_set "topic_name" "${topic_name}"

  fn_assert_variable_is_set "no_of_partitions" "${no_of_partitions}"

  fn_assert_variable_is_set "replication_factor" "${replication_factor}"

  fail_on_error=$4

  ${KAFKA_HOME}/bin/kafka-topics.sh --zookeeper ${KAFKA_ZOOKEEPER_CONNECTION_STRING} --list | grep -Fx  "${topic_name}"

  topic_exists=`fn_get_exit_code $?`

  if [ "${topic_exists}" == "$EXIT_CODE_SUCCESS" ]
  then

    fn_log_warn "Topic ${topic_name} already exists"

  else

    fn_log_info "Creating kafka topic with arguments $@"

    ${KAFKA_HOME}/bin/kafka-topics.sh \
    --zookeeper ${KAFKA_ZOOKEEPER_CONNECTION_STRING} \
    --create \
    --topic ${topic_name} \
    --partitions ${no_of_partitions} \
    --replication-factor ${replication_factor}

    exit_code=`fn_get_exit_code $?`

    success_message="Successfully created  kafka topic ${topic_name}"

    failure_message="Failed to create kafka topic ${topic_name}"

    fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

  fi

}

###
# run kafka mirror
#
# Arguments:
#   consumer
#     - kafka consumer
#   producer
#     - kafka producer
#   number of streams
#     - number of streams in kafka
#   topic whitelist
#     - kafka topic
function fn_run_kafka_mirror(){

  fn_assert_variable_is_set "KAFKA_HOME" "${KAFKA_HOME}"

  fn_assert_variable_is_set "Consumer Config File" "$1"

  fn_assert_variable_is_set "Producer Config File" "$2"

  fn_assert_variable_is_set "Number of Streams" "$3"

  fn_assert_variable_is_set "Topic Whitelist" "$4"

  ${KAFKA_HOME}/bin/kafka-run-class.sh kafka.tools.MirrorMaker --consumer.config "$1" --producer.config "$2" --num.streams $3 --whitelist "$4"

  exit_code=`fn_get_exit_code $?`

  fn_exit "${exit_code}"

}

###
# run camus job
#
# Arguments:
#   module_home
#     - home path of the module
#   Camus Properties
#     - properties for camus
#   Output table name
#     - Name of the output table
#
function fn_run_camus(){

  fn_assert_executable_exists "hadoop" "${BOOLEAN_TRUE}"

  fn_assert_variable_is_set "CAMUS_HOME" "${CAMUS_HOME}"

  fn_assert_variable_is_set "MODULE_HOME" "$1"

  fn_assert_variable_is_set "Camus Properties" "$2"

  fn_assert_variable_is_set "Output table name" "$3"

  ${CAMUS_HOME}/bin/camus.sh \
  -Dconf.dir=${MODULE_HOME}/etc/camus \
  -P "$2"

  exit_code=`fn_get_exit_code $?`

  if [ ${exit_code} -eq $EXIT_CODE_SUCCESS ]
  then

    fn_update_hive_partition_metadata "$3" "${BOOLEAN_TRUE}"

  else

    fn_exit "${exit_code}"

  fi


}


###
# run pig script
#
# Arguments:
#   module_home
#     - home path of the module
#   pig_properties_files
#     - pig property file
#   pig_script
#     - the script to be run
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_run_pig(){

  fn_assert_executable_exists "pig" "${BOOLEAN_TRUE}"

  module_home="${1}"

  pig_properties_file="${2}"

  pig_script_file="${3}"

  fn_assert_variable_is_set "module_home" "${module_home}"

  fn_assert_variable_is_set "pig_properties_file" "${pig_properties_file}"

  fn_assert_variable_is_set "pig_script_file" "${pig_script_file}"

  PIG_ADDITIONAL_PARAMS="-param MODULE_HOME=${module_home} ${PIG_ADDITIONAL_PARAMS}"

  PIG_ADDITIONAL_JARS="${SHARED_LIB}/piggy-bank.jar"

  for i in $module_home/lib/*.jar; do
    PIG_ADDITIONAL_JARS=$PIG_ADDITIONAL_JARS:$i
  done

  pig -Dudf.import.list=${tvar_root_group_id}.piggybank \
  -Dpig.additional.jars=${PIG_ADDITIONAL_JARS} \
  -useHCatalog ${PIG_ADDITIONAL_PARAMS} \
  -param_file "${CONFIG_HOME}/pig-env.properties" \
  -param_file "${pig_properties_file}" "${pig_script_file}"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully executed pig script ${pig_script_file}"

  failure_message="Failed to execute pig script ${pig_script_file}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${BOOLEAN_TRUE}"


}

###
# download hadoop file
#
# Arguments:
#   hadoop_file
#     - The file on hadoop that is to be downloaded
#   target_file
#     - target path for the file
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_hadoop_download_file(){

  hadoop_file="$1"

  target_file="$2"

  fail_on_error="$3"

  fn_assert_executable_exists "hadoop" "${BOOLEAN_TRUE}"

  fn_assert_variable_is_set "hadoop_file" "${hadoop_file}"

  fn_assert_variable_is_set "target_file" "${target_file}"

  hadoop fs -copyToLocal "${hadoop_file}" "${target_file}"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully downloaded hadoop file ${hadoop_file}"

  failure_message="Failed to download hadoop file ${hadoop_file} to local file ${target_file}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# run hive to redshift export
#
# Arguments:
#   module_home
#     - home path of the module
#   configuration_file
#     - path of the configuration file
#   app_name
#     - name of the app
#   input table
#     - name of the input table
#   output table
#     - name of the output table
#
function fn_run_hive_to_redshift_export(){

  fn_assert_variable_is_set "TOOLS_INSTALL_DIR" "${TOOLS_INSTALL_DIR}"

  fn_assert_executable_exists "${TOOLS_INSTALL_DIR}/redshift-export/bin/redshift-export.sh" "${BOOLEAN_TRUE}"

  module_home="${1}"

  configuration_file="${2}"

  app_name="${3}"

  input_table="${4}"

  output_table="${5}"

  fn_assert_variable_is_set "module_home" "${module_home}"

  fn_assert_variable_is_set "configuration_file" "${configuration_file}"

  fn_assert_variable_is_set "app_name" "${app_name}"

  fn_assert_variable_is_set "input_table" "${input_table}"

  fn_assert_variable_is_set "output_table" "${output_table}"

  ${TOOLS_INSTALL_DIR}/redshift-export/bin/redshift-export.sh \
  "${configuration_file}" \
  "${app_name}" \
  "${input_table}" \
  "${output_table}"
}

###
# export history to backup
#
# Arguments:
#   mount path
#     - mount path for history
#   export path
#
function fn_export_history_to_backup(){


  mount_path="${1}"

  export_path="${2}"

  timestamp=$(date +%Y%m%d%H%M)

  fn_assert_variable_is_set "mount_path" "${mount_path}"

  fn_assert_variable_is_set "export_path" "${export_path}"

  hdfs dfs -mkdir ${export_path}/${timestamp}

  hdfs dfs -cp -f "${mount_path}" \
  ${export_path}/${timestamp}

  exit_code=`fn_get_exit_code $?`

  if [ ${exit_code} -eq $EXIT_CODE_SUCCESS ]
  then

    hdfs dfs -rm -r "${mount_path}/*"

  else

    fn_exit "${exit_code}"

  fi

  success_message="Successfully transferred History load to  Backup ${export_path} "

  failure_message="Failed to transfer to Backup ${export_path}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"
}

###
# copy file from local to hadoop
#
# Arguments:
#   local file
#     - path of the local file
#   hadoop directory
#     - hadoop directory
#   overwrite
#     - overwrite the current file
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_copy_file_from_local_to_hadoop(){

  local_file="$1"

  hadoop_directory="$2"

  overwrite=${3:-false}

  fail_on_error="$4"

  fn_assert_variable_is_set "local_file" "${local_file}"

  fn_assert_variable_is_set "hadoop_directory" "${hadoop_directory}"

  fn_assert_variable_is_set "overwrite" "${overwrite}"

  if [ "${overwrite}" == "false" ]
  then

    hdfs dfs -copyFromLocal  "${local_file}" "${hadoop_directory}"

  else

    if [ "${overwrite}" == "true" -o "TRUE" ]
    then

      hdfs dfs -copyFromLocal -f  "${local_file}" "${hadoop_directory}"

    fi
  fi


  exit_code=`fn_get_exit_code $?`

  success_message="Successfully copied local file ${local_file} to hadoop directory ${hadoop_directory}"

  failure_message="Failed to copy local file ${local_file} to hadoop directory ${hadoop_directory}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# drop hive partition
#
# Arguments:
#   table_name
#     - name of the table whose partition is to be dropped
#   partition name
#     - name of the partition to be dropped
#   partition value
#     - value of the partition to be dropped
#   fail_on_error?
#     - Flag to decide, in case of failure of this operation, wheather to exit the process
#       with error code or just write error message and return.
#
function fn_drop_hive_partition(){

  table_name="$1"

  partition_name="$2"

  partition_value="$3"

  fail_on_error="$4"

  fn_assert_variable_is_set "table_name" "${table_name}"

  fn_assert_variable_is_set "partition_name" "${partition_name}"

  fn_assert_variable_is_set "partition_value" "${partition_value}"

  hive -i "${CONFIG_HOME}/hive-env.properties" -e "ALTER TABLE ${table_name} DROP IF EXISTS PARTITION ( ${partition_name} = ${partition_value} );"

  exit_code=`fn_get_exit_code $?`

  success_message="Table Partition deleted successfully"

  failure_message="Failed to delete the table partition"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${fail_on_error}"

}

###
# run redshift script
#
# Arguments:
#   redshift_credentials_file
#     - redshift credential file
#   redshift_script
#     - script to be run
#
function fn_run_redshift_script(){

  fn_assert_variable_is_set "TOOLS_INSTALL_DIR" "${TOOLS_INSTALL_DIR}"

  fn_assert_executable_exists "${TOOLS_INSTALL_DIR}/redshift-connector/bin/redshift-connector.sh" "${BOOLEAN_TRUE}"

  redshift_credentials_file="${1}"

  redshift_script="${2}"

  fn_assert_variable_is_set "redshift_credentials_file" "${redshift_credentials_file}"

  fn_assert_variable_is_set "redshift_script" "${redshift_script}"

  ${TOOLS_INSTALL_DIR}/redshift-connector/bin/redshift-connector.sh \
  "${redshift_credentials_file}" \
  "${redshift_script}"

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully executed redshift script ${redshift_script}"

  failure_message="Failed to execute redshift script ${redshift_script}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${BOOLEAN_TRUE}"

}

###
# run mapreduce
#
# Arguments:
#   module_home
#     - home path of the module
#   mapreduce jars
#     - jars for mapreduce
#   mapreduce driver
#     - driver for mapreduce
function fn_run_mapreduce(){

  fn_assert_executable_exists "yarn" "${BOOLEAN_TRUE}"

  module_home="$1"

  mapreduce_jar="$2"

  mapreduce_driver="$3"

  fn_assert_variable_is_set "module_home" "$module_home"

  fn_assert_variable_is_set "mapreduce_jar" "$mapreduce_jar"

  fn_assert_variable_is_set "mapreduce_driver" "$mapreduce_driver"

  yarn jar "${mapreduce_jar}" "${mapreduce_driver}" ${@:4}

  exit_code=`fn_get_exit_code $?`

  success_message="Successfully executed mapreduce job ${mapreduce_driver}"

  failure_message="Failed to execute mapreduce job ${mapreduce_driver}"

  fn_handle_exit_code "${exit_code}" "${success_message}" "${failure_message}" "${BOOLEAN_TRUE}"

}


################################################################################
#                                     End                                      #
################################################################################

