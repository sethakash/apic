
#!/bin/bash
#                               Documentation                                 #
#                                                                             #
# Description                                                                 #
#     : This script consists of all the common utility functions.             #
#                                                                             #
# Note                                                                        #
#     : 1) If function argument ends with * then its required argument.       #
#       2) If function argument ends with ? then its optional argument.       #
#                                                                             #
#                             Function Definitions                            #

# teradata to raw incremental load
#
# Arguments:
#   tdch_jars
#       -The path to the required tdch jars
#   job_queue_name
#       -The job queue name that is to be used
#   num_map
#       -The number of mappers to be used
#   teradata_env
#       -The teradata enviroment
#   terdata_database
#       -The teradata database to be used
#   teradata_username
#       -The user to be used
#   teradata_psswd
#       -The password for the teradata user
#   target_path
#       -The path where you want to store the data
#   teradata_source_tablename
#       -The source table that needs to be extracted
#   source_condition
#       -The source condition to be used
#
fn_run_teradata_to_raw_incremental(){

  tdch_jar=$1

  fn_assert_variable_is_set "tdch_jar" "${tdch_jar}"

  job_queue_name=$2

  fn_assert_variable_is_set "job_queue_name" "${job_queue_name}"

  num_map=$3

  fn_assert_variable_is_set "num_map" "${num_map}"

  teradata_env=$4

  fn_assert_variable_is_set "teradata_env" "${teradata_env}"

  teradata_database=$5

  fn_assert_variable_is_set "teradata_database" "${teradata_database}"

  teradata_username=$6

  fn_assert_variable_is_set "teradata_username" "${teradata_username}"

  teradata_psswd=$7

  fn_assert_variable_is_set "teradata_psswd" "${teradata_psswd}"

  export target_path=$8

  fn_assert_variable_is_set "target_path" "${target_path}"

  teradata_source_tablename=$9

  fn_assert_variable_is_set "teradata_source_tablename" "${teradata_source_tablename}"

  source_condition=${10}

  fn_assert_variable_is_set "source_condition" "${source_condition}"

  fn_delete_hdfs_directory "${target_path}"

  hadoop jar "${tdch_jar}" \
       com.teradata.connector.common.tool.ConnectorImportTool \
       -D mapreduce.job.queuename=${job_queue_name} \
       -D tdch.num.mappers=${num_map} \
       -classname com.teradata.jdbc.TeraDriver \
       -url jdbc:teradata://${teradata_env}/DATABASE=${teradata_database},CHARSET=UTF16 \
       -username ${teradata_username} \
       -password ${teradata_psswd} \
       -jobtype hdfs \
       -fileformat textfile \
       -separator '\u0001' \
       -targetpaths "${target_path}" \
       -sourcetable "${teradata_source_tablename}" \
       -sourceconditions "${source_condition}" \
       -nullstring '\N' \
   	   -nullnonstring '\N'

  exit_code=$?

  if [[ "${exit_code}" != "${EXIT_CODE_SUCCESS}" ]];then

        fn_delete_hdfs_directory "${target_path}"
        fn_exit_with_failure_message "1" "unable to fetch data from teradata"

  fi

}

# teradata to raw one time load
#
# Arguments:
#   tdch_jars
#       -The path to the required tdch jars
#   job_queue_name
#       -The job queue name that is to be used
#   num_map
#       -The number of mappers to be used
#   teradata_env
#       -The teradata enviroment
#   terdata_database
#       -The teradata database to be used
#   teradata_username
#       -The user to be used
#   teradata_psswd
#       -The password for the teradata user
#   target_path
#       -The path where you want to store the data
#   teradata_source_tablename
#       -The source table that needs to be extracted
#   source_condition
#       -The source condition to be used
#
fn_run_teradata_to_raw_one_time(){

  tdch_jar=$1

  fn_assert_variable_is_set "tdch_jar" "${tdch_jar}"

  job_queue_name=$2

  fn_assert_variable_is_set "job_queue_name" "${job_queue_name}"

  num_map=$3

  fn_assert_variable_is_set "num_map" "${num_map}"

  teradata_env=$4

  fn_assert_variable_is_set "teradata_env" "${teradata_env}"

  teradata_database=$5

  fn_assert_variable_is_set "teradata_database" "${teradata_database}"

  teradata_username=$6

  fn_assert_variable_is_set "teradata_username" "${teradata_username}"

  teradata_psswd=$7

  fn_assert_variable_is_set "teradata_psswd" "${teradata_psswd}"

  export target_path=$8

  fn_assert_variable_is_set "target_path" "${target_path}"

  teradata_source_tablename=$9

  fn_assert_variable_is_set "teradata_source_tablename" "${teradata_source_tablename}"

  source_condition=${10}

  fn_assert_variable_is_set "source_condition" "${source_condition}"

  fn_delete_hdfs_directory "${target_path}"

  hadoop jar "${tdch_jar}" \
       com.teradata.connector.common.tool.ConnectorImportTool \
       -D mapreduce.job.queuename=${job_queue_name} \
       -D tdch.num.mappers=${num_map} \
       -classname com.teradata.jdbc.TeraDriver \
       -url jdbc:teradata://${teradata_env}/DATABASE=${teradata_database},CHARSET=UTF16 \
       -username ${teradata_username} \
       -password ${teradata_psswd} \
       -jobtype hdfs \
       -fileformat textfile \
       -separator '\u0001' \
       -targetpaths "${target_path}" \
       -sourcetable "${teradata_source_tablename}" \
       -sourceconditions "${source_condition}" \
       -nullstring '\N' \
   	   -nullnonstring '\N'

  exit_code=$?

  if [[ "${exit_code}" != "${EXIT_CODE_SUCCESS}" ]];then

        fn_delete_hdfs_directory "${target_path}"
        fn_exit_with_failure_message "1" "unable to fetch data from teradata"

  fi

}

