#!/usr/bin/env python3

import logging
import sys

from amazon_kclpy import kcl
from samples import sample_kclpy_app

class RecordProcessor(sample_kclpy_app.RecordProcessor):
  """Override the process_record method for demo purposes."""
  def process_record(self, data, partition_key, sequence_number, sub_sequence_number):
    """
    Called for each record that is passed to process_records.

    :param str data: The blob of data that was contained in the record.
    :param str partition_key: The key associated with this record.
    :param int sequence_number: The sequence number associated with this record.
    :param int sub_sequence_number: the sub sequence number associated with this record.
    """
    logging.info('Here is what a logging message with a data of "%s" looks like.', data)
    print('Here is what it looks like when we print to stdout: data="{}"'.format(data), flush=True)
    print('Here is what it looks like when we print to stderr: data="{}"'.format(data), file=sys.stderr)

if __name__ == "__main__":
  kcl_process = kcl.KCLProcess(RecordProcessor())
  kcl_process.run()
