#!/bin/bash
# https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-all-3.6.1.tar.gz
# https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip

prt(){
  protoc -I=./src/main/proto/ --java_out=./src/main/java ./src/main/proto/*
}

i-protoc(){
  unzip $1 -d protoc3
  sudo mv protoc3/bin/* /usr/local/bin/
  sudo mv protoc3/include/* /usr/local/include/
  sudo chown ${USER} /usr/local/bin/protoc
  sudo chown -R ${USER} /usr/local/include/google
}

# Examples
#
# syntax = "proto3";
#
# package example.simple;
#
# message SimpleMessage {
#   int32 id = 1;
#   bool is_simple = 2;
#   string name = 3;
#   repeated int32 sample_list = 4;
# }

# syntax = "proto3";
#
# package example.complex;
#
# message ComplexMessage {
#     DummyMessage one_dummy = 2;
#     repeated DummyMessage multiple_dummy = 3;
# }
#
# message DummyMessage {
#     int32 id = 1;
#     string name = 2;
# }


# syntax = "proto3";
#
# package example.enumerations;
#
# message EnumMessage {
#     int32 id = 1;
#     DayOfTheWeek day_of_the_week = 2;
# }
#
# enum DayOfTheWeek {
#     UNKNOWN = 0;
#     MONDAY = 1;
#     TUESDAY = 2;
#     WEDNESDAY = 3;
#     THURSDAY = 4;
#     FRIDAY = 5;
#     SATURDAY = 6;
#     SUNDAY = 7;
# }

# syntax = "proto3";
#
# package example.options;
#
# option java_package = "com.example.options";
# option java_multiple_files = true;
#
# message OptionMessageTest {
#   int32 id = 1;
#   bool is_simple = 2;
#   string name = 3;
#   repeated int32 sample_list = 4;
# }
#
# message OptionMessageOther {
#   string hello = 1;
# }