# Netezza to raw one time load
#
# Arguments:
#   job_queue_name
#       -The job queue name that is to be used
#   num_map
#       -The number of mappers to be used
#   netezza_env
#       -The teradata enviroment
#   netezza_database
#       -The teradata database to be used
#   netezza_username
#       -The user to be used
#   netezza_psswd
#       -The password for the teradata user
#   target_path
#       -The path where you want to store the data
#   netezza_source_tablename
#       -The source table that needs to be extracted
#   netezza_source_condition
#       -The source condition to be used
#   split_condition
#       -The split condition to be used
#
fn_run_netezza_to_raw_one_time(){

  job_queue_name=$1

  fn_assert_variable_is_set "job_queue_name" "${job_queue_name}"

  num_map=$2

  fn_assert_variable_is_set "num_map" "${num_map}"

  netezza_env=$3

  fn_assert_variable_is_set "netezza_env" "${netezza_env}"

  netezza_database=$4

  fn_assert_variable_is_set "netezza_database" "${netezza_database}"

  netezza_username=$5

  fn_assert_variable_is_set "netezza_username" "${netezza_username}"

  netezza_psswd=$6

  fn_assert_variable_is_set "netezza_psswd" "${netezza_psswd}"

  export target_path=$7

  fn_assert_variable_is_set "target_path" "${target_path}"

  netezza_source_tablename=$8

  fn_assert_variable_is_set "netezza_source_tablename" "${netezza_source_tablename}"

  netezza_source_condition=$9

  fn_assert_variable_is_set "netezza_source_condition" "${netezza_source_condition}"

  split_condition=${10}

  fn_assert_variable_is_set "split_condition" "${split_condition}"

  fn_delete_hdfs_directory "${target_path}"

  sqoop import  -D mapreduce.job.queuename="${job_queue_name}" \
                --connect jdbc:netezza://"${netezza_env}"/"${netezza_database}" \
                --username "${netezza_username}" \
                --password "${netezza_psswd}" \
                --table "${netezza_source_tablename}" \
                --target-dir "${target_path}" \
                --split-by "${split_condition}" \
                --m "${num_map}" \
                --fields-terminated-by "${FIELDS_TERMINATOR}" \
                --null-string '\\N' \
                --null-non-string '\\N'


  exit_code=$?

  if [[ "${exit_code}" != "${EXIT_CODE_SUCCESS}" ]];then

        fn_delete_hdfs_directory "${target_path}"
        fn_exit_with_failure_message "1" "unable to fetch data from netezza"

  fi

}

# Netezza to raw one time load
#
# Arguments:
#   job_queue_name
#       -The job queue name that is to be used
#   num_map
#       -The number of mappers to be used
#   netezza_env
#       -The teradata enviroment
#   netezza_database
#       -The teradata database to be used
#   netezza_username
#       -The user to be used
#   netezza_psswd
#       -The password for the teradata user
#   target_path
#       -The path where you want to store the data
#   netezza_source_tablename
#       -The source table that needs to be extracted
#   netezza_source_condition
#       -The source condition to be used
#   split_condition
#       -The split condition to be used
#
fn_run_netezza_to_raw_incremental(){

  job_queue_name=$1

  fn_assert_variable_is_set "job_queue_name" "${job_queue_name}"

  netezza_num_map=$2

  fn_assert_variable_is_set "netezza_num_map" "${netezza_num_map}"

  netezza_env=$3

  fn_assert_variable_is_set "netezza_env" "${netezza_env}"

  netezza_database=$4

  fn_assert_variable_is_set "netezza_database" "${netezza_database}"

  netezza_username=$5

  fn_assert_variable_is_set "netezza_username" "${netezza_username}"

  netezza_psswd=$6

  fn_assert_variable_is_set "netezza_psswd" "${netezza_psswd}"

  export target_path=$7

  fn_assert_variable_is_set "target_path" "${target_path}"

  netezza_source_tablename=$8

  fn_assert_variable_is_set "netezza_source_tablename" "${netezza_source_tablename}"

  netezza_source_condition=$9

  fn_assert_variable_is_set "netezza_source_condition" "${netezza_source_condition}"

  split_condition=${10}

  fn_assert_variable_is_set "split_condition" "${split_condition}"


  fn_delete_hdfs_directory "${target_path}"

  sqoop import  -D mapreduce.job.queuename="${job_queue_name}" \
                --connect jdbc:netezza://"${netezza_env}"/"${netezza_database}" \
                --username "${netezza_username}" \
                --password "${netezza_psswd}" \
                --table "${netezza_source_tablename}" \
                --target-dir "${target_path}" \
                --split-by "${split_condition}" \
                --m "${netezza_num_map}" \
                --fields-terminated-by "${FIELDS_TERMINATOR}" \
                --where "${netezza_source_condition}" \
                --null-string '\\N' \
                --null-non-string '\\N'

  exit_code=$?

  if [[ "${exit_code}" != "${EXIT_CODE_SUCCESS}" ]];then

        fn_delete_hdfs_directory "${target_path}"
        fn_exit_with_failure_message "1" "unable to fetch data from netezza"

  fi

}


#                                     End                                     #
